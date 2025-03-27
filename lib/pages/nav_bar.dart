import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letter_round/pages/bottom_bar.dart';
import 'package:letter_round/ressources/colors.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Drawer(
        elevation: 0,
        backgroundColor: backgroundColor,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.person_rounded,
                size: 26,
                color: greyColor,
              ),
              title: const Text(
                "Profil",
                style: TextStyle(fontSize: 17, color: whiteColor),
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
                Icons.settings_rounded,
                size: 26,
                color: greyColor,
              ),
              title: const Text(
                "Options",
                style: TextStyle(fontSize: 17, color: whiteColor),
              ),
              /*  onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  ), */
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.info_circle_fill,
                size: 26,
                color: greyColor,
              ),
              title: const Text(
                "Crédits",
                style: TextStyle(fontSize: 17, color: whiteColor),
              ),
              /*  onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  ), */
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
                Icons.exit_to_app_rounded,
                size: 26,
                color: red,
              ),
              title: const Text(
                "Quitter",
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
