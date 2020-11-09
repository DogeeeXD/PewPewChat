import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF8f96dd),
    primaryColorBrightness: Brightness.light,
    accentColor: Color(0xFFDDE2EC),
    accentColorBrightness: Brightness.light,
    highlightColor: Color(0xFF8F96DD),
    indicatorColor: Color(0xFF8F96DD),
    errorColor: Color(0xFFdd8f8f),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Color(0xFFf5f6fa),
    appBarTheme: AppBarTheme(
      color: Color(0xFFdde2ec),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    // colorScheme: ColorScheme.light(
    //   primary: Color(0xFFF5F6FA),
    //   onPrimary: Color(0xFF252F3D),
    //   primaryVariant: Color(0xFFC0CADC),
    //   secondary: Color(0xFF8F96DD),
    //   error: Color(0xFF8F96DD),
    // ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFFdde2ec),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // cardTheme: CardTheme(),
    // iconTheme: IconThemeData(
    //   color: Color(0xFF252F3D),
    // ),
    primaryTextTheme: TextTheme(
      headline6: TextStyle(
        color: Color(0xFF252F3D),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF252F3D),
    scaffoldBackgroundColor: Colors.black,
    backgroundColor: Color(0xFF252F3D),
    appBarTheme: AppBarTheme(
      color: Color(0xFF252F3D),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF252F3D),
      onPrimary: Color(0xFFF5F6FA),
      primaryVariant: Color(0xFFC0CADC),
      secondary: Color(0xFF8F96DD),
      error: Color(0xFF8F96DD),
    ),
    buttonTheme: ButtonThemeData(),
    cardTheme: CardTheme(),
    iconTheme: IconThemeData(),
    textTheme: TextTheme(),
  );
}
