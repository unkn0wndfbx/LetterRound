import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme {
    return _isDarkMode ? darkTheme : lightTheme;
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    _saveTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
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
