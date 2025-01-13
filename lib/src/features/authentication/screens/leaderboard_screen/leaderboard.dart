import 'dart:convert';
import 'package:flexpaypromoter/src/features/authentication/screens/navigation_bar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

const tLeaderboardName = 'Leaderboard';
const tGoldColor = Color(0xFFFFD700); // Gold color
const tLightCardBgColor = Color(0xFFF5F5F5); // Light mode card background
const tDarkCardBgColor = Color(0xFF1E1E1E); // Dark mode card background
const tDarkBgColor = Color(0xFF121212); // Dark mode background
const tDashboardPadding = 16.0;

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<dynamic> leaderboardData = [];

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    final response = await http.get(Uri.parse('https://bookings.flexpay.co.ke/api/promoters/top/211422'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      data.sort((a, b) => (b['total_amount'] as num).compareTo(a['total_amount'] as num));
      setState(() {
        leaderboardData = data;
      });
    } else {
      throw Exception('Failed to load leaderboard data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current system theme is dark
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        //Prevent going back to other pages if logged in
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[850] : const Color(0xFF337687),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => Get.to(() => SideMenu(isDarkModeon: true,)),
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
            ),],
        elevation: 0,
        // Set preferredSize to increase AppBar size
        toolbarHeight: 100.0, // You can adjust this height as needed
      ),
        backgroundColor: isDarkMode ? tDarkBgColor : tGoldColor,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDashboardPadding),
            color: isDarkMode ? tDarkBgColor : tGoldColor,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/dashboard_images/Leaderboard1.png',
                  width: 200,
                ),
                const SizedBox(height: 20),
                leaderboardData.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: leaderboardData.length,
                        itemBuilder: (context, index) {
                          final user = leaderboardData[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isDarkMode ? tDarkCardBgColor : tLightCardBgColor,
                              boxShadow: index == 0
                                  ? [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.6),
                                        blurRadius: 10,
                                        spreadRadius: 5,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${index + 1}', // Rank
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: index == 0 ? Colors.amber : (isDarkMode ? Colors.white : Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Text(
                                      '${user["first_name"].substring(0, user["first_name"].length - 1).replaceAll(RegExp(r'.'), '*')}${user["first_name"].substring(user["first_name"].length - 1)} ${user["last_name"].substring(0, user["last_name"].length - 1).replaceAll(RegExp(r'.'), '*')}${user["last_name"].substring(user["last_name"].length - 1)}',
                                      style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                      ),

                                      const SizedBox(height: 4),
                                      Text(
                                        '${user["booking_count"]} Bookings',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                          color: isDarkMode ? Colors.grey : Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        'Ksh ${user["total_amount"].toStringAsFixed(2)}', // Commission Earned
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 14,
                                          color: isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
