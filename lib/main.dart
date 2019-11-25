import 'package:flutter/material.dart';
import 'package:rethink_flutter_app/pages/setup/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReThinkApp',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: WelcomePage(),
    );
  }
}
