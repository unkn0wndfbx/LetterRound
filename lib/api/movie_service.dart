import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:letter_round/config/api_config.dart';
import 'package:letter_round/models/movie.dart';

class MovieService {
  final List<String> movieGenres = [
    'action',
    'comedy',
    'drama',
    'thriller',
    'romance',
    'horror',
    'animation',
    'sci-fi',
  ];

  Future<List<Movie>> fetchRandomMovies() async {
    List<Movie> allMovies = [];
    int totalPages = 2;

    final randomGenre = movieGenres[Random().nextInt(movieGenres.length)];

    for (int page = 1; page <= totalPages; page++) {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}?s=$randomGenre&page=$page&apikey=${ApiConfig.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          List<dynamic> moviesJson = data['Search'];
          allMovies.addAll(moviesJson.map((json) => Movie.fromJson(json)));
        } else {
          throw Exception(data['Error']);
        }
      } else {
        throw Exception('Erreur lors du chargement des films');
      }
    }

    return allMovies;
  }

  Future<List<Movie>> fetchMovies(String query) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}?s=$query&apikey=${ApiConfig.apiKey}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == 'True') {
        List<dynamic> moviesJson = data['Search'];
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(data['Error']);
      }
    } else {
      throw Exception('Erreur lors du chargement des films');
    }
  }

  Future<Movie> fetchMovie(String imdbId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}?i=$imdbId&apikey=${ApiConfig.apiKey}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == 'True') {
        return Movie.fromJson(data);
      } else {
        throw Exception(data['Error']);
      }
    } else {
      throw Exception('Erreur lors du chargement du film');
    }
  }

  Future<Movie> fetchTopRatedMovie() async {
    List<Movie> allMovies = [];
    int totalPages = 3;

    for (int page = 1; page <= totalPages; page++) {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}?s=movie&page=$page&apikey=${ApiConfig.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          List<dynamic> moviesJson = data['Search'];
          allMovies.addAll(moviesJson.map((json) => Movie.fromJson(json)));
        } else {
          throw Exception(data['Error']);
        }
      } else {
        throw Exception('Erreur lors du chargement des films');
      }
    }

    allMovies.sort((a, b) {
      double ratingA = double.tryParse(a.imdbRating ?? '0') ?? 0.0;
      double ratingB = double.tryParse(b.imdbRating ?? '0') ?? 0.0;
      return ratingB.compareTo(ratingA);
    });

    return allMovies.isNotEmpty
        ? allMovies.first
        : throw Exception('Aucun film trouvé');
  }
}
