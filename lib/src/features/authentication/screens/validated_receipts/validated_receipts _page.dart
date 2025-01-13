import 'dart:convert';
import 'package:flexpaypromoter/src/features/authentication/controllers/user_controller.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/navigation_bar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ValidatedReceiptsPage extends StatefulWidget {
  final List<String> validatedReceipts;

  const ValidatedReceiptsPage({super.key, required this.validatedReceipts});

  @override
  _ValidatedReceiptsPageState createState() => _ValidatedReceiptsPageState();
}

class _ValidatedReceiptsPageState extends State<ValidatedReceiptsPage> {
  final TextEditingController _searchController = TextEditingController();
  final UserController userController = Get.find<UserController>();
  bool _isLoading = false;  // Track loading state

  // Directly use widget.validatedReceipts instead of a separate list
  List<String> get validatedReceipts => widget.validatedReceipts;

  Future<void> _validateReceipt(String slipNo) async {
    setState(() {
      _isLoading = true;  // Start loading
    });

    final userId = userController.getUserId();
    final bookingReference = userController.getBookingReference();
    final validatedAmount = userController.getBookingPrice();

    if (userId.isEmpty || bookingReference.isEmpty || validatedAmount.isEmpty) {
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Missing required information. Please try again.',
        onConfirm: () => Get.back(),
      );
      setState(() {
        _isLoading = false;  // End loading
      });
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
        Uri.parse('https://bookings.flexpay.co.ke/api/promoters/validate-receipt'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          // Add the validated slipNo to the list and save it
          widget.validatedReceipts.add(slipNo);
          await _saveValidatedReceipts(widget.validatedReceipts);  // Save to SharedPreferences
          setState(() {});
          Get.defaultDialog(
            title: 'Success',
            middleText: 'Receipt $slipNo has been validated.',
            onConfirm: () => Get.back(),
          );
        } else {
          Get.defaultDialog(
            title: 'Failure',
            middleText: 'Receipt validation failed. Please check your slip number.',
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
        middleText: 'Failed to connect. Please check your internet connection and try again.',
        onConfirm: () => Get.back(),
      );
    } finally {
      setState(() {
        _isLoading = false;  // End loading
      });
    }
  }

  Future<void> _saveValidatedReceipts(List<String> receipts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('validatedReceipts', receipts);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final receiptsCount = validatedReceipts.length;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(isDarkMode),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ReceiptsListPage(receipts: validatedReceipts));
                    },
                    child: _buildStyledCard(
                      "Validated Receipts",
                      receiptsCount.toString(),
                      "Tap to view",
                      isDarkMode,
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),  // Show loading indicator
          ],
        ),
      ),
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

  Widget _buildHeaderSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      color: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Validated Bookings',
            style: GoogleFonts.montserrat(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can validate your bookings here:',
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Validate receipt number...',
              hintStyle: TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: isDarkMode ? Colors.grey[700]! : Colors.grey),
              ),
            ),
            onSubmitted: _validateReceipt,
          ),
        ],
      ),
    );
  }
}

class ReceiptsListPage extends StatelessWidget {
  final List<String> receipts;

  const ReceiptsListPage({super.key, required this.receipts});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final receiptsCount = receipts.length; // Count the number of validated receipts

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFF337687),
        title: Text(
          "All Validated Receipts ($receiptsCount)", // Show the count here
          style: GoogleFonts.montserrat(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: receipts.isNotEmpty
          ? ListView.builder(
        itemCount: receipts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              receipts[index],
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            leading: const Icon(Icons.receipt, color: Colors.grey),
          );
        },
      )
          : Center(
        child: Text(
          'No validated receipts found.',
          style: TextStyle(
            color: isDarkMode ? Colors.grey : Colors.black54,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}