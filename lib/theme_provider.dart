import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme {
    return isDarkMode ? darkTheme : lightTheme;
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: whiteColor,
  primaryColor: yellow,
  appBarTheme: AppBarTheme(
    backgroundColor: yellow,
    iconTheme: IconThemeData(color: blackColor),
  ),
  textTheme: TextTheme(bodyLarge: TextStyle(color: blackColor)),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: backgroundColor,
  primaryColor: yellow,
  appBarTheme: AppBarTheme(
    backgroundColor: blackColor,
    iconTheme: IconThemeData(color: whiteColor),
  ),
  textTheme: TextTheme(bodyLarge: TextStyle(color: whiteColor)),
);
