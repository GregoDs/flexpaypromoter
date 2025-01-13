
import 'package:flexpaypromoter/src/constants/sizes.dart';
import 'package:flexpaypromoter/src/features/authentication/controllers/user_controller.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/home_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_form_widget.dart';
import 'login_header_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final UserController userController = Get.find<UserController>();

//Redirect if user is already logged in
    if(userController.isLoggedIn.value){
      Future.microtask(() => Get.off(() => HomeScreen()));
    }
    

    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Move here
              children: [
                LoginHeaderWidget(size: size),
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

