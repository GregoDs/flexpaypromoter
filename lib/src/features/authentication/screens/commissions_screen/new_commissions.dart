import 'dart:convert';
import 'package:flexpaypromoter/src/features/authentication/screens/navigation_bar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/sizes.dart';
import '../../controllers/user_controller.dart';

class NewCommissions extends StatefulWidget {
  const NewCommissions({super.key});

  @override
  State<NewCommissions> createState() => _NewCommissionsState();
}

class _NewCommissionsState extends State<NewCommissions> {
  Map<String, dynamic>? commissionsData;
  bool isLoading = true;
  String filter = 'week';
  final UserController userController = Get.find();

  @override
  void initState() {
    super.initState();
    _fetchCommissions();
  }

  Future<void> _fetchCommissions() async {
    final userId = userController.getUserId();

    final response = await http.post(
      Uri.parse('https://bookings.flexpay.co.ke/api/promoters/commissions'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'duration': filter,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];

      setState(() {
        commissionsData = data;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load commissions data');
    }
  }

  void _filterData(String timeFilter) {
    setState(() {
      filter = timeFilter;
      isLoading = true;
      _fetchCommissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        // Prevent going back to other pages if logged in
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
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
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(isDarkMode),
                    Padding(
                      padding: const EdgeInsets.all(tDashboardPadding),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildFilterTab(isDarkMode),
                          const SizedBox(height: 20),
                          _buildCommissionsAndDeficit(isDarkMode),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildWelcomeSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      color: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello Promoter,',
            style: TextStyle(
              fontFamily: 'UberMove',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Commissions data is as follows:',
            style: TextStyle(
              fontFamily: 'UberMove',
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

  Widget _buildFilterTab(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTabButton("Weekly", 'week', isDarkMode),
          _buildTabButton("Monthly", 'month', isDarkMode),
          _buildTabButton("Yearly", 'year', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String value, bool isDarkMode) {
    final isSelected = filter == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => _filterData(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? (isDarkMode ? const Color(0xFF337687) : Colors.black) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : (isDarkMode ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommissionsAndDeficit(bool isDarkMode) {
    return Column(
      children: [
        _buildStyledCard(
          "Total Commissions",
          commissionsData?['totalCommissions']?.toString() ?? '0',
          "Keep up the good work!",
          isDarkMode,
        ),
        const SizedBox(height: 20),
        _buildStyledCard(
          "Deficit",
          commissionsData?['deficit']?.toString() ?? '0',
          "Strive to reach your goal!",
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildStyledCard(String title, String value, String message, bool isDarkMode) {
    return Container(
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
