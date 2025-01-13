
import 'package:flexpaypromoter/src/features/authentication/screens/bookings_screen/bookings.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/commissions_screen/commissions.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/leaderboard_screen/leaderboard.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/navigation_bar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home_screen/home.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final NavigationController controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: Stack(
        children: [
          Obx(() => IndexedStack(
                index: controller.selectedIndex.value,
                children: controller.screens,
              )),
          Obx(() {
            return controller.isMenuOpen.value
                ? GestureDetector(
                    onTap: controller.closeMenu,
                    child: Container(
                      color: Colors.black54,
                      child: SideMenu(isDarkModeon: true),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) {
              controller.updateIndex(index);
              controller.closeMenu();
            },
            backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: isDarkMode ? Colors.grey[400] : Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.attach_money),
                label: 'Commissions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard),
                label: 'Leaderboard',
              ),
            ],
          )),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Rx<bool> isMenuOpen = false.obs;

  final screens = [
    const HomeScreen(),
    const Bookings(),
    const Commissions(),
    const Leaderboard(),
    
  ];

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  void toggleMenu() {
    isMenuOpen.value = !isMenuOpen.value;
  }

  void closeMenu() {
    isMenuOpen.value = false;
  }

  void openMenu() {
    isMenuOpen.value = true;
  }
}
