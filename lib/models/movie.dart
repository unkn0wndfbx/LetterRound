class Movie {
  final String imdbID;
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final List<Map<String, String>> ratings;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String type;
  final String boxOffice;

  int _stars = 0;

  int get stars => _stars;

  set stars(int rating) {
    _stars = rating;
  }

  Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.ratings,
    required this.metascore,
    required this.imdbRating,
    required this.imdbVotes,
    required this.type,
    required this.boxOffice,
    int stars = 0,
  }) {
    _stars = stars;
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'] ?? '',
      title: json['Title'] ?? 'Titre inconnu',
      year: json['Year'] ?? 'N/A',
      rated: json['Rated'] ?? 'N/A',
      released: json['Released'] ?? 'N/A',
      runtime: json['Runtime'] ?? 'N/A',
      genre: json['Genre'] ?? 'N/A',
      director: json['Director'] ?? 'N/A',
      writer: json['Writer'] ?? 'N/A',
      actors: json['Actors'] ?? 'N/A',
      plot: json['Plot'] ?? 'Résumé indisponible',
      language: json['Language'] ?? 'N/A',
      country: json['Country'] ?? 'N/A',
      awards: json['Awards'] ?? 'N/A',
      poster: json['Poster'] ?? '',
      ratings:
          (json['Ratings'] as List?)
              ?.map(
                (rating) => {
                  'Source': rating['Source'].toString(),
                  'Value': rating['Value'].toString(),
                },
              )
              .toList() ??
          [],
      metascore: json['Metascore'] ?? 'N/A',
      imdbRating: json['imdbRating'] ?? 'N/A',
      imdbVotes: json['imdbVotes'] ?? 'N/A',
      type: json['Type'] ?? 'N/A',
      boxOffice: json['BoxOffice'] ?? 'N/A',
    );
  }

  @override
  String toString() {
    return '''
    Movie {
      title: $title,
      year: $year,
      poster: $poster,
      genre: $genre,
      runtime: $runtime,
      rated: $rated,
      director: $director,
      writer: $writer,
      actors: $actors,
      plot: $plot,
      language: $language,
      country: $country,
      released: $released,
      boxOffice: $boxOffice,
      awards: $awards,
      ratings: $ratings
    }
    ''';
  }
}
