import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// final dummySnapshot = [
//   {"pollDesc": "do 1", "voteCount": 15},
//   {"pollDesc": "do 2", "voteCount": 14},
//   {"pollDesc": "do 3", "voteCount": 11},
//   {"pollDesc": "kill him", "voteCount": 10},
//   {"pollDesc": "chuck 'im out", "voteCount": 1},
// ];

// // class VotingPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('placehold me'),
// //       ),
// //       body: Center(
// //         child: RaisedButton(
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //           child: Text('go back'),
// //         ),
// //       ),
// //     );
// //   }
// // }

// class MyVotingPage extends StatefulWidget {
//   @override
//   _MyVotingPageState createState() => _MyVotingPageState();
// }

// class _MyVotingPageState extends State<MyVotingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('Voting Panel'),
//       ),
//       body: _buildBody(context),
//     );
//   }
// }

// Widget _buildBody(BuildContext context) {
//   //TODO: get actual data from firebase
//   return _buildList(context, dummySnapshot);
// }

// Widget _buildList(BuildContext context, List<Map> snapshot) {
//   return ListView(
//     padding: const EdgeInsets.only(top: 20.0),
//     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//   );
// }

// Widget _buildListItem(BuildContext context, Map data) {
//   final record = Record.fromMap(data);
//   return Padding(
//     key: ValueKey(record.pollDesc
// ),
//     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//     child: Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(5.0),
//       ),
//       child: ListTile(
//         title: Text(record.pollDesc
//     ),
//         trailing: Text(record.voteCount.toString()),
//         onTap: () => print(record),
//       ),
//     ),
//   );
// }

// class Record {
//   final String pollDesc;
//   final int voteCount;
//   final DocumentReference reference;

//   Record.fromMap(Map<String, dynamic> map, {this.reference})
//       : assert(map['pollDesc
//   '] != null),
//         assert(map['voteCount'] != null),
//         pollDesc
//      = map['pollDesc
//     '],
//         voteCount = map['voteCount'];

//   Record.fromSnapshot(DocumentSnapshot snapshot)
//       : this.fromMap(snapshot.data, reference: snapshot.reference);

//   @override
//   String toString() => "Record<$pollDesc:$voteCount>";
// }

//Demo of just the tabs, how they work.
class TabBarDemo extends StatelessWidget {
  const TabBarDemo({Key key, @required this.user, this.document, this.boardID})
      : super(key: key);

  final FirebaseUser user;
  final DocumentSnapshot document;
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.announcement)),
                Tab(icon: Icon(Icons.add_comment)),
              ],
            ),
            title: Text(document['pollName']),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.announcement),
              Comments(user: user,document: document, boardID: boardID),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentState extends State<Comments>{
  final _text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('boardroom')
                    .document(widget.boardID) //Change to stored boardID
                    .collection('polls')
                    .document(widget.document.documentID)//Change to stored pollID
                    .collection('comments')
                    .snapshots(),
                builder: (context,  AsyncSnapshot snapshot){
                  if (!snapshot.hasData) {
                    return Text("Loading...");
                  } else {
                    print("[DEBUG] Has Data, Length: " +
                        snapshot.data.documents.length.toString());
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) => _commentBuilder(context, snapshot.data.documents[index]),
                  );
                },
              ),
            ),
            Form(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _text,
                        decoration: InputDecoration(labelText: 'Comment'),

                      ),
                    ),
                    RaisedButton(
                      onPressed: commentOut,
                      child: Text('Comment'),
                    ),
                  ],
                )
            ),
          ]
        ),
      ),
    );
  }
  void commentOut() {
      print(_text.text);
      try{
        Firestore.instance
            .collection('boardroom')
            .document(widget.boardID) //Change to stored boardID
            .collection('polls')
            .document(widget.document.documentID)//Change to stored pollID
            .collection('comments').document().setData({
          'comment': _text.text,
          'userID': widget.user.uid,
          'time': new DateTime.now(),

        });
      }catch(error){
        print("[DEBUG ERROR]" +error );
      }


  }
}

Widget _commentBuilder(context, DocumentSnapshot snapshot){

return Card(
    color: Colors.pink,
    child: Column(children: <Widget>[
        ListTile(
          title: Text(snapshot["comment"],
              style: new TextStyle(color: Colors.white)),
          subtitle: Text("User ID: " + snapshot["userID"],
              style: new TextStyle(color: Colors.white70)),
        ),
      ]
    ),
);
}

class Comments extends StatefulWidget {
  const Comments({Key key, @required this.user, this.document, this.boardID})
      : super(key: key);

  final FirebaseUser user;
  final DocumentSnapshot document;
  final String boardID;
  @override
  _CommentState createState() => _CommentState();
}

