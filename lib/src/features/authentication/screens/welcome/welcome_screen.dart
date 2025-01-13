
import 'package:flexpaypromoter/src/constants/colors.dart';
import 'package:flexpaypromoter/src/constants/sizes.dart';
import 'package:flexpaypromoter/src/constants/text_string.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login/login_screen.dart';
import '../navigation_bar/navigation_bar.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize NavigationController here
    Get.put(NavigationController());

    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  tWelcomeTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  tWelcomeSubTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => const LoginScreen()),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: tSecondaryColor,
                      side: BorderSide(color: tSecondaryColor),
                      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
                    ),
                    child: Text(tLogin.toUpperCase()),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const SignupScreen()),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: tWhiteColor,
                      backgroundColor: tSecondaryColor,
                      side: BorderSide(color: tSecondaryColor),
                      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
                    ),
                    child: Text(tSignup.toUpperCase()),
                  ),
                ),
              ],
            ),
            // Add a button to navigate to NavigationMenu

          ],
        ),
      ),
    );
  }
}
