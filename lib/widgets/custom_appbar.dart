import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/pages/settings_page.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.themeProvider});

  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          themeProvider.isDarkMode
              ? blackColor
              : greyColor.withValues(alpha: 0.3),
      elevation: 0,
      iconTheme: IconThemeData(
        size: 32,
        color: themeProvider.isDarkMode ? whiteColor : blackColor,
      ),
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(CupertinoIcons.bars, size: 32),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
          icon: Icon(CupertinoIcons.settings, size: 32),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
