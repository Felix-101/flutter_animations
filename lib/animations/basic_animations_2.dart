import 'package:flutter/material.dart';
import 'dart:math' show pi;

class BasicAnimations2 extends StatefulWidget {
  const BasicAnimations2({super.key});

  @override
  State<BasicAnimations2> createState() => _BasicAnimations2State();
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class _BasicAnimations2State extends State<BasicAnimations2>
    with TickerProviderStateMixin {
  late AnimationController _counterClockWiseRotationController;
  late Animation<double> _counterClockWiseAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _counterClockWiseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _counterClockWiseAnimation = Tween<double>(begin: 0.0, end: -(pi / 2))
        .animate(
          CurvedAnimation(
            parent: _counterClockWiseRotationController,
            curve: Curves.bounceOut,
          ),
        );

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: pi).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
    );

    // _flipController.repeat.delayed(const Duration(seconds: 1));

    //status Listener
    _counterClockWiseRotationController.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _flipAnimation =
            Tween<double>(
              begin: _flipAnimation.value,
              end: _flipAnimation.value + pi,
            ).animate(
              CurvedAnimation(parent: _flipController, curve: Curves.bounceOut),
            );
        //reset and start flip controller
        _flipController
          ..reset()
          ..forward();
      }
    });
    //status Listener
    _flipController.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        _counterClockWiseAnimation =
            Tween<double>(
              begin: _counterClockWiseRotationController.value,
              end: _counterClockWiseRotationController.value + -(pi / 2),
            ).animate(
              CurvedAnimation(
                parent: _counterClockWiseRotationController,
                curve: Curves.bounceOut,
              ),
            );
        //reset and start clockwise controller
        _counterClockWiseRotationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockWiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //anytime the build function is called reset the animation. This is why we out it here instead of void init
    _counterClockWiseRotationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _counterClockWiseAnimation,
          builder: (context, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationZ(_counterClockWiseAnimation.value),

            // ..rotateY(_counterClockWiseAnimation.value),
            child: Row(
              mainAxisAlignment: .center,

              children: [
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, '/three_d_animations'),
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) => Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.rotationX(_flipAnimation.value),
                      child: ClipPath(
                        clipper: HalfCircleClipper(side: CircleSide.left),
                        child: Container(
                          width: 200,
                          height: 200,
                          color: Color(0xff0057b7),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) => Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.rotationX(_flipAnimation.value),
                    child: ClipPath(
                      clipper: HalfCircleClipper(side: CircleSide.right),
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.amber.shade300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    var path = Path();

    late Offset offset;
    late bool clockWise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockWise = false;
        break;

      case CircleSide.right:
        offset = Offset(0, size.height);
        clockWise = true;
        break;
    }
    path.arcToPoint(
      offset,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockWise,
    );

    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;
  const HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) {
    return side.toPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

/*  */
