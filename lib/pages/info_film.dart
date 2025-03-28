import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';
import '../api/movie_service.dart';
import '../models/movie.dart';

class InfoFilm extends StatefulWidget {
  const InfoFilm({super.key, required this.imdbId});

  final String imdbId;

  @override
  State<InfoFilm> createState() => _InfoFilmState();
}

class _InfoFilmState extends State<InfoFilm> {
  late Future<Movie> movie;

  bool isValid(String? value) {
    return value != null &&
        value.isNotEmpty &&
        value != "N/A" &&
        value != "null";
  }

  @override
  void initState() {
    super.initState();
    movie = MovieService().fetchMovie(widget.imdbId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: blackColor,
        elevation: 0,
        iconTheme: const IconThemeData(size: 32, color: whiteColor),
        title: FutureBuilder<Movie>(
          future: movie,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                'Loading...',
                style: TextStyle(color: whiteColor),
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
                style: const TextStyle(
                  color: whiteColor,
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
                icon: const Icon(
                  CupertinoIcons.back,
                  size: 32,
                  color: whiteColor,
                ),
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
            return const Center(child: CircularProgressIndicator(color: red));
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
                                  movie.poster,
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildPlaceholder();
                                  },
                                )
                                : _buildPlaceholder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 36,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          spacing: 4,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Je l'ai vu !",
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              size: 20,
                              color: blue,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 36,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: blackColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          spacing: 4,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            5,
                            (index) => Icon(
                              CupertinoIcons.star_fill,
                              size: 18,
                              color: yellow,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "${movie.title} (${movie.year})",
                    style: const TextStyle(
                      fontSize: 24,
                      color: whiteColor,
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
                      color: blackColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isValid(movie.genre))
                          Text(
                            movie.genre,
                            style: const TextStyle(
                              fontSize: 16,
                              color: greyColor,
                            ),
                          ),
                        if (isValid(movie.runtime))
                          Text(
                            "•",
                            style: const TextStyle(
                              fontSize: 18,
                              color: greyColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        if (isValid(movie.runtime))
                          Text(
                            movie.runtime,
                            style: const TextStyle(
                              fontSize: 16,
                              color: greyColor,
                            ),
                          ),
                        if (isValid(movie.rated))
                          Text(
                            "•",
                            style: const TextStyle(
                              fontSize: 18,
                              color: greyColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        if (isValid(movie.rated))
                          Text(
                            movie.rated,
                            style: const TextStyle(
                              fontSize: 16,
                              color: greyColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isValid(movie.director))
                    Text(
                      "Réalisé par : ${movie.director}",
                      style: const TextStyle(fontSize: 16, color: whiteColor),
                    ),
                  if (isValid(movie.writer))
                    Text(
                      "Écrit par : ${movie.writer}",
                      style: const TextStyle(fontSize: 16, color: whiteColor),
                    ),
                  const SizedBox(height: 8),
                  if (isValid(movie.actors))
                    Text(
                      "Avec : ${movie.actors}",
                      style: const TextStyle(fontSize: 16, color: whiteColor),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    "Synopsis",
                    style: TextStyle(
                      fontSize: 18,
                      color: greyColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (isValid(movie.plot))
                    Text(
                      movie.plot,
                      style: const TextStyle(fontSize: 16, color: whiteColor),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    "Notes",
                    style: TextStyle(
                      fontSize: 18,
                      color: greyColor,
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
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: whiteColor,
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
                      "Langue : ${movie.language}",
                      style: const TextStyle(fontSize: 16, color: greyColor),
                    ),
                  if (isValid(movie.country))
                    Text(
                      "Pays : ${movie.country}",
                      style: const TextStyle(fontSize: 16, color: greyColor),
                    ),
                  if (isValid(movie.released))
                    Text(
                      "Sortie : ${movie.released}",
                      style: const TextStyle(fontSize: 16, color: greyColor),
                    ),
                  if (isValid(movie.boxOffice))
                    Text(
                      "Box Office : ${movie.boxOffice}",
                      style: const TextStyle(fontSize: 16, color: greyColor),
                    ),
                  if (isValid(movie.awards))
                    Text(
                      "Récompenses : ${movie.awards}",
                      style: const TextStyle(fontSize: 16, color: greyColor),
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
