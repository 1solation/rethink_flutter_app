import 'package:flutter/material.dart';

class PollListView extends StatefulWidget {
  @override
  _PollListViewState createState() => _PollListViewState();
}

class _PollListViewState extends State<PollListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boardroom 1 Polls'),
      ),
      body: ListView(
        children: const <Widget>[
          Card(
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('Poll A'),
              subtitle: Text('Do we give patient A more medicine?'),
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('Poll B'),
              subtitle: Text('Do we give patient B stronger pain killers?'),
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(size: 72.0),
              title: Text('Poll C'),
              subtitle: Text('Do we operate on patient C?'),
              isThreeLine: true,
            ),
          ),
        ],
      ),
    );
  }
}
