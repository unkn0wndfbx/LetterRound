import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter_round/ressources/colors.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  bool isEnglish = false;

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
            'Langues',
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
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: blackColor,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  children: [
                    Text(
                      "Langues",
                      style: TextStyle(color: whiteColor, fontSize: 17),
                    ),
                    Spacer(),
                    Text(
                      "FR",
                      style: TextStyle(
                        color: isEnglish ? greyColor : whiteColor,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(width: 4),
                    CupertinoSwitch(
                      activeTrackColor: yellow,
                      value: isEnglish,
                      onChanged: (bool value) {
                        setState(() {
                          isEnglish = value;
                        });
                      },
                    ),
                    SizedBox(width: 4),
                    Text(
                      "EN",
                      style: TextStyle(
                        color: isEnglish ? whiteColor : greyColor,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
