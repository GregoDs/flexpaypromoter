import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme{

  TTextTheme._();//to avoid outside users creating instances

   static   TextTheme lightTextTheme = TextTheme(
           headlineLarge:GoogleFonts.montserrat(fontSize: 33.0, fontWeight: FontWeight.bold, color: Colors.lightBlue,),

   );


   static TextTheme darkTextTheme = TextTheme(
       headlineLarge:GoogleFonts.montserrat(fontSize: 33.0, fontWeight: FontWeight.bold, color: Colors.lightBlue,),
   );
}