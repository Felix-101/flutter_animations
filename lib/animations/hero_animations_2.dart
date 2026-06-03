import 'package:flutter/material.dart';
import 'details_screen.dart';

class HeroAnimation extends StatefulWidget {
  const HeroAnimation({super.key});

  @override
  State<HeroAnimation> createState() => HeroAnimationState();
}

class HeroAnimationState extends State<HeroAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("People")),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];

          return ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(person: person),
                ),
              );
            },
            leading: Hero(
              tag: person.name,
              child: Text(person.emoji, style: TextStyle(fontSize: 40)),
            ),
            subtitle: Text('${person.age.toString()} years old'),
            title: Text(person.name.toString()),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          );
        },
      ),
    );
  }
}

const people = [
  Person(name: 'John', age: 20, emoji: '👨🏾‍🦰'),
  Person(name: 'Jane', age: 21, emoji: '👩🏽‍🦳'),
  Person(name: 'Jack', age: 22, emoji: '🧔🏽'),
];

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;
  const Person({required this.name, required this.age, required this.emoji});
}
