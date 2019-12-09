import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({Key key, @required this.user, this.document, this.boardID})
      : super(key: key);

  final FirebaseUser user;
  final DocumentSnapshot document;
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.assignment)),
                Tab(icon: Icon(Icons.question_answer)),
              ],
            ),
            title: Text(document['pollName']),
          ),
          body: TabBarView(
            children: [
              Poll(user: user, document: document, boardID: boardID),
              Comments(user: user, document: document, boardID: boardID),
            ],
          ),
        ),
      ),
    );
  }
}

class Poll extends StatefulWidget {
  const Poll({Key key, @required this.user, this.document, this.boardID})
      : super(key: key);

  final FirebaseUser user;
  final DocumentSnapshot document;
  final String boardID;
  @override
  _PollState createState() => _PollState();
}

class _PollState extends State<Poll> {
  bool _hasVoted = false;
  @override
  Widget build(BuildContext context) {
    if (widget.document['votedUser'].contains(widget.user.uid)) {
      _hasVoted = true;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_hasVoted ? 'Results Panel' : 'Voting Panel'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('boardroom')
                      .document(widget.boardID)
                      .collection('polls')
                      .document(widget.document.documentID)
                      .collection('pollOptions')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return LinearProgressIndicator();
                    } else {
                      print("[DEBUG] Has Data, Length: " +
                          snapshot.data.documents.length.toString());
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) => _hasVoted
                          ? _resultBuilder(
                              context, snapshot.data.documents[index])
                          : _votingBuilder(
                              context,
                              snapshot.data.documents[index],
                              widget.boardID,
                              widget.document.documentID,
                              widget.user.uid,
                            ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _votingBuilder(context, DocumentSnapshot snapshot, String boardID,
      String documentID, String userUID) {
    //local doc ID for the poll option, enables debug statement access to pollOption.DocumentID

    var pollOptionID = snapshot.documentID;
    var newUserUID = [userUID];

    return Card(
      color: Colors.pink[300],
      child: Column(children: <Widget>[
        ListTile(
          title: Text(snapshot["pollDesc"],
              style: new TextStyle(color: Colors.white)),
          onTap: () {
            Firestore.instance.collection(pollOptionID);
            snapshot.reference
                .updateData({'voteCount': snapshot['voteCount'] + 1});
            print('[DEBUG]: User is tapping a poll option with DocID: $pollOptionID and voteCount of: ' +
                (snapshot['voteCount'] + 1)
                    .toString()); // +1 added to voteCount data before turning to a string, as snapshot['voteCount'] returns data before the update, '+1' to offset this
            Firestore.instance
                .collection('boardroom')
                .document(boardID)
                .collection('polls')
                .document(documentID)
                .updateData({'votedUser': FieldValue.arrayUnion(newUserUID)});
            handleTap();
          },
        ),
      ]),
    );
  }

  Widget _resultBuilder(context, DocumentSnapshot snapshot) {
    return Card(
      color: Colors.pink[300],
      child: Column(children: <Widget>[
        ListTile(
          title: Text(snapshot["pollDesc"],
              style: new TextStyle(color: Colors.white)),
          trailing: Text(
            snapshot['voteCount'].toString(),
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 35),
          ),
        ),
      ]),
    );
  }

  void handleTap() {
    setState(() {
      _hasVoted = !_hasVoted;
    });
  }
}

class _CommentState extends State<Comments> {
  final _text = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Comments'),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('boardroom')
                  .document(widget.boardID) //Change to stored boardID
                  .collection('polls')
                  .document(
                      widget.document.documentID) //Change to stored pollID
                  .collection('comments')
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return LinearProgressIndicator();
                } else {
                  print("[DEBUG] Has Data, Length: " +
                      snapshot.data.documents.length.toString());
                }
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                      _commentBuilder(context, snapshot.data.documents[index]),
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
          )),
        ]),
      ),
    );
  }

  void commentOut() {
    print(_text.text);
    try {
      Firestore.instance
          .collection('boardroom')
          .document(widget.boardID) //Change to stored boardID
          .collection('polls')
          .document(widget.document.documentID) //Change to stored pollID
          .collection('comments')
          .document()
          .setData({
        'comment': _text.text,
        'userID': widget.user.uid,
        'time': new DateTime.now(),
      });
    } catch (error) {
      print("[DEBUG ERROR]" + error);
    }
  }
}

Widget _commentBuilder(context, DocumentSnapshot snapshot) {
  return Card(
    color: Colors.pink[300],
    child: Column(children: <Widget>[
      ListTile(
        title: Text(snapshot["comment"],
            style: new TextStyle(color: Colors.white)),
        subtitle: Text("User ID: " + snapshot["userID"],
            style: new TextStyle(color: Colors.white70)),
      ),
    ]),
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
