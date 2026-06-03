import 'package:flutter/material.dart';
import 'dart:math' show pi;
// import 'package:vector_math/vector_math_64.dart' hide Colors;

class ThreeDimensionalAnimation extends StatefulWidget {
  const ThreeDimensionalAnimation({super.key});

  @override
  State<ThreeDimensionalAnimation> createState() =>
      _ThreeDimensionalAnimationState();
}

class _ThreeDimensionalAnimationState extends State<ThreeDimensionalAnimation>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _rorationAnimation;
  final double widthHeight = 100.0;

  @override
  void initState() {
    super.initState();
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _rorationAnimation = Tween<double>(begin: 0.0, end: 2 * (pi));
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();

    _yController
      ..reset()
      ..repeat();

    _zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: widthHeight, width: double.infinity),
              AnimatedBuilder(
                animation: Listenable.merge([
                  _xController,
                  _yController,
                  _zController,
                ]),

                builder: (context, child) => Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(_rorationAnimation.evaluate(_xController))
                    ..rotateY(_rorationAnimation.evaluate(_yController))
                    ..rotateZ(_rorationAnimation.evaluate(_zController)),

                  child: Stack(
                    children: [
                      //back side
                      InkWell(
                        onTap: () => Navigator.popAndPushNamed(
                          context,
                          '/basic_animations',
                        ),
                        child: Container(
                          width: widthHeight,
                          height: widthHeight,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                        ),
                      ),

                      //left side
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.rotationY(pi / 2),
                        child: Container(
                          width: widthHeight,
                          height: widthHeight,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                        ),
                      ),

                      //right side
                      Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.rotationY(-(pi / 2)),
                        child: Container(
                          width: widthHeight,
                          height: widthHeight,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                        ),
                      ),

                      //front side
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.translationValues(
                          0.0,
                          0.0,
                          -widthHeight,
                        ),

                        ///front
                        child: Container(
                          width: widthHeight,
                          height: widthHeight,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.purple,
                          ),
                        ),
                      ),

                      //top side
                      Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.rotationX(-(pi / 2)),
                        child: Container(
                          width: widthHeight,
                          height: widthHeight,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.yellow,
                          ),
                        ),
                      ),

                      //bottom side
                      Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.rotationX(pi / 2),

                        child: Container(
                          width: widthHeight,
                          height: widthHeight,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange,
                          ),
                        ),
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
