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

void navigateToTestPolls(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => PollListView()));
}

Widget _buildListItem(context, DocumentSnapshot snapshot, FirebaseUser user) {
  return Card(
      color: Color.fromRGBO(255, 155, 155, 1),
      child: Column(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.local_hospital, size: 50, color: Colors.white),
                title: Text(snapshot.documentID, style: new TextStyle(color: Colors.white)),
                subtitle: Text('subtitle placeholder', style: new TextStyle(color: Colors.white70)),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Boardroom(user: user),
                      )
                  ); // Navigator.push
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
            stream: Firestore.instance.collection('users').document('${widget.user.uid}'.toString()).collection('activeBoards').snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData)
                return const Text('Loading....');

              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index], widget.user),
              );
            }
        )
      )
    );
  }
}

class Boardroom extends StatefulWidget {
  const Boardroom({Key key, @required this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _BoardroomState createState() => _BoardroomState();
}

class _BoardroomState extends State<Boardroom> {
  @override
  Widget build(BuildContext context){
    return _createStuff(context);
  }

  Scaffold _createStuff(BuildContext context){
    return Scaffold(appBar: AppBar(
      title: Text(widget.user.email),
    ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Card(
          color: Color.fromRGBO(255, 155, 155, 1),
          child: Column(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.local_hospital, size: 50, color: Colors.white),
                    title: Text("soon", style: new TextStyle(color: Colors.white)),
                    subtitle: Text('yeah', style: new TextStyle(color: Colors.white70)),
                    onTap: (){
                      Navigator.pop(context);
                    }
                ),
              ]
          )
      ),
      ),
    );
  }
}
