import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/api/movie_service.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/pages/nav_bar.dart';
import 'package:letter_round/pages/settings_page.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:letter_round/widgets/film_card.dart';
import 'package:letter_round/widgets/search_bar.dart';
import 'package:provider/provider.dart';

class FilmsPage extends StatefulWidget {
  const FilmsPage({super.key});

  @override
  _FilmsPageState createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  late Future<List<Movie>> futureMovies;
  List<Movie> displayedMovies = [];

  @override
  void initState() {
    super.initState();
    futureMovies = MovieService().fetchRandomMovies();
    futureMovies
        .then((movies) {
          setState(() {
            displayedMovies = movies;
          });
        })
        .catchError((error) {
          print('Erreur: $error');
        });
  }

  void _updateMovies(List<Movie> movies) {
    setState(() {
      displayedMovies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeProvider.isDarkMode ? backgroundColor : whiteColor,
      appBar: AppBar(
        backgroundColor:
            themeProvider.isDarkMode ? backgroundColor : whiteColor,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  CustomSearchBar(onSearchResults: _updateMovies),
                  Expanded(
                    child:
                        displayedMovies.isEmpty
                            ? Center(
                              child: Text(
                                'Aucun film trouvé.',
                                style: TextStyle(
                                  color:
                                      themeProvider.isDarkMode
                                          ? whiteColor
                                          : blackColor,
                                ),
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
                                  (context, index) =>
                                      FilmCard(movie: displayedMovies[index]),
                            ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
