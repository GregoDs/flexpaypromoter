import 'package:flexpaypromoter/src/constants/image_strings.dart';
import 'package:flutter/material.dart';

import '../../../../constants/text_string.dart';


class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: AssetImage(tWelcomeScreenImage),
          height: size.height * 0.2,
        ),
        Text(
  tLoginTitle,
  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
    color: const Color(0xFF337687),
  ),
  textAlign: TextAlign.center,
),

        Text(
  tLoginSubTitle,
  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
    color: const Color(0xFF337687),
  ),
  textAlign: TextAlign.center,
),

        /* -- /.end -- */

      ],
    );
  }
}
