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
                style: TextStyle(color: whiteColor),
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: whiteColor),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
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
                  const SizedBox(height: 16),
                  Text(
                    "${movie.title} (${movie.year})",
                    style: const TextStyle(
                      fontSize: 24,
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${movie.genre} • ${movie.runtime} • ${movie.rated}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Réalisé par : ${movie.director}",
                    style: const TextStyle(fontSize: 16, color: whiteColor),
                  ),
                  Text(
                    "Écrit par : ${movie.writer}",
                    style: const TextStyle(fontSize: 16, color: whiteColor),
                  ),
                  const SizedBox(height: 8),
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
                    children:
                        movie.ratings.map((rating) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              "${rating['Source']}: ${rating['Value']}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: whiteColor,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Langue : ${movie.language}",
                    style: const TextStyle(fontSize: 16, color: whiteColor),
                  ),
                  Text(
                    "Pays : ${movie.country}",
                    style: const TextStyle(fontSize: 16, color: whiteColor),
                  ),
                  Text(
                    "Sortie : ${movie.released}",
                    style: const TextStyle(fontSize: 16, color: whiteColor),
                  ),
                  Text(
                    "Box Office : ${movie.boxOffice}",
                    style: const TextStyle(fontSize: 16, color: whiteColor),
                  ),
                  Text(
                    "Récompenses : ${movie.awards}",
                    style: const TextStyle(fontSize: 16, color: whiteColor),
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
