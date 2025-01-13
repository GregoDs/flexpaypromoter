import 'dart:convert';
import 'package:flexpaypromoter/src/features/authentication/controllers/user_controller.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/bookings_screen/bookings.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/bookings_screen/make_bookings.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/commissions_screen/commissions.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/leaderboard_screen/leaderboard.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/navigation_bar/sidebar.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/validated_receipts/validated_receipts%20_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final UserController userController = Get.find<UserController>();
  final List<String> _previousSearches = ["FR6473652937", "FR8745632910"];
  final List<String> _validatedReceipts = [];

  Future<void> _validateReceipt(String slipNo) async {
    final userId = userController.getUserId();
    final bookingReference = userController.getBookingReference();
    final validatedAmount = userController.getBookingPrice();

    if (userId.isEmpty || bookingReference.isEmpty || validatedAmount.isEmpty) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Missing required information. Please try again.',
        onConfirm: () => Get.back(),
      );
      return;
    }

    final requestBody = {
      "user_id": userId,
      "booking_reference": bookingReference,
      "slip_no": slipNo,
      "validated_amount": validatedAmount,
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://bookings.flexpay.co.ke/api/promoters/validate-receipt'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          _validatedReceipts.add(slipNo);
          setState(() {});
          Get.defaultDialog(
            title: 'Success',
            middleText: 'Receipt has been validated.',
            onConfirm: () => Get.back(),
          );
        } else {
          Get.defaultDialog(
            title: 'Failure',
            middleText:
                'Receipt validation failed. Please check your slip number.',
            onConfirm: () => Get.back(),
          );
        }
      } else {
        Get.defaultDialog(
          title: 'Error',
          middleText: 'An error occurred. Please try again later.',
          onConfirm: () => Get.back(),
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Network Error',
        middleText:
            'Failed to connect. Please check your internet connection and try again.',
        onConfirm: () => Get.back(),
      );
    }
  }

  void _showPreviousSearchesOverlay() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Previous Searches'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: _previousSearches.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_previousSearches[index]),
                  onTap: () {
                    _searchController.text = _previousSearches[index];
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        appBar: AppBar(
          backgroundColor:
              isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Get.to(() => SideMenu(
                  isDarkModeon: true,
                )),
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: isDarkMode ? Colors.black87 : const Color(0xFF337687),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20),
                  child: _buildWelcomeSection(isDarkMode),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Action Center',
                        style: TextStyle(
                          fontFamily: 'UberMove',
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 50),
                      _buildLongFeatureBox(
                        'Make Bookings',
                        Icons.book_online,
                        Colors.purple,
                        () => Get.to(() => MakeBookings()),
                        isDarkMode,
                      ),
                      const SizedBox(height: 16),
                      _buildLongFeatureBox(
                        'Validated Receipt',
                        Icons.receipt_long,
                        Colors.blue,
                        () => Get.to(() => ValidatedReceiptsPage(
                            validatedReceipts: _validatedReceipts)),
                        isDarkMode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello Promoter,',
          style: TextStyle(
            fontFamily: 'UberMove',
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontFamily: 'UberMove',
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: isDarkMode ? Colors.white70 : Colors.white70,
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Validate receipt number...',
            hintStyle:
                TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.history),
              onPressed: _showPreviousSearchesOverlay,
            ),
            filled: true,
            fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey),
            ),
          ),
          onSubmitted: _validateReceipt,
        ),
        const SizedBox(height: 60),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFeatureBox('View Bookings', Icons.view_list, Colors.green,
                  () => Get.to(() => const Bookings()), isDarkMode),
              _buildFeatureBox(
                  'Commissions',
                  Icons.monetization_on,
                  Colors.yellow,
                  () => Get.to(() => const Commissions()),
                  isDarkMode),
              _buildFeatureBox('Leaderboard', Icons.leaderboard, Colors.orange,
                  () => Get.to(() => const Leaderboard()), isDarkMode),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureBox(String title, IconData icon, Color iconColor,
      Function onTap, bool isDarkMode) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'UberMove',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLongFeatureBox(String title, IconData icon, Color iconColor,
      Function onTap, bool isDarkMode) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'UberMove',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
