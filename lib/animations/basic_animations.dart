import 'package:flutter/material.dart';
import 'dart:math' show pi;

class BasicAnimations extends StatefulWidget {
  const BasicAnimations({super.key});

  @override
  State<BasicAnimations> createState() => _BasicAnimationsState();
}

class _BasicAnimationsState extends State<BasicAnimations>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Transform(
            alignment: Alignment.center,
            // you can use origin with offsetx,y)and these values must be half the value of width and height
            // transform: Matrix4.identity()..scaleByDouble(1.5, 1.5, 1.0, 1.0),
            transform: Matrix4.identity()
              ..rotateX(_animation.value)
              ..rotateY(_animation.value)
              ..rotateZ(_animation.value),

            child: InkWell(
              onTap: () => Navigator.popAndPushNamed(context, '/three_d_animations'),
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                width: 200,
                height: 200,
              
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: const Offset(2, 4),
              
                      // blurStyle: BlurStyle.inner,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// so un flutter the graph is inversed, it is still your normal  x and y axis but the y axis is inverted, so the top left corner is 0,0 and the bottom right corner is the max width and height of the screen.
