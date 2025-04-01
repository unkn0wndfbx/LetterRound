import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/pages/settings_page.dart';
import 'package:letter_round/ressources/colors.dart';

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
      body: SafeArea(
        child: ListView(
          children: [
            FutureBuilder<Movie>(
              future: topRatedMovie,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: blue),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Aucun film trouvé.'));
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
                        return const Center(
                          child: Text('Aucun détail trouvé.'),
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
                          padding: const EdgeInsets.only(top: 32, bottom: 32),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: blackColor,
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
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.45,
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
                              const SizedBox(height: 16),
                              Text(
                                movieDetails.title,
                                style: TextStyle(
                                  color: whiteColor,
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
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 16,
                                      ),
                                    ),

                                  if (isValid(movieDetails.genre))
                                    Text(
                                      movieDetails.genre,
                                      style: TextStyle(
                                        color: greyColor,
                                        fontSize: 16,
                                      ),
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
            ),

            _buildCategoryList('Action', actionMovies),
            _buildCategoryList('Comédie', comedyMovies),
            _buildCategoryList('Drame', dramaMovies),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(String category, Future<List<Movie>> futureMovies) {
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
                      color: whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        snapshot.data!.map((movie) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 120,
      width: double.infinity,
      color: blackColor,
      child: const Center(
        child: Icon(CupertinoIcons.film, size: 48, color: greyColor),
      ),
    );
  }
}
