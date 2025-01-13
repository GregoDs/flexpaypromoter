import 'package:flexpaypromoter/src/features/authentication/screens/bookings_screen/bookings.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/bookings_screen/make_bookings.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/commissions_screen/commissions.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/home_screen/home.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/leaderboard_screen/leaderboard.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;
  var isMenuOpen = false.obs;

  final screens = [
    HomeScreen(),
    MakeBookings(),
    Bookings(),
    Commissions(),
    Leaderboard(),
  ];

  void updateIndex(int index) {
    selectedIndex.value = index;
    closeMenu();
  }

  void toggleMenu() {
    isMenuOpen.value = !isMenuOpen.value;
  }

  void closeMenu() {
    isMenuOpen.value = false;
  }
}
