import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rethink_flutter_app/pages/test_poll_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key key, @required this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}

Widget _buildListItem(BuildContext, context, DocumentSnapshot document) {
  return ListTile(
    title: Row(
      children: [
        Expanded(
            child: Text(
          document.documentID,
          style: Theme.of(context).textTheme.headline,
        )),
        Container(
          decoration: const BoxDecoration(
            color: Color(0xffddddff),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Text(
            document['userType'].toString(),
            style: Theme.of(context).textTheme.display1,
          ),
        ),
      ],
    ),
    onTap: () {
      print("Should increase votes here.");
    },
  );
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home ${widget.user.email}'),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document('${widget.user.uid}'.toString())
              .collection('activeBoards')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading....');
            print(snapshot.data);
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => _buildListItem(
                  BuildContext, context, snapshot.data.documents[index]),
            );
          }),
    );
  }

  void navigateToTestPolls() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PollListView()));
  }
}
