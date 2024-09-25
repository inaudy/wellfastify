import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellfastify/core/constants/app_colors.dart';

TextStyle fontTheme = GoogleFonts.manrope();
TextStyle fontNumbers = GoogleFonts.manrope();

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kBackgroundColor,
  textTheme: TextTheme(
      bodyLarge: fontTheme.copyWith(color: Colors.black),
      displayMedium:
          fontTheme.copyWith(color: Color(0xff1C1C21), fontSize: 12)),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white, selectedItemColor: Colors.black),
);
