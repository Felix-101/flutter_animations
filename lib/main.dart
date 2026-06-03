import 'package:flutter/material.dart';
import 'package:animations/animations/basic_animations.dart';
import 'package:animations/animations/basic_animations_2.dart';
import 'package:animations/animations/three_d_animation.dart';
import 'package:animations/animations/hero_animations_2.dart';
import 'package:animations/animations/implicit_animations.dart';
import 'package:animations/animations/implicit_animations_2.dart';
import 'package:animations/animations/custom_painter.dart';
import 'package:animations/animations/animated_drawer.dart';
import 'package:animations/animations/lissajous_curve.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,

      home: CrazyCurve(),
      routes: {
        '/basic_animations': (context) => const BasicAnimations(),
        '/basic_animations_2': (context) => const BasicAnimations2(),
        '/three_d_animations': (context) => const ThreeDimensionalAnimation(),
        '/hero_animation': (context) => const HeroAnimation(),
        'implicit_animation': (context) => const ImplicitAnimations(),
        'implicit_animation_2': (context) => const ImplicitAnimations2(),
        '/custom_painter': (context) => const CustomPainter1(),
        '/home_page': (context) => const HomePage(),
        '/lissajous_page': (context) => const CrazyCurve(),
      },
    );
  }
}
/* Matrix4.rotationY(value)
Matrix4.translationValues(x, y, z)
Matrix4.diagonal3Values(x, y, z) (for scaling) */