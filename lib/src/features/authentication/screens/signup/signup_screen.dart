
import 'package:flexpaypromoter/src/constants/image_strings.dart';
import 'package:flexpaypromoter/src/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/form/form_header_widget.dart';
import '../../../../constants/text_string.dart';
import '../login/login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHeaderWidget(
                  image: tWelcomeScreenImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: tFormHeight - 10),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: tFormHeight-20,),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text(tFirstName),
                            hintText: tFirstName,
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: tFormHeight-20,),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text(tSurName),
                            hintText: tSurName,
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: tFormHeight-20,),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text(tPhoneNumber),
                            hintText: tPhoneNumber,
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: tFormHeight-20,),  // Add this line to match the spacing
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (){},
                            child: Text(tSignup.toUpperCase()),
                          ),
                        ),
                        SizedBox(height: tFormHeight,),
                        Center(
                          child: Column(
                            children: [
                              const Text('Or'),
                              TextButton(
                                onPressed: () => Get.to(() =>  const LoginScreen()),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: tAlreadyHaveAnAccount,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      TextSpan(
                                        text: tLogin.toUpperCase(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
