import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                    _infoText('Version 1.0.0', themeProvider.isDarkMode),
                    _infoText('© 2025 LetterRound', themeProvider.isDarkMode),
                    _infoText('Rights Reserved', themeProvider.isDarkMode),
                    _infoText('Made in France', themeProvider.isDarkMode),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoText(String text, bool isDarkMode) {
    return Text(
      text,
      style: TextStyle(
        color: isDarkMode ? greyColor : greyColor.withOpacity(0.35),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
