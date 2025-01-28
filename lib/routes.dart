import 'package:flexpaymerchandiser/features/screens/homescreen.dart';
import 'package:flexpaymerchandiser/features/screens/intropage.dart';
import 'package:flexpaymerchandiser/features/screens/loginscreen.dart';
import 'package:flexpaymerchandiser/features/screens/otpverificationscreen.dart';
import 'package:flexpaymerchandiser/features/screens/splashscreen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(), // SplashScreen as the initial route
  '/onboarding': (context) => OnboardingScreen(),
  '/login': (context) => LoginScreen(),
  '/otpverification': (context) => const OTPScreen(
        phoneNumber: '',
      ),
  '/home': (context) =>  HomeScreen(isDarkModeOn: false),
};
