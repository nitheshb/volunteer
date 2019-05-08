import 'package:flutter/material.dart';
import 'package:test_app_1/models/matches_M.dart';
import 'package:test_app_1/pages/fantasy_players_list_P.dart';
import 'package:test_app_1/services/authentication.dart';
class MatchListP extends StatefulWidget {
  MatchListP({Key key, this.auth ,this.title,  }) : super(key: key);

  final BaseAuth auth;
  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<MatchListP> {
  List lessons;

  @override
  void initState() {
    lessons = getLessons();
    super.initState();
  }

   // Perform login or signup
  void _logout()  {
    print("logout pressed");
    widget.auth.signOut();

     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
      bottomNavigationBar: makeBottom
     
    );
  }
}


final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text("list check title2(H)"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
             void _logout()  {    
     
  }
          },
                  )
                ],
              );
          
          final makeBottom = Container(
                height: 55.0,
                child: BottomAppBar(
                  color: Color.fromRGBO(58, 66, 86, 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.home, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.blur_on, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.hotel, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.account_box, color: Colors.white),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              );    
          
          final makeBody = Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: getLessons().length,
                  itemBuilder: (BuildContext context, int index) {
                    return makeCard(getLessons()[index], context);
                  },
                ),
              );    
          
          Card makeCard(Lesson lesson, BuildContext context) => Card(
                elevation: 8.0,
                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                  child: makeListTile(lesson,  context),
                ), 
              );
          
          ListTile makeListTile(Lesson lesson, BuildContext context) => ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12.0),
                    decoration: new BoxDecoration(
                        border: new Border(
                            right: new BorderSide(width: 1.0, color: Colors.white24))),
                    child: Icon(Icons.autorenew, color: Colors.white),
                  ),
                  title: Text(
                    lesson.title,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
          
                  subtitle: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Container(
                              // tag: 'hero',
                              child: LinearProgressIndicator(
                                  backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                                  value: lesson.indicatorValue,
                                  valueColor: AlwaysStoppedAnimation(Colors.green)),
                            )),
                        Expanded(
                          flex: 4,
                          child: Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(lesson.level,
                                  style: TextStyle(color: Colors.white))),
                        )
                      ],
                    ),
                  trailing:
                      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                  onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(title: "fantasy players list")));
                    },
                  
                      );
          
          // dummy model
          
          List getLessons() {
            return [
              Lesson(
                  title: "IND vs PAK",
                  level: "Beginner",
                  indicatorValue: 0.33,
                  price: 20,
                  content:
                      "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
              Lesson(
                  title: "NZ vs SRI",
                  level: "Beginner",
                  indicatorValue: 0.33,
                  price: 50,
                  content:
                      "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
              Lesson(
                  title: "Reverse parallel Parking",
                  level: "Intermidiate",
                  indicatorValue: 0.66,
                  price: 30,
                  content:
                      "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
              Lesson(
                  title: "Reversing around the corner",
                  level: "Intermidiate",
                  indicatorValue: 0.66,
                  price: 30,
                  content:
                      "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
              Lesson(
                  title: "Incorrect Use of Signal",
                  level: "Advanced",
                  indicatorValue: 1.0,
                  price: 50,
                  content:
                      "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
              Lesson(
                  title: "Engine Challenges",
                  level: "Advanced",
                  indicatorValue: 1.0,
                  price: 50,
                  content:
                      "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
              Lesson(
                  title: "Self Driving Car",
                  level: "Advanced",
                  indicatorValue: 1.0,
                  price: 50,
                  content:
                      "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.  ")
            ];
          }

