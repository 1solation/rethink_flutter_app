import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rethink_flutter_app/pages/boardroom.dart';

class Home extends StatefulWidget {
  const Home({Key key, @required this.user}) : super(key: key);
  // TODO: Global Styling Options
  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}

Widget _buildBoardroomList(context, DocumentSnapshot snapshot, FirebaseUser user) {
  //TODO: Dynamic Styling

  return Card(
      color: Colors.pink,
      child: Column(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.local_hospital, size: 50, color: Colors.white),
                title: Text(snapshot["boardName"], style: new TextStyle(color: Colors.white)),
                subtitle: Text(snapshot.documentID, style: new TextStyle(color: Colors.white70)),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Boardroom(user: user, document: snapshot),
                      )
                  );
                }
            ),
          ]
      )
  );
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home ${widget.user.email}'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: StreamBuilder(
            stream: Firestore.instance.collection('boardroom').where('members', arrayContains: widget.user.uid).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return const Text('Loading....');

              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => _buildBoardroomList(context, snapshot.data.documents[index], widget.user),
              );
            }
        )
      )
    );
  }
}
