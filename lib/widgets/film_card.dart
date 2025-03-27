import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/models/movie.dart';
import 'package:letter_round/ressources/colors.dart';

class FilmCard extends StatelessWidget {
  const FilmCard({super.key, required this.movie, this.isDate});

  final Movie movie;
  final bool? isDate;

  @override
  Widget build(BuildContext context) {
    bool isValidPoster =
        movie.poster.isNotEmpty &&
        movie.poster != "N/A" &&
        movie.poster != 'null' &&
        movie.poster != 'undefined' &&
        movie.poster != '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          /*  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FilmDetailPage(movie: movie)),
          ); */
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
              ClipRRect(
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
                            return _buildPlaceholder();
                          },
                        )
                        : _buildPlaceholder(),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
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

  Widget _buildPlaceholder() {
    return Container(
      height: 120,
      width: double.infinity,
      color: blackColor,
      child: Center(
        child: const Icon(CupertinoIcons.film, size: 48, color: greyColor),
      ),
    );
  }
}
