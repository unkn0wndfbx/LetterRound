import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letter_round/pages/bottom_bar.dart';
import 'package:letter_round/pages/credits_page.dart';
import 'package:letter_round/pages/settings_page.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;

    return SizedBox(
      width: 230,
      child: Drawer(
        elevation: 0,
        backgroundColor:
            themeProvider.isDarkMode ? backgroundColor : whiteColor,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                CupertinoIcons.person_fill,
                size: 26,
                color: greyColor,
              ),
              title: Text(
                loc.profil,
                style: TextStyle(
                  fontSize: 17,
                  color: themeProvider.isDarkMode ? whiteColor : blackColor,
                ),
              ),
              onTap:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomBar(initialIndex: 2),
                    ),
                  ),
            ),
            Divider(
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: greyColor.withValues(alpha: 0.3),
              height: 22,
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.settings,
                size: 26,
                color: greyColor,
              ),
              title: Text(
                loc.options,
                style: TextStyle(
                  fontSize: 17,
                  color: themeProvider.isDarkMode ? whiteColor : blackColor,
                ),
              ),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  ),
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.info_circle_fill,
                size: 26,
                color: greyColor,
              ),
              title: Text(
                loc.credits,
                style: TextStyle(
                  fontSize: 17,
                  color: themeProvider.isDarkMode ? whiteColor : blackColor,
                ),
              ),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreditsPage()),
                  ),
            ),
            Divider(
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: greyColor.withValues(alpha: 0.3),
              height: 22,
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.clear_fill,
                size: 26,
                color: red,
              ),
              title: Text(
                loc.quitter,
                style: TextStyle(
                  fontSize: 17,
                  color: red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => SystemNavigator.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
