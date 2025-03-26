import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:letter_round/pages/bottom_bar.dart';
import 'package:letter_round/ressources/colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'ArchivoBlack'),
      home: FlutterSplashScreen.fadeIn(
        backgroundColor: backgroundColor,
        useImmersiveMode: true,
        childWidget: SizedBox(
          height: 200,
          width: 200,
          child: Image.asset("assets/images/splash.png"),
        ),
        nextScreen: const BottomBar(initialIndex: 0),
      ),
    );
  }
}
