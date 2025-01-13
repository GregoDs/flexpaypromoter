
import 'package:flexpaypromoter/src/features/authentication/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'info_card.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, bool isDarkModeon = false});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late final ThemeController themeController;

  @override
  void initState() {
    super.initState();
    themeController = Get.find<ThemeController>();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.5,
      child: Obx(() {
        final Color backgroundColor = themeController.isDarkMode.value ? Colors.black : const Color(0xFF337687);
        final Color iconColor = themeController.isDarkMode.value ? Colors.white : Colors.black;
        final Color accentColor = themeController.isDarkMode.value ? Colors.blueGrey : const Color(0xFF337687);

        return Container(
          color: backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              InfoCard(
                name: "FlexPay",
                profession: "Promoter",
                isDarkModeOn: themeController.isDarkMode.value,
              ),
              ListTile(
                leading: Icon(Icons.home, color: iconColor),
                title: Text("Home", style: TextStyle(color: iconColor)),
                onTap: () => Get.offNamed('/home'),
              ),
              ListTile(
                leading: Icon(Icons.book_online, color: iconColor),
                title: Text("Bookings", style: TextStyle(color: iconColor)),
                onTap: () => Get.offNamed('/bookings'),
              ),
              ListTile(
                leading: Icon(Icons.dark_mode, color: iconColor),
                title: Text('Dark Mode', style: TextStyle(color: iconColor)),
                trailing: Switch(
                  value: themeController.isDarkMode.value,
                  activeColor: accentColor,
                  onChanged: (val) => themeController.toggleTheme(),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: iconColor),
                title: Text('Logout', style: TextStyle(color: iconColor)),
                onTap: () => Navigator.pop(context),
              ),
              Divider(color: iconColor.withOpacity(0.2)),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
  }