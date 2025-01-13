
import 'package:flexpaypromoter/src/constants/colors.dart';
import 'package:flexpaypromoter/src/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/text_string.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.black),
        title: Text(tAppName, style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
            decoration:  BoxDecoration(borderRadius: BorderRadius.circular(10), color: tCardBgColor),
            child: IconButton(onPressed: (){},icon: const Image(image:AssetImage( tUserProfileImage))),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDashboardPadding),
          child: Column(
          ),
        ),
      ),
    );
  }
}
