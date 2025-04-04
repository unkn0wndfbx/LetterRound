import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:letter_round/pages/bottom_bar.dart';
import 'package:letter_round/ressources/colors.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Bienvenue !',
            body:
                'Nous sommes ravis de vous accueillir. Cette application est conçue pour vous offrir une expérience fluide et agréable. Parcourez ces étapes pour découvrir toutes les fonctionnalités qui vous attendent.',
            image: buildImage('assets/images/splash.png'),
            decoration: getPageDecoration(yellow),
          ),
          PageViewModel(
            title: 'Adaptez l’application à vos besoins',
            body:
                'Personnalisez votre profil en quelques clics ! Ajoutez votre nom, les films que vous avez vus, et ajustez vos préférences pour une expérience encore plus personnalisée.',
            image: buildImage('assets/images/logo_s.png'),
            decoration: getPageDecoration(red),
          ),
          PageViewModel(
            title: 'Explorez les fonctionnalités',
            body:
                'Découvrez les différentes fonctionnalités qui vous aideront à noter les films. Que ce soit pour voir les informations d\'un film, noter le film, tout est intuitif.',
            image: buildImage('assets/images/splash.png'),
            decoration: getPageDecoration(yellow),
          ),
          PageViewModel(
            title: "Prêt à commencer ?",
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Vous êtes maintenant prêt à commencer l'aventure !",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: greyColor,
                  ),
                ),
                TextButton(
                  onPressed: () => goToHome(context),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 20,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [red, yellow],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Allons-y !",
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
        done: const Text(
          'Done',
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
          'Skip',
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
    bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
    imagePadding: const EdgeInsets.all(64),
    pageColor: backgroundColor,
  );
}
