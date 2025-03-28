import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/api/movie_service.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/pages/settings_page.dart';
import 'package:letter_round/ressources/colors.dart';

import 'nav_bar.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = MovieService().fetchMovies('Inception');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
        iconTheme: const IconThemeData(size: 32, color: whiteColor),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(CupertinoIcons.bars, size: 32, color: whiteColor),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              icon: Icon(CupertinoIcons.settings, size: 32, color: whiteColor),
            ),
          ),
        ],
      ),
      drawer: NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.transparent),
              padding: const EdgeInsets.only(left: 15, bottom: 35, top: 10),
              child: const Text(
                'Ma Cinémathèque',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
