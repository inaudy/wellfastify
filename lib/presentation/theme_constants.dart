import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//ligththeme
ThemeData ligthTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: fontTheme,
);

// darktheme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: fontTheme,
);

//Global font
TextTheme fontTheme = GoogleFonts.openSansTextTheme();

// Boxes widget shadow and borders
BoxDecoration boxWidgetsDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.all(
      Radius.circular(16),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.indigo.withOpacity(0),
        spreadRadius: 4,
        blurRadius: 20,
      )
    ]);
Color color1 = Colors.indigo;
