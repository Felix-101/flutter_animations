import 'package:flutter/material.dart';

class ImplicitAnimations extends StatefulWidget {
  const ImplicitAnimations({super.key});

  @override
  State<ImplicitAnimations> createState() => _ImplicitAnimationsState();
}

class _ImplicitAnimationsState extends State<ImplicitAnimations> {
  double deafultWidth = 400;
  /* final ValueListenable<bool> _isExpanded = ValueNotifier(false); */
  bool isExpanded = false;
  var _cruve = Curves.bounceInOut;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                width: deafultWidth,
                curve: _cruve,
                height: 100,
                child: Image.asset("assets/images/domain.png"),
              ),
            ],
          ),
       /*    Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.red, Colors.blue], transform: ),
            ),
          ),
 */
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
                deafultWidth = isExpanded
                    ? MediaQuery.of(context).size.width
                    : 100;
                _cruve = isExpanded ? Curves.bounceInOut : Curves.bounceOut;
              });
            },
            child: Text(
              isExpanded ? "Zoom out" : "Zoom in",
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
