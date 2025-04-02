import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.isDarkMode ? backgroundColor : whiteColor,
      appBar: AppBar(
        backgroundColor:
            themeProvider.isDarkMode
                ? blackColor
                : greyColor.withValues(alpha: 0.3),
        elevation: 0,
        iconTheme: IconThemeData(
          size: 32,
          color: themeProvider.isDarkMode ? whiteColor : blackColor,
        ),
        title: Text(
          'Options',
          style: TextStyle(
            color: themeProvider.isDarkMode ? whiteColor : blackColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(CupertinoIcons.back, size: 32),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    themeProvider.isDarkMode
                        ? blackColor
                        : greyColor.withValues(alpha: 0.25),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Text(
                    "Thème",
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? whiteColor : blackColor,
                      fontSize: 17,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    CupertinoIcons.sun_min_fill,
                    size: 32,
                    color: themeProvider.isDarkMode ? greyColor : blackColor,
                  ),
                  SizedBox(width: 4),
                  CupertinoSwitch(
                    activeTrackColor: yellow,
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  ),
                  SizedBox(width: 4),
                  Icon(
                    CupertinoIcons.moon_fill,
                    size: 32,
                    color: themeProvider.isDarkMode ? whiteColor : greyColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: Column(
                  spacing: 1,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color:
                            themeProvider.isDarkMode
                                ? greyColor
                                : greyColor.withValues(alpha: 0.35),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '© 2025 LetterRound',
                      style: TextStyle(
                        color:
                            themeProvider.isDarkMode
                                ? greyColor
                                : greyColor.withValues(alpha: 0.35),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Rights Reserved',
                      style: TextStyle(
                        color:
                            themeProvider.isDarkMode
                                ? greyColor
                                : greyColor.withValues(alpha: 0.35),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Made in France',
                      style: TextStyle(
                        color:
                            themeProvider.isDarkMode
                                ? greyColor
                                : greyColor.withValues(alpha: 0.35),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
