import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app_1/util/state_widget.dart';
import 'package:test_app_1/ui/screens/sign_in.dart';
import 'package:test_app_1/models/state.dart';


class SecondScreen extends StatefulWidget {
  SecondScreen({Key key, @required this.text, this.team  }) : super(key: key);
  final String text;
  final List team;

  @override
  _SecondScreenState createState() => _SecondScreenState();
}


class _SecondScreenState extends State<SecondScreen> {  
  StateModel appState;
  int myTotalBidLimit;
  String collectionName = "FanMatches";
  bool isEditing = false;
  List MyfavPlayers;
  bool _loadingVisible = false;
  @override
  void initState() {
    myTotalBidLimit = 100;
    MyfavPlayers=[];
    super.initState();
  }

  


//  model 

 getMatches() {
    return Firestore.instance.collection(collectionName).snapshots();
  }

  addMatche() {
    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
                    final firstName = appState?.user?.firstName ?? '';
                    final lastName = appState?.user?.lastName ?? '';
                    final settingsId = appState?.settings?.settingsId ?? '';
    print(userId);
    print(email);
    print(firstName);
    print(lastName);
    if(userId == ''){
      print("------------------------------>Nithesh");
      print("user is not signed... redirect him to login page");
    } else {
    // Map<dynamic> user = MyfavPlayers;
    try {
           Firestore.instance
              .collection(collectionName)
              .document()
              // .updateData({"data": MyfavPlayers});
              .setData({userId: MyfavPlayers});
    } catch (e) {
      print(e.toString());
    }
  }
  
  }

  // add() {
  //   if (isEditing) {
  //     // Update
  //     update(curMatche, controller.text);
  //     setState(() {
  //       isEditing = false;
  //     });
  //   } else {
  //     addMatche();
  //   }
  //   controller.text = '';
  // }

  update( user, String newName) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(user.reference, {'title': newName});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  delete( user) {
    Firestore.instance.runTransaction(
      (Transaction transaction) async {
        await transaction.delete(user.reference);
      },
    );
  }

  // receive data from the FirstScreen as a parameter
  // _SecondScreenState({Key key, @required this.text, this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     appState = StateWidget.of(context).state;
                  if (!appState.isLoading &&
                      (appState.firebaseUserAuth == null ||
                          appState.user == null ||
                          appState.settings == null)) {
                    return SignInScreen();
                  } else {
                    if (appState.isLoading) {
                      _loadingVisible = true;
                    } else {
                      _loadingVisible = false;
                    }
                    print("fetching user value ${appState?.firebaseUserAuth?.uid ?? ''}");
                  }
    return Scaffold(
      appBar: AppBar(title: Text('Fan Team Select'),
      ),
      body: Column(children: [
              Expanded(child: new ListView.builder(
                
          itemCount: widget.team.length,
          itemBuilder: (context, index){
            return new ListTile(
              leading: new Icon(Icons.flag),
              title: new Text(widget.team[index]["player_name"]),
              subtitle: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Container(
                              // tag: 'hero',
                              child: Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(widget.team[index]["base_price"].toString(),
                                  style: TextStyle(color: Colors.red))),
                              
                            )),
                        Expanded(
                          flex: 4,
                          child: LinearProgressIndicator(
                                  backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                                  value: (widget.team[index]["base_price"])/100,
                                  valueColor: AlwaysStoppedAnimation(Colors.green)),
                        )
                      ],
                    ),
              trailing: IconButton(
            icon: Icon(MyfavPlayers.contains(widget.team[index]) == true ? Icons.favorite : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              // move to other screen
              addToFav(context, widget.team[index]);
                                                      },
                                                    ),
                                          );
                                          
                                      },
                                    ),),
                                     Container(
                                              margin: EdgeInsets.all(10.0),
                                              child: RaisedButton(
                                                  color: Theme.of(context).primaryColor,
                                                  splashColor: Colors.blueGrey,
                                                  textColor: Colors.white,
                                                  onPressed: () {
                                                  print("save my team is pressed");
                                                  addMatche();
                                                  },
                                                  child: Text("Save This Team $myTotalBidLimit"))),
                                        ])
                                );
                              }
              
                void addToFav(BuildContext context, team) {
                 print("team is");
                 print(team);
                  setState(() {
      if (MyfavPlayers.contains(team)) {
        myTotalBidLimit = (myTotalBidLimit + team['base_price']);
        MyfavPlayers.remove(team);
      } else if( myTotalBidLimit >= team['base_price'])  {

        myTotalBidLimit = (myTotalBidLimit - team['base_price']);
        print("values is");
        print(myTotalBidLimit);
        MyfavPlayers.add(team);
      }
    });

    print("fav is");
                 print(MyfavPlayers);
                }
              
              }
              
//               void AddToFav(BuildContext context, team) {
// setState(() {
//       if (userFavorites.contains(recipeID)) {
//         userFavorites.remove(recipeID);
//       } else {
//         userFavorites.add(recipeID);
//       }
//     });
// }