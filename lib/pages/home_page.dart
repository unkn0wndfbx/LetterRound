import 'package:flutter/material.dart';
import 'package:letter_round/api/movie_service.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/ressources/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = MovieService().fetchMovies('Inception');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FutureBuilder<List<Movie>>(
          future: futureMovies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Aucun film trouvé.');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return ListTile(
                    leading:
                        movie.poster.isNotEmpty
                            ? Image.network(movie.poster)
                            : null,
                    title: Text(movie.title),
                    subtitle: Text(movie.year),
                    onTap: () {},
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
