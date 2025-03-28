import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:letter_round/config/api_config.dart';
import 'package:letter_round/models/movie.dart';

class MovieService {
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
}
