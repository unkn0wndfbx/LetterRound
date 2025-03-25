import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:letter_round/config/api_config.dart';
import 'package:letter_round/models/movie.dart';

class MovieService {
  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/movie/popular?api_key=${ApiConfig.apiKey}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> moviesJson = data['results'];
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des films');
    }
  }
}
