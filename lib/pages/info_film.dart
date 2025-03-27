import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';

class InfoFilm extends StatelessWidget {
  final String title;
  final String year;
  final String synopsis;

  const InfoFilm({
    Key? key,
    required this.title,
    required this.year,
    required this.synopsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                color: red,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                'Affiche du film',
                style: TextStyle(color: blackColor, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 24, color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 30,
                      width: 100,
                      color: blackColor,
                      alignment: Alignment.center,
                      child: Text(
                        '⭐️⭐️⭐️⭐️⭐',
                        style: TextStyle(color: whiteColor, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                Text(
                  year,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 20),
                Text(
                  'Synopsis',
                  style: TextStyle(fontSize: 16, color: greyColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  synopsis,
                  style: TextStyle(fontSize: 16, color: whiteColor),
                ),
                SizedBox(height: 16),
                Container(
                  height: 30,
                  width: double.infinity,
                  color: blackColor,
                  alignment: Alignment.center,
                  child: Text(
                    'Switch watching',
                    style: TextStyle(color: whiteColor, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}