import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rethink_flutter_app/pages/test_poll_list.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key key, @required this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home ${widget.user.email}'),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: FlutterLogo(size: 72.0),
                title: Text('Boardroom 1'),
                subtitle: Text('3 ACTIVE POLLS'),
                isThreeLine: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PollListView(),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: FlutterLogo(size: 72.0),
                title: Text('Boardroom 2'),
                subtitle: Text('1 ACTIVE POLL'),
                isThreeLine: true,
              ),
            ),
            Card(
              child: ListTile(
                leading: FlutterLogo(size: 72.0),
                title: Text('Boardroom 3'),
                subtitle: Text('1 ACTIVE POLL'),
                isThreeLine: true,
              ),
            ),
          ],
        ));
  }

  void navigateToTestPolls() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PollListView()));
  }
}
