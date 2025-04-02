import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:provider/provider.dart';

import '../pages/info_film.dart';

class FilmCard extends StatelessWidget {
  const FilmCard({super.key, required this.movie, this.isDate, this.stars});

  final Movie movie;
  final bool? isDate;
  final int? stars;

  @override
  Widget build(BuildContext context) {
    bool isValidPoster =
        movie.poster.isNotEmpty &&
        movie.poster != "N/A" &&
        movie.poster != 'null' &&
        movie.poster != 'undefined' &&
        movie.poster != '';

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InfoFilm(imdbId: movie.imdbID),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: blackColor,
        highlightColor: Colors.white10,
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: "moviePoster_${movie.imdbID}",
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child:
                      isValidPoster
                          ? Image.network(
                            fit: BoxFit.cover,
                            movie.poster,
                            width: double.infinity,
                            height: 120,
                            errorBuilder: (context, error, stackTrace) {
                              print("Image failed to load: ${movie.poster}");
                              return _buildPlaceholder(context);
                            },
                          )
                          : _buildPlaceholder(context),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                        if (movie.stars > 0)
                          Row(
                            children: [
                              Text(
                                movie.stars.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.star, color: yellow, size: 16),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (isDate == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        movie.year,
                        style: const TextStyle(fontSize: 14, color: greyColor),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: 120,
      width: double.infinity,
      color: themeProvider.isDarkMode ? blackColor : greyColor.withValues(alpha: 0.25),
      child: Center(
        child: const Icon(CupertinoIcons.film, size: 48, color: greyColor),
      ),
    );
  }
}
