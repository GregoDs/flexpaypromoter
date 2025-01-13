
import 'dart:async';

import 'package:flexpaypromoter/src/features/authentication/controllers/theme_controller.dart';
import 'package:flexpaypromoter/src/features/authentication/controllers/user_controller.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/bookings_screen/bookings.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/home_screen/home.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/login/login_screen.dart';
import 'package:flexpaypromoter/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  // Initialize the controllers here
  Get.put(UserController());
  Get.put(ThemeController());

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/splash', // Set initial route
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/bookings', page: () => const Bookings()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        // Add other routes here as needed
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _sessionTimer;


@override
void initState() {
  super.initState();
  
  // Set up the AnimationController
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

  // Start the animation
  _controller.forward();

  // Check session and navigate after the animation completes
  _controller.addStatusListener((status) async {
    if (status == AnimationStatus.completed) {
      await _checkSession();
    }
  });
}

Future<void> _checkSession() async {
  bool isLoggedIn = Get.find<UserController>().isLoggedIn();

  if (isLoggedIn) {
    Get.offNamed('/home');
  } else {
    Get.offNamed('/login');
  }
}



  void _handleSessionTimeout() {
    // Logic to handle session expiration
    Get.offNamed('/login'); // Use Get for navigation
  }

  @override
  void dispose() {
    _controller.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF337687),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/logo/logo.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
