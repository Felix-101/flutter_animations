import 'package:flutter/material.dart';
import 'hero_animations_2.dart';

class DetailsScreen extends StatelessWidget {
  final Person person;
  const DetailsScreen({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(person.emoji, textAlign: TextAlign.center)),
      body: Center(
        child: Column(
          children: [
            Hero(
              flightShuttleBuilder:
                  (
                    flightContext,
                    animation,
                    flightDirection,
                    fromHeroContext,
                    toHeroContext,
                  ) {
                    switch (flightDirection) {
                      case HeroFlightDirection.push:
                        return Material(
                          color: Colors.transparent,
                          child: ScaleTransition(
                            scale: animation.drive(
                              Tween<double>(
                                begin: 0,
                                end: 5,
                              ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
                            ),
                            child: toHeroContext.widget,
                          ),
                        );

                      case HeroFlightDirection.pop:
                        return Material(
                          color: Colors.transparent,
                          child: fromHeroContext.widget,
                        );
                    }
                  },
              tag: person.name,
              child: Text(person.name, style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 20),
            Text(person.age.toString(), style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
