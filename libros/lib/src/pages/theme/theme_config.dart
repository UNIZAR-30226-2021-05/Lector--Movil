import 'package:flutter/material.dart';
class ThemeConfig {
  static Color lightPrimary = Colors.white;
  static Color lightAccent = Colors.blueGrey;
  static Color lightBG = Colors.white;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    inputDecorationTheme: InputDecorationTheme(
      fillColor: lightBG,
      filled: true,
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: BorderSide(color: lightAccent, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: lightAccent)),
    ),

  );
}