
import 'package:flexpaypromoter/src/constants/sizes.dart';
import 'package:flexpaypromoter/src/constants/text_string.dart';
import 'package:flexpaypromoter/src/features/authentication/screens/navigation_bar/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class OtpSuccessScreen extends StatelessWidget {
  const OtpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(tOtpSuccessTitle, style: GoogleFonts.montserrat(
              fontSize: 40.0,
              fontWeight: FontWeight.bold
            ),),
            const SizedBox(height: 20.0,),
            Text(tOtpSuccessSubTitle, style: GoogleFonts.montserrat(
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),),
            const SizedBox(height: 20.0,),
            SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () => Get.to(() => const NavigationMenu()),
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: const Color(0xFF337687), // Set the text color
    ),
    child: const Text(tOtpProceedButton),
  ),
),

          ],
        ),
      ),
    );
  }
}
