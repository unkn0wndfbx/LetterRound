import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:letter_round/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsCard extends StatelessWidget {
  final String title;
  final String name;
  final String subtitle;
  final String link;

  const CreditsCard({
    super.key,
    required this.title,
    required this.name,
    required this.subtitle,
    this.link = '',
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title :',
            style: TextStyle(
              color: themeProvider.isDarkMode ? whiteColor : blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (name.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                name,
                style: TextStyle(
                  color:
                      themeProvider.isDarkMode
                          ? whiteColor.withValues(alpha: 0.6)
                          : blackColor.withValues(alpha: 0.4),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (link.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: GestureDetector(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(link))) {
                    await launchUrl(Uri.parse(link));
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: blue,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: blue,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                subtitle,
                style: TextStyle(
                  color:
                      themeProvider.isDarkMode
                          ? whiteColor.withValues(alpha: 0.6)
                          : blackColor.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
