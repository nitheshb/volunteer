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


// this widget is useful in showinf the players list

Widget showPlayersListFilter(BuildContext context, String category) {
    return Column(children: [
              Expanded(child: new ListView.builder(
          padding: const EdgeInsets.all(20.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,     
          itemCount: widget.team.length,
          itemBuilder: (BuildContext context, index){
           return  widget.team[index]["category"] == category ? new  Card(
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
    ) : new Container();                                   
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
                                        ]);
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
              showPlayersListFilter(context, "Batsmen"),
              showPlayersListFilter(context, "Bowler"),
              showPlayersListFilter(context, "AR"),
              showPlayersListFilter(context, "WK"),
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
        // unselects already selected player

        myTotalBidLimit = (myTotalBidLimit + team['base_price']);
        MyfavPlayers.remove(team);
      }  // step 1: check for limit 
      else if( myTotalBidLimit >= team['base_price'])  {

      //   check for category and process it in function 
     
            if(team['category'] == "Batsmen"){
               playerlimitValidator(context,team['category'],team,3,5);
            }else if(team['category'] == "Bow"){
               playerlimitValidator(context,team['category'],team,3,5);
            }else if(team['category'] == "WK"){
               playerlimitValidator(context,team['category'],team,1,2);
            }else if(team['category'] == "All"){
               playerlimitValidator(context,team['category'],team,1,3);
            }
            }
          });
      
          print("fav is");
                       print(MyfavPlayers);
                      }
      
            Widget PlayersListDisplayW(BuildContext context, List PlayersList){
      
            }          

  //  this method witll takes care of validation 
        void playerlimitValidator(BuildContext context,category,player,min,max) {
             // get the current length of batsmen in MyfavPlayers
               int currentbatsCount =   MyfavPlayers.where((player) => player['category'] == category).toList().length;
              //  we cannot add 6 th bastsmen
               if(currentbatsCount == max){
                 Scaffold.of(context).showSnackBar(
                   SnackBar(
                     content: Text("$category limit $max reached...!"),
                     backgroundColor: Colors.redAccent,)
                 );
                print("current batsment $currentbatsCount");
                }else {
                  myTotalBidLimit = (myTotalBidLimit - player['base_price']);
                  MyfavPlayers.add(player);
                }
              print("${player['category']}");
              // myTotalBidLimit = (myTotalBidLimit - team['base_price']);
              //     MyfavPlayers.add(team);
              print("values is");
              print(myTotalBidLimit);
              print("teamis ${MyfavPlayers}");
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