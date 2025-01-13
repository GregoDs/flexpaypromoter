
import 'package:flexpaypromoter/src/constants/image_strings.dart';
import 'package:flutter/material.dart';


class  SplashScreen extends StatelessWidget {
  const  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
              child: Image(image: AssetImage(tSplashImage)),
          )
        ]
      )
    );
  }
}
