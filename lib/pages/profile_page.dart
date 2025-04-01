import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/api/movie_service.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/pages/settings_page.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/film_card.dart';
import '../widgets/search_bar.dart';
import 'nav_bar.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late Future<List<Movie>> futureMovies;
  List<Movie> displayedMovies = [];
  double averageRating = 0.0;
  int totalMovies = 0;
  double totalHours = 0.0;

  Future<List<Movie>> _getSeenMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.endsWith('_seen')).toList();

    List<Movie> seenMovies = [];
    double totalRating = 0;
    totalMovies = 0;
    totalHours = 0;

    for (String key in keys) {
      bool hasSeen = prefs.getBool(key) ?? false;
      if (hasSeen) {
        String imdbId = key.replaceAll('_seen', '');
        Movie movie = await MovieService().fetchMovie(imdbId);

        int userRating = prefs.getInt('${imdbId}_rating') ?? 0;
        movie.stars = userRating;

        seenMovies.add(movie);
        totalRating += userRating;
        totalMovies++;
        totalHours += _convertRuntimeToHours(movie.runtime);
      }
    }

    if (totalMovies > 0) {
      averageRating = totalRating / totalMovies;
    }

    return seenMovies;
  }

  double _convertRuntimeToHours(String runtime) {
    int totalMinutes = int.tryParse(runtime.replaceAll(' min', '')) ?? 0;
    return totalMinutes / 60.0;
  }

  @override
  void initState() {
    super.initState();
    futureMovies = _getSeenMovies();
    futureMovies.then((movies) {
      setState(() {
        displayedMovies = movies;
      });
    });
  }

  void _updateMovies(List<Movie> movies) {
    setState(() {
      displayedMovies = movies;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      futureMovies = _getSeenMovies();
    });
    futureMovies.then((movies) {
      setState(() {
        displayedMovies = movies;
      });
    });
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: const Text(
                  'Ma Cinémathèque',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: greyColor.withValues(alpha: 0.25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Note Moyenne",
                          style: TextStyle(color: greyColor, fontSize: 14),
                        ),
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            color: blue,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Films vus",
                          style: TextStyle(color: greyColor, fontSize: 14),
                        ),
                        Text(
                          totalMovies.toString(),
                          style: TextStyle(
                            color: blue,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Total heures",
                          style: TextStyle(color: greyColor, fontSize: 14),
                        ),
                        Text(
                          totalHours.toStringAsFixed(1),
                          style: TextStyle(
                            color: blue,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: greyColor.withValues(alpha: 0.3),
                height: 1,
              ),

              Expanded(
                child: FutureBuilder<List<Movie>>(
                  future: futureMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: blue),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur : ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Aucun film trouvé.'));
                    } else {
                      return Column(
                        spacing: 16.0,
                        children: [
                          CustomSearchBar(
                            onSearchResults: _updateMovies,
                            isSeen: true,
                          ),
                          Expanded(
                            child:
                                displayedMovies.isEmpty
                                    ? const Center(
                                      child: Text(
                                        'Aucun film trouvé.',
                                        style: TextStyle(color: whiteColor),
                                      ),
                                    )
                                    : GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 16.0,
                                            mainAxisSpacing: 16.0,
                                            childAspectRatio: 1.21,
                                          ),
                                      itemCount: displayedMovies.length,
                                      itemBuilder:
                                          (context, index) => FilmCard(
                                            movie: displayedMovies[index],
                                            stars: displayedMovies[index].stars,
                                          ),
                                    ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
