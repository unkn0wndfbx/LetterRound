import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/pages/settings_page.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:provider/provider.dart';

import '../api/movie_service.dart';
import 'info_film.dart';
import 'nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Movie> topRatedMovie;
  late Future<List<Movie>> actionMovies;
  late Future<List<Movie>> comedyMovies;
  late Future<List<Movie>> dramaMovies;

  bool isValid(String? value) {
    return value != null &&
        value.isNotEmpty &&
        value != "N/A" &&
        value != "null";
  }

  @override
  void initState() {
    super.initState();
    topRatedMovie = MovieService().fetchTopRatedMovie();
    actionMovies = MovieService().fetchMovies('action');
    comedyMovies = MovieService().fetchMovies('comedy');
    dramaMovies = MovieService().fetchMovies('drama');
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

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
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              icon: Icon(CupertinoIcons.settings, size: 32),
            ),
          ),
        ],
      ),
      drawer: NavBar(),
      body: SafeArea(
        child:
            isLandscape
                ? Row(
                  children: [
                    topFilmContainer(isLandscape),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: ListView(
                          children: [
                            _buildCategoryList('Action', actionMovies),
                            _buildCategoryList('Comédie', comedyMovies),
                            _buildCategoryList('Drame', dramaMovies),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                : ListView(
                  children: [
                    topFilmContainer(isLandscape),

                    _buildCategoryList('Action', actionMovies),
                    _buildCategoryList('Comédie', comedyMovies),
                    _buildCategoryList('Drame', dramaMovies),
                  ],
                ),
      ),
    );
  }

  FutureBuilder<Movie> topFilmContainer(bool isLandscape) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<Movie>(
      future: topRatedMovie,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: blue));
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(
            child: Text(
              'Aucun film trouvé.',
              style: TextStyle(
                color: themeProvider.isDarkMode ? whiteColor : blackColor,
              ),
            ),
          );
        } else {
          final movie = snapshot.data!;
          return FutureBuilder<Movie>(
            future: MovieService().fetchMovie(movie.imdbID),
            builder: (context, movieDetailsSnapshot) {
              if (movieDetailsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: blue),
                );
              } else if (movieDetailsSnapshot.hasError) {
                return Center(
                  child: Text('Erreur : ${movieDetailsSnapshot.error}'),
                );
              } else if (!movieDetailsSnapshot.hasData) {
                return Center(
                  child: Text(
                    'Aucun détail trouvé.',
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? whiteColor : blackColor,
                    ),
                  ),
                );
              } else {
                final movieDetails = movieDetailsSnapshot.data!;
                bool isValidPoster =
                    movieDetails.poster.isNotEmpty &&
                    movieDetails.poster != "N/A" &&
                    movieDetails.poster != 'null' &&
                    movieDetails.poster != 'undefined' &&
                    movieDetails.poster != '';

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: isLandscape ? 32 : 0,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => InfoFilm(imdbId: movie.imdbID),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  themeProvider.isDarkMode
                                      ? blackColor
                                      : greyColor,
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            child:
                                isValidPoster
                                    ? Image.network(
                                      movieDetails.poster,
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          (isLandscape ? 0.8 : 0.45),
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return _buildPlaceholder();
                                      },
                                    )
                                    : _buildPlaceholder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        movieDetails.title,
                        style: TextStyle(
                          color:
                              themeProvider.isDarkMode
                                  ? whiteColor
                                  : blackColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 16,
                        children: [
                          if (isValid(movieDetails.year))
                            Text(
                              movieDetails.year,
                              style: TextStyle(color: greyColor, fontSize: 16),
                            ),

                          if (isValid(movieDetails.genre) && !isLandscape)
                            Text(
                              movieDetails.genre,
                              style: TextStyle(color: greyColor, fontSize: 16),
                            ),

                          if (isValid(movieDetails.runtime))
                            Text(
                              movieDetails.runtime,
                              style: const TextStyle(
                                fontSize: 16,
                                color: greyColor,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _buildCategoryList(String category, Future<List<Movie>> futureMovies) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<List<Movie>>(
      future: futureMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: blue));
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucun film trouvé.'));
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? whiteColor : blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      children:
                          snapshot.data!.map((movie) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                InfoFilm(imdbId: movie.imdbID),
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    movie.poster,
                                    width: 130,
                                    height: 185,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildPlaceholder() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: 120,
      width: double.infinity,
      color:
          themeProvider.isDarkMode
              ? blackColor
              : greyColor.withValues(alpha: 0.25),
      child: const Center(
        child: Icon(CupertinoIcons.film, size: 48, color: greyColor),
      ),
    );
  }
}
