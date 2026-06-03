import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImplicitAnimations2 extends StatefulWidget {
  const ImplicitAnimations2({super.key});

  @override
  State<ImplicitAnimations2> createState() => _ImplicitAnimations2State();
}

// Colors are 32-bit integers in ARGB format. each of the 4 channels (alpha, red, green, blue) is 8 bits wide (0–255) 4 channels × 8 bits = 32 bits total.  Example: 0xffff9000 → alpha=0xff, red=0xff, green=0x90, blue=0x00 (0x indicates hexadecimal)

Color getRandomColor() => Color(0xff000000 + math.Random().nextInt(0x00ffffff));

Color _color = getRandomColor();

class _ImplicitAnimations2State extends State<ImplicitAnimations2> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipPath(
              clipper: CircleClipper(),
              child: TweenAnimationBuilder(
                tween: ColorTween(begin: getRandomColor(), end: _color),
                duration: Duration(seconds: 1),
                onEnd: () {
                  setState(() {
                    _color = getRandomColor();
                  });
                },
                builder: (context, Color? color, child) => ColorFiltered(
                  colorFilter: ColorFilter.mode(color!, BlendMode.srcATop),
                  child: Container(
                    width: size,
                    height: size, // ← explicit, not ambiguous
                    decoration: BoxDecoration(color: Color(0xFFEE592C)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// we basically cut a circle from a container/rectangle becasuse we are saying rect.fromCircle. We wrappped it with an oval because of the parameters of the rectangle(width and height may not be equal)
class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width/2, size.height/2 ),
        radius:
            size.width /
            2, //could has well be size.height/2 because it is a circle. height and width are the samee
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
