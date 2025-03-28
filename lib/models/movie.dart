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
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json['imdbID'],
      title: json['Title'],
      year: json['Year'],
      rated: json['Rated'],
      released: json['Released'],
      runtime: json['Runtime'],
      genre: json['Genre'],
      director: json['Director'],
      writer: json['Writer'],
      actors: json['Actors'],
      plot: json['Plot'],
      language: json['Language'],
      country: json['Country'],
      awards: json['Awards'],
      poster: json['Poster'],
      ratings: List<Map<String, String>>.from(
        (json['Ratings'] as List).map(
          (rating) => {
            'Source': rating['Source'].toString(),
            'Value': rating['Value'].toString(),
          },
        ),
      ),
      metascore: json['Metascore'],
      imdbRating: json['imdbRating'],
      imdbVotes: json['imdbVotes'],
      type: json['Type'],
      boxOffice: json['BoxOffice'],
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
