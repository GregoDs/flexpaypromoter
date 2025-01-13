import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../navigation_bar/sidebar.dart';
import '../../controllers/user_controller.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  Map<String, dynamic>? bookingsData;
  bool isLoading = true;
  final UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final userId = userController.getUserId();
    debugPrint('Fetching bookings for user ID: $userId');

    try {
      final responses = await Future.wait([
        http.get(Uri.parse('https://bookings.flexpay.co.ke/api/promoter/bookings/open/$userId')),
        http.get(Uri.parse('https://bookings.flexpay.co.ke/api/promoter/bookings/closed/$userId')),
        http.get(Uri.parse('https://bookings.flexpay.co.ke/api/promoter/bookings/redeemed/$userId')),
        http.get(Uri.parse('https://bookings.flexpay.co.ke/api/promoter/bookings/unserviced/$userId')),
      ]);

      for (int i = 0; i < responses.length; i++) {
        debugPrint('Response $i status code: ${responses[i].statusCode}');
        debugPrint('Response $i body: ${responses[i].body}');
      }

      final newBookingsData = {
        'Active Bookings': jsonDecode(responses[0].body),
        'Completed Bookings': jsonDecode(responses[1].body),
        'Redeemed Bookings': jsonDecode(responses[2].body),
        'Unserviced Bookings': jsonDecode(responses[3].body),
      };

      setState(() {
        bookingsData = newBookingsData;
        isLoading = false;
      });
    } catch (e, stacktrace) {
      debugPrint('Error fetching bookings: $e');
      debugPrint('Stacktrace: $stacktrace');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Get.to(() => SideMenu(isDarkModeon: true)),
        ),
        title: Text(
          "FlexPay",
          style: GoogleFonts.montserrat(
            fontSize: 33.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        toolbarHeight: 90.0,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  const Text(
                    "Fetching Booking Details....please wait",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : bookingsData == null || bookingsData!.isEmpty
              ? Center(
                  child: const Text(
                    "No bookings available.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(isDarkMode),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            _buildBookingCards(isDarkMode),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeaderSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      color: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'View Bookings',
            style: GoogleFonts.montserrat(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Below are your scheduled and past bookings.',
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildBookingCards(bool isDarkMode) {
    return Column(
      children: bookingsData!.entries.map((entry) {
        return GestureDetector(
          onTap: () {
            Get.to(() => BookingDetailScreen(
                  bookings: entry.value['data'],
                  title: entry.key,
                ));
          },
          child: _buildStyledCard(
            entry.key,
            entry.value['data']?.length?.toString() ?? '0',
            "Tap to view details",
            isDarkMode,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStyledCard(String title, String value, String message, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: isDarkMode ? Colors.white70 : Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class BookingDetailScreen extends StatelessWidget {
  final List<dynamic> bookings;
  final String title;

  const BookingDetailScreen({super.key, required this.bookings, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final item = bookings[index];
          final bool isRedeemed = item['redeemed_amount'] != null;
          final bool isActiveOrCompleted = item['progress'] != null;
          
          // Define details based on type
          final bookingDetails = isRedeemed
              ? {
                  'Booking Reference': item['booking_reference'] ?? '',
                  'Product Name': item['product_name'] ?? 'Redeemed Voucher',
                  'Booking Price': item['booking_price'] ?? '',
                  'Redeemed Amount': item['redeemed_amount'] ?? '',
                  'Redeemed Date': item['redeemed_date'] ?? '',
                  'Customer Phone': item['phone_number'] ?? '',
                  'Branch': item['outlet_name'] ?? '',
                }
              : isActiveOrCompleted
                  ? {
                      'Booking Reference': item['booking_reference'] ?? '',
                      'Product Name': item['product']?['product_name'] ?? '',
                      'Booking Price': item['booking_price'] ?? '',
                      'Progress': item['progress'] ?? '0',
                      'Interest Paid': (item['payment'] != null && item['payment'].isNotEmpty) 
                        ? item['payment'].first['payment_amount'] 
                        : '0',
                      'Customer Phone': item['customer']?['phone_number_1'] ?? '',
                      'Booking Date': item['created_at'] ?? '',
                      'Branch': item['outlet']?['outlet_name'] ?? '',
                    }
                  : null;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                bookingDetails?['Product Name'] ?? 'Booking Item',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Reference: ${bookingDetails?['Booking Reference']}'),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Booking Details'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: bookingDetails!.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text('${entry.key}: ${entry.value}'),
                            );
                          }).toList(),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
} 