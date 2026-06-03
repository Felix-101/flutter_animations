import 'package:flutter/material.dart';
import 'dart:math' show pi;

class AnimatedDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;
  const AnimatedDrawer({super.key, required this.child, required this.drawer});

  @override
  State<AnimatedDrawer> createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer>
    with TickerProviderStateMixin {
  late AnimationController _xControllerForchild;
  late Animation<double> _yRotationAnimationForChild;

  late AnimationController _xControllerForDrawer;
  late Animation<double> _yRotationAnimationForDrawer;

  @override
  void initState() {
    super.initState();

    _xControllerForchild = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _yRotationAnimationForChild = Tween<double>(
      begin: 0,
      end: -(pi / 2),
    ).animate(_xControllerForchild);

    _xControllerForDrawer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _yRotationAnimationForDrawer = Tween<double>(
      begin: -(pi / 2.7),
      end: 0,
    ).animate(_xControllerForDrawer);
  }

  @override
  void dispose() {
    _xControllerForchild.dispose();
    _xControllerForDrawer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxDrag = screenWidth * 0.7;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _xControllerForchild.value += details.delta.dx / maxDrag;
        _xControllerForDrawer.value += details.delta.dx / maxDrag;
      },
      onHorizontalDragEnd: (details) {
        if (_xControllerForchild.value < 0.5) {
          _xControllerForchild.reverse();
          _xControllerForDrawer.reverse();
        } else {
          _xControllerForchild.forward();
          _xControllerForDrawer.forward();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _yRotationAnimationForChild,
          _yRotationAnimationForDrawer,
        ]),
        builder: (context, child) => Stack(
          children: [
            Container(color: Color(0xFF192B3A)),
            Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translateByDouble(
                  _xControllerForchild.value * maxDrag,
                  0.0,
                  0.0,
                  1.0,
                )
                ..rotateY(_yRotationAnimationForChild.value),
              child: widget.child,
            ),
            Transform(
              alignment: Alignment.centerRight,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..translateByDouble(
                  -screenWidth + _xControllerForDrawer.value * maxDrag, // tx
                  0.0, // ty
                  0.0, // tz
                  1.0, // tw (This is the required 4th argument)
                )
                ..rotateY(_yRotationAnimationForDrawer.value),
              child: widget.drawer,
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedDrawer(
      drawer: Material(
        child: Container(
          color: Color(0xff24283b),
          child: ListView.builder(
            padding: EdgeInsets.only(left: 200, top: 80),
            itemCount: 5,
            itemBuilder: (context, index) => ListTile(
              title: Text('item $index', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),

      child: Scaffold(
        appBar: AppBar(title: Text("3D Drawer")),
        body: Container(color: Color(0xFF173550)),
      ),
    );
  }
}
