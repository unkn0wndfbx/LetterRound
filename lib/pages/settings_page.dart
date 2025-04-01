import 'package:flutter/material.dart';
import 'package:letter_round/pages/credits_page.dart';
import 'package:letter_round/pages/language_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:letter_round/widgets/confirmation_dialog.dart';
import 'package:letter_round/widgets/settings_card.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'bottom_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: blackColor,
          elevation: 0,
          iconTheme: const IconThemeData(size: 32, color: whiteColor),
          title: Text(
            'Settings',
            style: TextStyle(
              color: whiteColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(CupertinoIcons.back, size: 32, color: whiteColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsCard(
                title: "Langues",
                icon: CupertinoIcons.globe,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguagePage()),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Column(
                    spacing: 1,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(color: greyColor, fontSize: 13),
                      ),
                      Text(
                        '© 2025 LetterRound',
                        style: TextStyle(color: greyColor, fontSize: 13),
                      ),
                      Text(
                        'Rights Reserved',
                        style: TextStyle(color: greyColor, fontSize: 13),
                      ),
                      Text(
                        'Made in France',
                        style: TextStyle(color: greyColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
