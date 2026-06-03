import 'package:flutter/material.dart';
import 'dart:math' show pi, sin;

class CrazyCurve extends StatefulWidget {
  const CrazyCurve({super.key});

  @override
  State<CrazyCurve> createState() => _CrazyCurveState();
}

class _CrazyCurveState extends State<CrazyCurve> with TickerProviderStateMixin {
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
      duration: Duration(seconds: 2),
    );

    _sidesAnimation = IntTween(
      begin: 1,
      end: 7,
    ).chain(CurveTween(curve: Curves.bounceOut)).animate(_sidesController);

    _sizeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _sizeAnimation = Tween<double>(
      begin: 20.00,
      end: 200.00,
    ).chain(CurveTween(curve: Curves.bounceInOut)).animate(_sizeController);

    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_rotationController);

    _sidesController.repeat(reverse: true);
    _sizeController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    _sidesController.dispose();
    _sizeController.dispose();
    _rotationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _sidesAnimation,
              _sizeAnimation,
              _rotationAnimation,
            ]),
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity(),
                // ..rotateY(_rotationAnimation.value),
                child: CustomPaint(
                  painter: LissajousPainter(
                    a: _sidesAnimation.value.toDouble(),
                    b: (_sidesAnimation.value + 1).toDouble(),
                    delta: pi / 2,
                    amplitudeX: _sizeAnimation.value,
                    amplitudeY: _sizeAnimation.value,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LissajousPainter extends CustomPainter {
  final double a;
  final double b;
  final double delta;
  final double amplitudeX;
  final double amplitudeY;

  LissajousPainter({
    required this.a,
    required this.b,
    required this.delta,
    required this.amplitudeX,
    required this.amplitudeY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Center the origin (0,0) in the middle of the canvas
    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);

    // 2. Configure the line style
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    bool isFirstPoint = true;

    // 3. Generate points from t = 0 to 2π
    const int totalPoints = 500;
    for (int i = 0; i <= totalPoints; i++) {
      double t = (i / totalPoints) * 2 * pi;

      // Lissajous parametric equations
      double x = amplitudeX * sin(a * t + delta);
      double y = amplitudeY * sin(b * t);

      if (isFirstPoint) {
        path.moveTo(x, y);
        isFirstPoint = false;
      } else {
        path.lineTo(x, y);
      }
    }

    // 4. Draw the calculated path
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LissajousPainter oldDelegate) {
    return oldDelegate.a != a ||
        oldDelegate.b != b ||
        oldDelegate.delta != delta ||
        oldDelegate.amplitudeX != amplitudeX ||
        oldDelegate.amplitudeY != amplitudeY;
  }
}
