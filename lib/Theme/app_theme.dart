import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class EznestTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.workSans(
        fontSize: 93, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    displayMedium: GoogleFonts.workSans(
        fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall: GoogleFonts.workSans(fontSize: 47, fontWeight: FontWeight.w400),
    headlineMedium: GoogleFonts.workSans(
        fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineSmall: GoogleFonts.workSans(fontSize: 23, fontWeight: FontWeight.w400),
    titleLarge: GoogleFonts.workSans(
        fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleMedium: GoogleFonts.workSans(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    titleSmall: GoogleFonts.workSans(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: GoogleFonts.workSans(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: GoogleFonts.workSans(
        fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    labelLarge: GoogleFonts.workSans(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    bodySmall: GoogleFonts.workSans(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelSmall: GoogleFonts.workSans(
        fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),);

  static ThemeData light() {
    ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Color(0x274D62),
    );

    return ThemeData(
      useMaterial3: true,
      textTheme: lightTextTheme,
      colorScheme: colorScheme,
    );
  }

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.workSans(
        fontSize: 93, fontWeight: FontWeight.w300, letterSpacing: -1.5, color: Colors.white),
    displayMedium: GoogleFonts.workSans(
        fontSize: 58, fontWeight: FontWeight.w300, letterSpacing: -0.5, color: Colors.white),
    displaySmall: GoogleFonts.workSans(fontSize: 47, fontWeight: FontWeight.w400, color: Colors.white),
    headlineMedium: GoogleFonts.workSans(
        fontSize: 33, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: Colors.white),
    headlineSmall: GoogleFonts.workSans(fontSize: 23, fontWeight: FontWeight.w400, color: Colors.white),
    titleLarge: GoogleFonts.workSans(
        fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: Colors.white),
    titleMedium: GoogleFonts.workSans(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: Colors.white),
    titleSmall: GoogleFonts.workSans(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: Colors.white),
    bodyLarge: GoogleFonts.workSans(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: Colors.white),
    bodyMedium: GoogleFonts.workSans(
        fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: Colors.white),
    labelLarge: GoogleFonts.workSans(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25, color: Colors.white),
    bodySmall: GoogleFonts.workSans(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: Colors.white),
    labelSmall: GoogleFonts.workSans(
        fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5, color: Colors.white)
  );

  static ThemeData dark() {
    ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Color(0x004C6B),
    );

    return ThemeData(
      useMaterial3: true,
      textTheme: darkTextTheme,
      colorScheme: colorScheme,
    );
  }
}
