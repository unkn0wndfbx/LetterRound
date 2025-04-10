import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/api/movie_service.dart';
import 'package:letter_round/config/database.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/pages/edit_username_page.dart';
import 'package:letter_round/pages/settings_page.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:letter_round/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/film_card.dart';
import '../widgets/search_bar.dart';
import 'nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  Movie? topRatedMovie;

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
      seenMovies.sort((a, b) => b.stars.compareTo(a.stars));
      topRatedMovie = seenMovies.first;
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
    _loadUsername();

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

  String? username;

  Future<void> _loadUsername() async {
    final name = await DatabaseHelper.instance.getUsername();
    setState(() {
      username = name ?? 'Anonyme';
    });
  }

  Future<void> _editUsername() async {
    final newUsername = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUsernamePage(currentUsername: username ?? ''),
      ),
    );

    if (newUsername != null && newUsername is String) {
      await DatabaseHelper.instance.saveUsername(newUsername);
      _loadUsername();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.isDarkMode ? backgroundColor : whiteColor,
      appBar: CustomAppBar(themeProvider: themeProvider),
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
                child: Text(
                  loc.maCinematheque,
                  style: TextStyle(
                    color: themeProvider.isDarkMode ? whiteColor : blackColor,
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
                  color:
                      themeProvider.isDarkMode
                          ? greyColor.withValues(alpha: 0.25)
                          : greyColor.withValues(alpha: 0.15),
                ),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (topRatedMovie != null)
                          Center(
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(
                                topRatedMovie!.poster,
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            username ?? 'Anonyme',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  themeProvider.isDarkMode
                                      ? whiteColor
                                      : blackColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _editUsername,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  themeProvider.isDarkMode
                                      ? backgroundColor
                                      : greyColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
                              CupertinoIcons.pencil,
                              color: greyColor,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              loc.noteMoyenne,
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
                              loc.filmsVus,
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
                              loc.totalHeures,
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
                      return Center(
                        child: Text(
                          'Erreur : ${snapshot.error}',
                          style: TextStyle(color: red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          loc.aucunFilm,
                          style: TextStyle(
                            color:
                                themeProvider.isDarkMode
                                    ? whiteColor
                                    : blackColor,
                          ),
                        ),
                      );
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
                                    ? Center(
                                      child: Text(
                                        loc.aucunFilm,
                                        style: TextStyle(color: red),
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