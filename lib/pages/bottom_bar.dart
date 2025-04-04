import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/pages/films_page.dart';
import 'package:letter_round/pages/home_page.dart';
import 'package:letter_round/pages/profile_page.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomBar extends StatefulWidget {
  final int initialIndex;

  const BottomBar({super.key, required this.initialIndex});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  setCurrentIndex(int index) {
    if (index >= 0 && index < 3) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? backgroundColor : whiteColor,
      body:
      [
        const HomePage(),
        const FilmsPage(),
        const ProfilPage(),
      ][_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
        currentIndex: _currentIndex,
        onTap: (index) => setCurrentIndex(index),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.house_fill),
            title: Text(loc.accueil),
            selectedColor: themeProvider.isDarkMode ? whiteColor : blackColor,
            unselectedColor:
            themeProvider.isDarkMode
                ? whiteColor.withValues(alpha: .45)
                : blackColor.withValues(alpha: .45),
          ),
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.film_fill),
            title: Text(loc.films),
            selectedColor: themeProvider.isDarkMode ? whiteColor : blackColor,
            unselectedColor:
            themeProvider.isDarkMode
                ? whiteColor.withValues(alpha: .45)
                : blackColor.withValues(alpha: .45),
          ),
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.person_fill),
            title: Text(loc.profil),
            selectedColor: themeProvider.isDarkMode ? whiteColor : blackColor,
            unselectedColor:
            themeProvider.isDarkMode
                ? whiteColor.withValues(alpha: .45)
                : blackColor.withValues(alpha: .45),
          ),
        ],
      ),
    );
  }
}
