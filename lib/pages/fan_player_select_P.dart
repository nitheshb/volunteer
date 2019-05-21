import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  String collectionName = "TodayFixtures";
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

  addMatche() async {
 print("ghhhh");
 print(MyfavPlayers);
try{
  print("processing azure api");
  var body = json.encode({
  "p_sale_gross": MyfavPlayers
});
    var url = 'https://xsports.azurewebsites.net/api/HttpTrigger1';
var response = await http.post(url, body: body);
print('Response status: ${response.statusCode}');
print('Response body: ${response.body}');
}
catch(e){
  print(e);
}


//     final userId = appState?.firebaseUserAuth?.uid ?? '';
//     final email = appState?.firebaseUserAuth?.email ?? '';
//                     final firstName = appState?.user?.firstName ?? '';
//                     final lastName = appState?.user?.lastName ?? '';
//                     final settingsId = appState?.settings?.settingsId ?? '';
//     print(userId);
//     print(email);
//     print(firstName);
//     print(lastName);
//     if(userId == ''){
//       print("------------------------------>Nithesh");
//       print("user is not signed... redirect him to login page");
//     } else {
//       print("inside this");
//     // Map<dynamic> user = MyfavPlayers;
//     try {
//       var url = 'https://xsports.azurewebsites.net/api/HttpTrigger1';
// var response = await http.post(url, body: {'p_sale_gross': "300", 'color': 'blue'});
// print('Response status: ${response}');
// print('Response body: ${response}');
//           //  Firestore.instance
//           //     .collection(collectionName)
//           //     .document()
//           //     // .updateData({"data": MyfavPlayers});
//           //     .setData({userId: MyfavPlayers});
//     } catch (e) {
//       print(e);
//     }
//   }
  
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
    return  MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "BAT",),
                Tab(text: "BOW"),
                Tab(text: "AR"),
                Tab(text: "WK"),
              ],
            ),
            title: Text('Fav Players Selection'),
          ),
          body: TabBarView(
            children: [
              //  TODO: put this in widget....... end of block also mentioned
              Column(children: [
              Expanded(child: new ListView.builder(
          padding: const EdgeInsets.all(20.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,     
          itemCount: widget.team.length,
          itemBuilder: (BuildContext context, index){
           return new  Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade800,
            backgroundImage: NetworkImage("https://d13ir53smqqeyp.cloudfront.net/player-images/1343.png"),
          ),
        title: Text(widget.team[index]["player_name"],style: TextStyle(
      fontSize: 20.0, // insert your font size here
    ),),
        subtitle: Text(widget.team[index]["base_price"].toString()),
        trailing: IconButton(
            icon: Icon(MyfavPlayers.contains(widget.team[index]) == true ? Icons.favorite : Icons.favorite_border),
            color: Colors.blue,
            iconSize: 35,
            tooltip: 'Second screen',
            onPressed: () {
              // move to other screen
              addToFav(context, widget.team[index]);
            },
      ),
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
                                        ]),

                                        // TODO: end of block to mention in App
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
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

      Widget PlayersListDisplayW(BuildContext context, List PlayersList){

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