import 'package:flutter/material.dart';

class Boardrooms extends StatelessWidget {
  final String pageText = "hello jamie boiii";
  final TextStyle style = new TextStyle(fontSize: 35.0);

  @override
  Widget build(BuildContext context) {
    // Build Elements Here


    return new Scaffold(
        appBar: new AppBar(title: new Text(pageText)),
        body: Center(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Add Elements Here


                        ]
                    )
                )
            )
        )
    );
  }
}
