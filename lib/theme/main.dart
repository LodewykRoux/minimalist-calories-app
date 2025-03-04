import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainTheme {
  late ThemeData _mainTheme;

  ThemeData get mainTheme => _mainTheme;

  MainTheme() {
    final baseTheme = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.white,
        onSecondary: Colors.black,
        error: Colors.white,
        onError: Colors.black,
        background: Colors.black,
        onBackground: Colors.white,
        surface: Colors.black,
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.black,
        elevation: 0,
        toolbarTextStyle: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        unselectedLabelStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w200,
          fontSize: 17,
        ),
      ),
    );

    _mainTheme = baseTheme.copyWith(
      textTheme: GoogleFonts.montserratTextTheme(baseTheme.textTheme),
    );
  }
}
