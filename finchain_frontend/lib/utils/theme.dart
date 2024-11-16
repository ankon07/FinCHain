import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      fontFamily: "Poppins",
      primaryColor: const Color(0xFF006666),
      canvasColor: const Color(0xFFD8EBEB),
      primaryColorLight: const Color(0xFFD9D9D9),
      secondaryHeaderColor: const Color(0xFF848282),
      dialogBackgroundColor: const Color(0xFFEAEAEA),
      disabledColor: const Color(0xFF848282),
    );
  }
}
