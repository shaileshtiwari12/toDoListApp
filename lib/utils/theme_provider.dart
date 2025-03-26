// utils/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey.shade900,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    ),
    cardTheme: CardTheme(
      color: Colors.grey.shade900,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
