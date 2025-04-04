import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:letter_round/widgets/credits_card.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  Future<List<dynamic>> _loadCredits() async {
    final String response = await rootBundle.loadString('assets/credits.json');
    final data = json.decode(response);

    if (data['sections'] == null) {
      throw Exception('La clé "sections" est manquante dans le fichier JSON');
    }

    return data['sections'];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            themeProvider.isDarkMode ? backgroundColor : whiteColor,
        appBar: AppBar(
          backgroundColor:
              themeProvider.isDarkMode
                  ? blackColor
                  : greyColor.withValues(alpha: 0.3),
          elevation: 0,
          iconTheme: IconThemeData(
            size: 32,
            color: themeProvider.isDarkMode ? whiteColor : blackColor,
          ),
          title: Text(
            loc.credits,
            style: TextStyle(
              color: themeProvider.isDarkMode ? whiteColor : blackColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(CupertinoIcons.back, size: 32),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
          ),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _loadCredits(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: blue));
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erreur de chargement'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucun crédit disponible.'));
            }

            var sections = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    sections.map<Widget>((section) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section['title'],
                            style: TextStyle(
                              color: yellow,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...section['items'].map<Widget>((item) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: CreditsCard(
                                title: item['title'] ?? 'No title',
                                name: item['name'] ?? 'No name',
                                subtitle: item['subtitle'] ?? 'No subtitle',
                                link: item['link'],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
