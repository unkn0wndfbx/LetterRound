import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:letter_round/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: FlutterSplashScreen.fadeIn(
        backgroundColor: Colors.white,
        useImmersiveMode: true,
        childWidget: SizedBox(
          height: 200,
          width: 200,
          child: Image.asset("assets/logo.png"),
        ),
        nextScreen: const HomePage(),
      ),
    );
  }
}
