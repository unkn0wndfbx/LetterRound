import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/movie_service.dart';
import '../models/movie.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoFilm extends StatefulWidget {
  const InfoFilm({super.key, required this.imdbId});

  final String imdbId;

  @override
  State<InfoFilm> createState() => _InfoFilmState();
}

class _InfoFilmState extends State<InfoFilm> {
  late Future<Movie> movie;
  bool hasSeen = false;
  int selectedStars = 0;

  bool isValid(String? value) {
    return value != null &&
        value.isNotEmpty &&
        value != "N/A" &&
        value != "null";
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hasSeen = prefs.getBool('${widget.imdbId}_seen') ?? false;
      selectedStars = prefs.getInt('${widget.imdbId}_rating') ?? 0;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.imdbId}_seen', hasSeen);
    await prefs.setInt('${widget.imdbId}_rating', selectedStars);
  }

  void toggleSeen() {
    setState(() {
      hasSeen = !hasSeen;
      if (!hasSeen) {
        selectedStars = 0;
      } else {
        final loc = AppLocalizations.of(context)!;

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: loc.vu,
            message: loc.vuText,
            contentType: ContentType.success,
            inMaterialBanner: true,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    });
    _savePreferences();
  }

  void updateRating(int rating) {
    setState(() {
      selectedStars = rating;
      hasSeen = rating > 0;
      if (rating > 0) {
        final loc = AppLocalizations.of(context)!;

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: loc.vu,
            message: loc.vuText,
            contentType: ContentType.success,
            inMaterialBanner: true,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    });
    _savePreferences();
  }

  @override
  void initState() {
    super.initState();
    movie = MovieService().fetchMovie(widget.imdbId);
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
        title: FutureBuilder<Movie>(
          future: movie,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                'Loading...',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? whiteColor : blackColor,
                ),
              );
            } else if (snapshot.hasError) {
              return const Text(
                'Error loading movie',
                style: TextStyle(color: red),
              );
            } else if (snapshot.hasData) {
              final movie = snapshot.data!;
              return Text(
                movie.title,
                style: TextStyle(
                  color: themeProvider.isDarkMode ? whiteColor : blackColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return const SizedBox();
          },
        ),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(CupertinoIcons.back, size: 32),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        ),
      ),
      body: FutureBuilder<Movie>(
        future: movie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: blue));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: red),
              ),
            );
          } else if (snapshot.hasData) {
            final movie = snapshot.data!;
            bool isValidPoster =
                movie.poster.isNotEmpty &&
                movie.poster != "N/A" &&
                movie.poster != 'null' &&
                movie.poster != 'undefined' &&
                movie.poster != '';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              themeProvider.isDarkMode
                                  ? blackColor
                                  : greyColor.withValues(alpha: 0.6),
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      child: Hero(
                        tag: "moviePoster_${widget.imdbId}",
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          child:
                              isValidPoster
                                  ? Image.network(
                                    movie.poster,
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.4,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholder();
                                    },
                                  )
                                  : _buildPlaceholder(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: toggleSeen,
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color:
                                hasSeen
                                    ? blue
                                    : themeProvider.isDarkMode
                                    ? blackColor
                                    : greyColor.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                loc.vu,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                hasSeen
                                    ? CupertinoIcons.check_mark_circled_solid
                                    : CupertinoIcons.check_mark_circled,
                                size: 22,
                                color:
                                    hasSeen
                                        ? whiteColor
                                        : themeProvider.isDarkMode
                                        ? greyColor
                                        : whiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color:
                              themeProvider.isDarkMode
                                  ? blackColor
                                  : greyColor.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          spacing: 4,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            return GestureDetector(
                              onTap: () => updateRating(index + 1),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (
                                  Widget child,
                                  Animation<double> animation,
                                ) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  CupertinoIcons.star_fill,
                                  key: ValueKey(index < selectedStars),
                                  size: 22,
                                  color:
                                      index < selectedStars
                                          ? yellow
                                          : themeProvider.isDarkMode
                                          ? greyColor
                                          : whiteColor,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "${movie.title} (${movie.year})",
                    style: TextStyle(
                      fontSize: 24,
                      color: themeProvider.isDarkMode ? whiteColor : blackColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          themeProvider.isDarkMode
                              ? blackColor.withValues(alpha: 0.7)
                              : blackColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Wrap(
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (isValid(movie.genre))
                          Text(
                            movie.genre,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  themeProvider.isDarkMode
                                      ? greyColor
                                      : greyColor.withValues(alpha: 0.8),
                            ),
                          ),
                        if (isValid(movie.runtime))
                          Text(
                            "•",
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  themeProvider.isDarkMode
                                      ? greyColor
                                      : greyColor.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        if (isValid(movie.runtime))
                          Text(
                            movie.runtime,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  themeProvider.isDarkMode
                                      ? greyColor
                                      : greyColor.withValues(alpha: 0.8),
                            ),
                          ),
                        if (isValid(movie.rated))
                          Text(
                            "•",
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  themeProvider.isDarkMode
                                      ? greyColor
                                      : greyColor.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        if (isValid(movie.rated))
                          Text(
                            movie.rated,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  themeProvider.isDarkMode
                                      ? greyColor
                                      : greyColor.withValues(alpha: 0.8),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isValid(movie.director))
                    Text(
                      "${loc.realisePar} : ${movie.director}",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            themeProvider.isDarkMode ? whiteColor : blackColor,
                      ),
                    ),
                  if (isValid(movie.writer))
                    Text(
                      "${loc.ecritPar} : ${movie.writer}",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            themeProvider.isDarkMode ? whiteColor : blackColor,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (isValid(movie.actors))
                    Text(
                      "${loc.avec} : ${movie.actors}",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            themeProvider.isDarkMode ? whiteColor : blackColor,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    loc.synopsis,
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          themeProvider.isDarkMode
                              ? greyColor
                              : greyColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isValid(movie.plot))
                    Text(
                      movie.plot,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            themeProvider.isDarkMode ? whiteColor : blackColor,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    loc.notes,
                    style: TextStyle(
                      fontSize: 18,
                      color:
                          themeProvider.isDarkMode
                              ? greyColor
                              : greyColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        movie.ratings.map((rating) {
                          return Column(
                            spacing: 2,
                            children: [
                              Row(
                                spacing: 4,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${rating['Source']}:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          themeProvider.isDarkMode
                                              ? whiteColor
                                              : blackColor,
                                    ),
                                  ),

                                  Text(
                                    "${rating['Value']}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: yellow,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),
                  if (isValid(movie.language))
                    Text(
                      "${loc.langue} : ${movie.language}",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            themeProvider.isDarkMode
                                ? greyColor
                                : greyColor.withValues(alpha: 0.8),
                      ),
                    ),
                  if (isValid(movie.country))
                    Text(
                      "${loc.pays} : ${movie.country}",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            themeProvider.isDarkMode
                                ? greyColor
                                : greyColor.withValues(alpha: 0.8),
                      ),
                    ),
                  if (isValid(movie.released))
                    Text(
                      "${loc.sortie} : ${movie.released}",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            themeProvider.isDarkMode
                                ? greyColor
                                : greyColor.withValues(alpha: 0.8),
                      ),
                    ),
                  if (isValid(movie.boxOffice))
                    Text(
                      "${loc.boxOffice} : ${movie.boxOffice}",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            themeProvider.isDarkMode
                                ? greyColor
                                : greyColor.withValues(alpha: 0.8),
                      ),
                    ),
                  if (isValid(movie.awards))
                    Text(
                      "${loc.recompenses} : ${movie.awards}",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            themeProvider.isDarkMode
                                ? greyColor
                                : greyColor.withValues(alpha: 0.8),
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
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
