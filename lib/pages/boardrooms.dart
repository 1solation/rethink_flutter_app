import 'package:flutter/material.dart';
import 'package:rethink_flutter_app/main.dart';

class Boardroom {
  final String chairmanID; // Used to parse the database for the chairman's name (to display).
  final String name; // Boardroom name. Duh.
  final List<String> userIDs; // The user IDs are going to be used in order to check if the user is in the boardroom.
  final List<String> modIDs; // Used to parse the databse for the moderators names (to display).
  Boardroom(this.chairmanID, this.name, this.userIDs, this.modIDs);
}

class BoardroomsList extends StatelessWidget {

  static List<Boardroom> _getBoardrooms(){ // Creates the list of boardrooms for the user.
    //TODO: Rewrite function for database authentication logic.

    List<Boardroom> boardroomList = List.generate(5, (i) => Boardroom(
        'chairman id placeholder',
        'boardroom name placeholder',
        ["id1", "id2"],
        ["id3", "id4"]
    )
    );
    return boardroomList;
  }

  final List<Boardroom> boardrooms = _getBoardrooms();

  @override
  Widget build(BuildContext context){
    return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: boardrooms.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          color: Color.fromRGBO(255, 155, 155, 1),
          child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.local_hospital, size: 50, color: Colors.white),
                    title: Text(boardrooms[index].name, style: new TextStyle(color: Colors.white)),
                    subtitle: Text('subtitle placeholder', style: new TextStyle(color: Colors.white70)),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoardroomPage(boardroom: boardrooms[index]),
                          )
                      ); // Navigator.push
                    }
                ),
              ]
          )
        );
      }
    );
  }
}

class Boardrooms extends StatelessWidget {

  final String pageText = "Boardrooms";
  final TextStyle style = new TextStyle(fontSize: 35.0);

  @override
  Widget build(BuildContext context) {
    // Build Elements Here

    return new Scaffold(
      appBar: new AppBar(title: new Text(pageText),backgroundColor: Color.fromRGBO(255, 155, 155, 1),),
          body: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                new Expanded(child: BoardroomsList()),
              ]
            ),
          )
    );
  }
}

class BoardroomPage extends StatelessWidget {
  final Boardroom boardroom;
  BoardroomPage({Key key, @required this.boardroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build Elements Here
    return new Scaffold(
      appBar: new AppBar(title: Text(boardroom.name), backgroundColor: Color.fromRGBO(255, 155, 155, 1),
    )
    );
  }
}