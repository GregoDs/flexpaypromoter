import 'package:flexpaypromoter/src/constants/sizes.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/otp/otp_screen.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:developer'; // <-- Import for logging
import '../../../../constants/text_string.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final phoneController = TextEditingController();

  // Method to send OTP request
  Future<void> _requestOtp() async {
    String phoneNumber = phoneController.text.trim();

    if (phoneNumber.isNotEmpty) {
      try {
        var response = await http.post(
          Uri.parse('https://www.flexpay.co.ke/users/api/app/promoter/send-otp'),//parse a url string into object form
          body: {
            'phone_number': phoneNumber,
          },
        );

        if (response.statusCode == 200) {
          // OTP sent successfully
          log('OTP sent to $phoneNumber');

          // Navigate to OTP screen, passing the phone number
          Get.to(() => OTPScreen(phoneNumber: phoneNumber));
        } else {
          log('Failed to send OTP');
        }
      } catch (e) {
        log('Error: $e');
      }
    } else {
      log('Please enter your phone number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: tPhoneNumber,
                hintText: tPhoneNumber,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(tForgetPassword),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _requestOtp(),
                child: Text(tLogin.toUpperCase()),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextButton(
              onPressed: () => Get.to(() => const SignupScreen()),
              child: Text(tDontHaveAnAccount),
            ),
          ],
        ),
      ),
    );
  }
}
