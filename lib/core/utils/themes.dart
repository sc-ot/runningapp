import 'package:flutter/material.dart';

class Themes {
  static const primaryColor = Color(0xFF1267cc);
  static const accentColor = Color(0xFFaeeaff);
  static const backgroundColor = Color(0xFF16222d);
  final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Themes.backgroundColor,
    primaryColor: Themes.primaryColor,
    accentColor: Themes.accentColor,
    hintColor: accentColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Themes.primaryColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(color: Colors.white),
        ),
      ),
    ),
    iconTheme: IconThemeData(color: accentColor),
    inputDecorationTheme: InputDecorationTheme(
      
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: accentColor,
        ),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: accentColor,
        ),
      ),

    ),
  );
}
