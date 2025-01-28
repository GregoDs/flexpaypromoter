import 'package:flexpaymerchandiser/features/screens/intropage.dart';
import 'package:flexpaymerchandiser/features/screens/loginscreen.dart';
import 'package:flexpaymerchandiser/features/screens/splashscreen.dart';
import 'package:flexpaymerchandiser/util/device/device_utility.dart';
import 'package:flexpaymerchandiser/util/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const FlexMerchandiserApp());
}

class FlexMerchandiserApp extends StatelessWidget {
  const FlexMerchandiserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            DeviceUtil.init(context); // Initialize DeviceUtil for screen utilities

            // Determine the screen width and height
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;

            // Log screen dimensions for debugging
            debugPrint("Screen Width: $screenWidth, Screen Height: $screenHeight");

            return GetMaterialApp(
              debugShowCheckedModeBanner: false, // Remove debug banner
              themeMode: ThemeMode.system,
              theme: TAppTheme.lightTheme,
              darkTheme: TAppTheme.darkTheme,
              initialRoute: '/',
              getPages: [
                GetPage(name: '/', page: () => const SplashScreen()),
                GetPage(name: '/onboarding', page: () => OnboardingScreen()),
                GetPage(name: '/login', page: () => LoginScreen()),
              ],
            );
          },
        );
      },
    );
  }
}