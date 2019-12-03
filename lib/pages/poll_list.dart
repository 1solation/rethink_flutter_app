import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rethink_flutter_app/pages/home.dart';
import 'package:rethink_flutter_app/pages/voting.dart';

Widget buildPollList(context, DocumentSnapshot snapshot, FirebaseUser user) {
  //TODO: Dynamic Styling
  return Card(
      color: Colors.pink,
      child: Column(children: <Widget>[
        ListTile(
            leading: Icon(Icons.local_hospital, size: 50, color: Colors.white),
            title: Text(snapshot['pollName'],
                style: new TextStyle(color: Colors.white)),
            subtitle: Text(snapshot['patient'],
                style: new TextStyle(color: Colors.white70)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        new VotingTabView(), // TODO: build navigation to new individual Poll
                    // currently breaks on tap, use the BACK BUTTON on the emulator to navigate from the error
                  )); // Navigator.push
            }),
      ]));
}
