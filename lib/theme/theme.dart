import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness:  Brightness.light,
  colorScheme:  ColorScheme.light(
     surface: Colors.grey.shade100,
    primary: Colors.black,
    secondary: Colors.amber,
  )
);

ThemeData darkMode = ThemeData(
  brightness:  Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.white,
    secondary: Colors.amber,
  )
);