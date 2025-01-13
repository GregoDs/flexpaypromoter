import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable theme mode
  var isDarkMode = false.obs;

  // Method to switch theme mode
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Initialize theme based on system settings
  @override
  void onInit() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    isDarkMode.value = brightness == Brightness.dark;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    super.onInit();
  }
}
