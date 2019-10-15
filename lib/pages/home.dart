import 'package:flutter/material.dart';
import 'package:rethink_flutter_app/pages/other_page.dart';
import 'package:rethink_flutter_app/pages/sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String profilePicture =
      "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
  String backgroundImage = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: new Text("Some Title"),
              background: Image.network(
                "https://images.pexels.com/photos/346529/pexels-photo-346529.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Home Page",
                    style: new TextStyle(fontSize: 40.0),
                  ),
                  new Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                ],
              ),
            ),
          )
        ],
      ),
      drawer: new Drawer(
          child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("User Real Name"),
            accountEmail: new Text("db.random.username"),
            currentAccountPicture: new GestureDetector(
              onTap: () {
                print("the user is tapping the profile pic");
              },
              child: new CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
              ),
            ),
            decoration: new BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                        "https://images.pexels.com/photos/1227648/pexels-photo-1227648.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260"))),
          ),
          new ListTile(
              title: new Text("Sign In"),
              trailing: new Icon(Icons.arrow_drop_down_circle),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext) => new SignIn()));
                print("DEBUG: user is tapping sign in page");
              }),
          new ListTile(
            title: new Text("First Page"),
            trailing: new Icon(Icons.arrow_upward),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext) => new OtherPage("First Page Here")));
              print("DEBUG: user is tapping first page");
            },
          ),
          new ListTile(
            title: new Text("Second Page"),
            trailing: new Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext) =>
                      new OtherPage("Second Page Here")));
              print("DEBUG: user is tapping second page");
            },
          ),
          new Divider(),
          new ListTile(
            title: new Text("Close"),
            trailing: new Icon(Icons.cancel),
            onTap: () {
              Navigator.of(context).pop();
              print("DEBUG: user is tapping close");
            },
          )
        ],
      )),
    );
  }
}
