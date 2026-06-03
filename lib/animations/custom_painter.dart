import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

class CustomPainter1 extends StatefulWidget {
  const CustomPainter1({super.key});

  @override
  State<CustomPainter1> createState() => _CustomPainter1State();
}

class _CustomPainter1State extends State<CustomPainter1>
    with TickerProviderStateMixin {
  late AnimationController _sidesController;
  late Animation<int> _sidesAnimation;

  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _sidesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _sidesAnimation = IntTween(
      begin: 3,
      end: 10,
    ).chain(CurveTween(curve: Curves.bounceOut)).animate(_sidesController);

    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _sizeAnimation = Tween<double>(
      begin: 20.00,
      end: 400.0,
    ).chain(CurveTween(curve: Curves.bounceInOut)).animate(_sizeController);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_rotationController);
  }

  @override
  void dispose() {
    _sidesController.dispose();
    _sizeController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sidesController.repeat(reverse: true);
    _sizeController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _sidesAnimation,
            _sizeAnimation,
            _rotationAnimation,
          ]),
          builder: (context, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateY(_rotationAnimation.value)
              ..rotateX(_rotationAnimation.value)
              ..rotateZ(_rotationAnimation.value),
            child: CustomPaint(
              painter: Polygon(sides: _sidesAnimation.value),
              child: SizedBox(
                width: _sizeAnimation.value,
                // height: _sizeAnimation.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Polygon extends CustomPainter {
  final int sides;
  const Polygon({required this.sides});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xff12efff)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;
    // like our brush

    final path = Path();

    final center = Offset(
      size.width / 2,
      size.height / 2,
    ); // assuming width and height are the same

    final angle = (2 * pi) / sides;

    //A full circle is 2π(360 degrees). Divide it equally by the number of sides to get the angle between each corner.

    final angles = List.generate(sides, (index) => index * angle);
    // get an angle for each corner

    final radius = size.width / 2;

    path.moveTo(center.dx + radius * cos(0), center.dy + radius * sin(0));
    //Start at the first corner of the shape (at angle 0).

    for (final angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }
    //Draw lines to each corner, using cos/sin to find where each corner (angle)sits on the circle.

    path.close();
    // draw a line from its current position to close the shape

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is Polygon && oldDelegate.sides != sides;
  }
}
