import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/api/movie_service.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/ressources/colors.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(List<Movie>) onSearchResults;

  const CustomSearchBar({Key? key, required this.onSearchResults})
    : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _searchMovies(String query) async {
    if (query.isNotEmpty) {
      final movies = await MovieService().fetchMovies(query);
      widget.onSearchResults(movies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _searchMovies,
      style: const TextStyle(color: whiteColor),
      decoration: InputDecoration(
        hintText: "Rechercher un film...",
        hintStyle: TextStyle(color: greyColor),
        prefixIcon: Icon(CupertinoIcons.search, color: greyColor),
        filled: true,
        fillColor: greyColor.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
