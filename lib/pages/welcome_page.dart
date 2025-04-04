import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:letter_round/pages/bottom_bar.dart';
import 'package:letter_round/ressources/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: loc.onBoarding1Title,
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  loc.onBoarding1Texte,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: greyColor,
                  ),
                ),
              ],
            ),
            image: buildImage('assets/images/splash.png'),
            decoration: getPageDecoration(yellow),
          ),
          PageViewModel(
            title: loc.onBoarding2Title,
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  loc.onBoarding2Texte,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: greyColor,
                  ),
                ),
              ],
            ),
            image: buildImage('assets/images/rating.png'),
            decoration: getPageDecoration(red),
          ),
          PageViewModel(
            title: loc.onBoarding3Title,
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  loc.onBoarding3Texte,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: greyColor,
                  ),
                ),
              ],
            ),
            image: buildImage('assets/images/watch.png'),
            decoration: getPageDecoration(blue),
          ),
          PageViewModel(
            title: loc.onBoarding4Title,
            bodyWidget: Column(
              spacing: 32,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  loc.onBoarding4Texte,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: greyColor,
                  ),
                ),
                TextButton(
                  onPressed: () => goToHome(context),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 64),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [red, yellow],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        loc.allonsY,
                        style: TextStyle(
                          fontSize: 22,
                          color: backgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            image: buildImage('assets/images/logo_s.png'),
            decoration: getPageDecoration(whiteColor),
          ),
        ],
        done: Text(
          loc.terminer,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: whiteColor,
          ),
        ),
        onDone: () => goToHome(context),
        next: const Icon(
          Icons.arrow_forward_rounded,
          size: 30,
          color: whiteColor,
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        showBackButton: false,
        showSkipButton: true,
        skip: Text(
          loc.suivant,
          style: TextStyle(
            fontSize: 20,
            color: greyColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        dotsDecorator: getDotsDecoration(),
        globalBackgroundColor: backgroundColor,
        isProgressTap: true,
        animationDuration: 2000,
      ),
    );
  }

  void goToHome(context) => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const BottomBar(initialIndex: 0)),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotsDecoration() => DotsDecorator(
    activeColor: whiteColor,
    size: const Size(10, 10),
    activeSize: const Size(30, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration(Color colorFont) => PageDecoration(
    titleTextStyle: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: colorFont,
    ),
    bodyTextStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: greyColor,
    ),
    titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    bodyPadding: const EdgeInsets.symmetric(horizontal: 24),
    imagePadding: const EdgeInsets.all(64),
    pageColor: backgroundColor,
  );
}
