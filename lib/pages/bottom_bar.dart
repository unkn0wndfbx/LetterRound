import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/pages/films_page.dart';
import 'package:letter_round/pages/home_page.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: Scaffold(
        backgroundColor: backgroundColor,
        body:
            [
              const HomePage(),
              const FilmsPage(),
              const HomePage(),
            ][_currentIndex],
        bottomNavigationBar: SalomonBottomBar(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.home),
              title: const Text('Accueil'),
              selectedColor: whiteColor,
              unselectedColor: whiteColor.withValues(alpha: .45),
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.film_fill),
              title: const Text('Films'),
              selectedColor: whiteColor,
              unselectedColor: whiteColor.withOpacity(.45),
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.person_fill),
              title: const Text('Profil'),
              selectedColor: whiteColor,
              unselectedColor: whiteColor.withOpacity(.45),
            ),
          ],
        ),
      ),
    );
  }
}
