import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rethink_flutter_app/pages/poll.dart';

Widget buildPollList(context, DocumentSnapshot snapshot, FirebaseUser user, DocumentSnapshot boardroom) {
  //TODO: Dynamic Styling
  return Card(
      color: Colors.pink,
      child: Column(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.local_hospital, size: 50, color: Colors.white),
                title: Text(snapshot['pollName'], style: new TextStyle(color: Colors.white)),
                subtitle: Text(snapshot['patient'], style: new TextStyle(color: Colors.white70)),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Poll(user: user, document: snapshot, boardroom: boardroom), // TODO: build navigation to new individual Poll
                        // currently breaks on tap, use the BACK BUTTON on the emulator to navigate from the error
                      )
                  ); // Navigator.push
                }
            ),
          ]
      )
  );
}

class Boardroom extends StatefulWidget {
  const Boardroom({Key key, @required this.user, this.document}) : super(key: key);

  final FirebaseUser user;
  final DocumentSnapshot document;

  @override
  _BoardroomState createState() => _BoardroomState();
}

class _BoardroomState extends State<Boardroom> {

  //TODO: Redo theme related code to be dynamic, not hard-coded.

  @override
  Widget build(BuildContext context){
    return _createPollList(context);
  }

  Scaffold _createPollList(BuildContext context){

    return Scaffold(appBar: AppBar(
      title: Text(widget.document['boardName']),
    ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: StreamBuilder(
            stream: Firestore.instance.collection('boardroom').document(widget.document.documentID).collection('polls').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData){
                return Text("Loading...");
              } else {
                print("[DEBUG] Has Data, Length: "+snapshot.data.documents.length.toString());
              }

              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => buildPollList(context, snapshot.data.documents[index], widget.user, widget.document),
              );
            },
          ),
        )
    );
  }
}
