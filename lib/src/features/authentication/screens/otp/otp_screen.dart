import 'dart:convert';
import 'dart:developer';

import 'package:flexpaypromoter/src/constants/sizes.dart';
import 'package:flexpaypromoter/src/constants/text_string.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/otp/otp_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../controllers/user_controller.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final UserController userController = Get.put(UserController());
  bool _isLoading = false;
  String _otp = '';
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());


Future<void> _verifyOtp() async {
  setState(() {
    _isLoading = true;
  });

  final url = Uri.parse('https://www.flexpay.co.ke/users/api/app/promoter/verify-otp');
  try {
    final response = await http.post(
      url,
      body: {
        'phone_number': widget.phoneNumber,
        'otp': _otp,
      },
    );

    log("Response Body: ${response.body}");

    setState(() {
      _isLoading = false;
    });

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      final userId = responseData['data']['user']['id'];
      final token = responseData['data']['token'];
     if (responseData.containsKey('data') && responseData['data'].containsKey('token')) {
  log("Received Token: $token");
} else {
  log("Token not found in response: $responseData");
}
      userController.phoneNumber.value = widget.phoneNumber;
      userController.setUserId(userId.toString());
      userController.loginUser(token); // Save the token in UserController

      // Ensure token verification is complete before navigating
      await _verifyToken();

      // Use Get.offAll to clear the navigation stack and navigate to OTP Success Screen
      Get.offAll(() => const OtpSuccessScreen());
    } else {
      final errors = responseData['errors'];
      final errorMessage = errors.isNotEmpty && errors[0] == "Your passcode has expired. Click Resend to get a new one."
          ? "Your OTP has expired. Click Resend to get a new one."
          : "Error verifying OTP. Please try again.";
      _showErrorDialog(errorMessage);
    }
  } catch (error) {
    setState(() {
      _isLoading = false;
    });
    _showErrorDialog("An error occurred. Please check your connection and try again.");
  }
}



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resendOtp() async {
    final url = Uri.parse('https://www.flexpay.co.ke/users/api/app/promoter/send-otp');
    try {
      final response = await http.post(
        url,
        body: {
          'phone_number': widget.phoneNumber,
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        log("OTP resent to ${widget.phoneNumber}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP resent successfully")),
        );
      } else {
        _showErrorDialog("Failed to resend OTP. Please try again.");
      }
    } catch (error) {
      _showErrorDialog("An error occurred while resending OTP. Please check your connection.");
    }
  }


  Future<void> _verifyToken() async {
  final url = Uri.parse('https://flexpay.co.ke/users/api/verify-token');
  final token = userController.getToken(); // Get token from UserController

  if (token.isEmpty) {
    log('No token found. Please log in.');
    return;
  }

  log("Verifying Token: $token");  // Log the token here

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode == 200) {
      log('Token is valid.');
    } else {
      log('Token is invalid or expired. Please log in again.');
      userController.logoutUser(); // Clear token and log out user
    }
  } catch (error) {
    log('Error verifying token: $error');
  }
}

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tOtpTitle,
                style: GoogleFonts.montserrat(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
              Text(
                tOtpSubTitle.toUpperCase(),
                style: GoogleFonts.montserrat(fontSize: 20.0),
              ),
              const SizedBox(height: 40.0),
              Text(
                'OTP sent to ${widget.phoneNumber}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        setState(() {
                          _otp = _controllers.map((controller) => controller.text).join();
                        });
                      },
                      decoration: const InputDecoration(
                        counterText: '',
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20.0),

              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _otp.length == 4 ? _verifyOtp : null,
                            child: const Text(tVerify),
                          ),
                        ),
                        TextButton(
                          onPressed: _resendOtp,
                          child: const Text("Resend OTP"),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
