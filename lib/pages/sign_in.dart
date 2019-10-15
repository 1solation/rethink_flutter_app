import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  final String pageText = "hello jamie boiiii, ok";

  // SignIn(this.pageText);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(pageText)),
        body: new Center(
            child: new Text(
          pageText,
          style: new TextStyle(fontSize: 35.0),
        )));
  }
}
