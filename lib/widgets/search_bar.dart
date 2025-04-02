import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/api/movie_service.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({Key? key, required this.onSearchResults, this.isSeen})
    : super(key: key);

  final Function(List<Movie>) onSearchResults;
  final bool? isSeen;

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _searchMovies(String query) async {
    if (query.isNotEmpty) {
      if (widget.isSeen != null && widget.isSeen!) {
        final movies = await _getSeenMovies();
        final filteredMovies =
            movies.where((movie) {
              return movie.title.toLowerCase().contains(query.toLowerCase());
            }).toList();
        widget.onSearchResults(filteredMovies);
      } else {
        final movies = await MovieService().fetchMovies(query);
        widget.onSearchResults(movies);
      }
    }
  }

  Future<List<Movie>> _getSeenMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.endsWith('_seen')).toList();

    List<Movie> seenMovies = [];

    for (String key in keys) {
      bool hasSeen = prefs.getBool(key) ?? false;
      if (hasSeen) {
        String imdbId = key.replaceAll('_seen', '');
        Movie movie = await MovieService().fetchMovie(imdbId);

        int userRating = prefs.getInt('${imdbId}_rating') ?? 0;
        movie.stars = userRating;

        seenMovies.add(movie);
      }
    }

    return seenMovies;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return TextField(
      controller: _controller,
      onChanged: _searchMovies,
      style: TextStyle(
        color: themeProvider.isDarkMode ? whiteColor : blackColor,
      ),
      decoration: InputDecoration(
        hintText: "Rechercher un film...",
        hintStyle: TextStyle(
          color:
              themeProvider.isDarkMode
                  ? greyColor
                  : greyColor.withValues(alpha: 0.35),
        ),
        prefixIcon: Icon(
          CupertinoIcons.search,
          color:
              themeProvider.isDarkMode
                  ? greyColor
                  : greyColor.withValues(alpha: 0.35),
        ),
        filled: true,
        fillColor:
            themeProvider.isDarkMode
                ? greyColor.withValues(alpha: 0.25)
                : greyColor.withValues(alpha: 0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
