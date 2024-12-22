import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness:  Brightness.light,
  colorScheme:  ColorScheme.light(
     surface: Colors.grey.shade100,
    primary: Colors.black,
 secondary:  const Color(0xFFE2B711),
  )
);

ThemeData darkMode = ThemeData(
  brightness:  Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF333437),
    primary: Colors.white,
    secondary:  Color(0xFFE2B711),
  )
);