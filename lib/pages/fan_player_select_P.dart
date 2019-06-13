import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app_1/Interfaces/matches_I.dart';
import 'package:test_app_1/util/state_widget.dart';
import 'package:test_app_1/ui/screens/sign_in.dart';
import 'package:test_app_1/models/state.dart';

import 'capVcapSet.dart';


class SecondScreen extends StatefulWidget {
  SecondScreen({Key key, @required this.text, this.team , this.fixture }) : super(key: key);
  final String text;
  final List team;
  MatchesI fixture;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
          padding: const EdgeInsets.all(0.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,     
          itemCount: widget.team.length,
          itemBuilder: (BuildContext context, index){
           return  widget.team[index]["category"] == category ? new  Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade800,
            backgroundImage: NetworkImage(widget.team[index]["pic_url"]),
          ),
        title: Text(widget.team[index]["name"],style: TextStyle(
      fontSize: 20.0, // insert your font size here
    ),),
        subtitle: Text(widget.team[index]["base_price"].toString()),
        trailing: IconButton(
            icon: Icon(MyfavPlayers.contains(widget.team[index]) == true ? Icons.star : Icons.star_border),
            color: Colors.blue,
            iconSize: 30,
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
              showPlayersListFilter(context, "Bat"),
              showPlayersListFilter(context, "Bowler"),
              showPlayersListFilter(context, "AR"),
              showPlayersListFilter(context, "WK"),
            ],
          ),

             floatingActionButton: new Builder(builder: (BuildContext context) {
        return new FloatingActionButton.extended(
          onPressed: () {
             playerMinlimitValidator(context);
          // Scaffold
          //     .of(context)
          //     .showSnackBar(new SnackBar(content: new Text('Hello!')));
        },
        icon: Icon(Icons.save),
        label: Text("set Caption"),
        );
         
      },
             )
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

        myTotalBidLimit = (myTotalBidLimit + int.parse(team['base_price']));
        MyfavPlayers.remove(team);
      }  // step 1: check for limit 
      else if( myTotalBidLimit >= int.parse(team['base_price']))  {

      //   check for category and process it in function 
     
            if(team['category'] == "Bat"){
               playerMaxlimitValidator(context,team['category'],team,3,1);
            }else if(team['category'] == "Bow"){
               playerMaxlimitValidator(context,team['category'],team,3,5);
            }else if(team['category'] == "WK"){
               playerMaxlimitValidator(context,team['category'],team,1,2);
            }else if(team['category'] == "All"){
               playerMaxlimitValidator(context,team['category'],team,1,3);
            }
            }
          });
      
          print("fav is");
                       print(MyfavPlayers);
                      }
             

  //  this method witll takes care of validation 
        void playerMaxlimitValidator(BuildContext context,category,player,min,max) {
             // get the current length of batsmen in MyfavPlayers
               int currentbatsCount =   MyfavPlayers.where((player) => player['category'] == category).toList().length;
               String val = "val_$category";
               
              //  we cannot add 6 th bastsmen
               if(currentbatsCount == max){


                 Scaffold.of(context).showSnackBar(
                   SnackBar(
                     content: Text("$category limit $max reached...!"),
                     backgroundColor: Colors.redAccent,)
                 );
                print("current batsment $currentbatsCount");
                }else {
                  myTotalBidLimit = (myTotalBidLimit - int.parse(player['base_price']));
                  MyfavPlayers.add(player);
                }
              print("${player['category']}");
              // myTotalBidLimit = (myTotalBidLimit - team['base_price']);
              //     MyfavPlayers.add(team);
              print("values is");
              print(myTotalBidLimit);
              print("teamis ${MyfavPlayers}");
}



  //  this method witll takes care of validation 
        void playerMinlimitValidator(BuildContext context) {
             // get the current length of batsmen in MyfavPlayers
               int BatsCount =   MyfavPlayers.where((player) => player['category'] == "Batsmen").toList().length;
               int BowCount =   MyfavPlayers.where((player) => player['category'] == "Bow").toList().length;
               int WKCount =   MyfavPlayers.where((player) => player['category'] == "WK").toList().length;
               int AllCount =   MyfavPlayers.where((player) => player['category'] == "All").toList().length;
               
//  this navigation code be removed 
                Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CapVCapSelection(text: "cap Vcap set", team: MyfavPlayers, fixture: widget.fixture),
        ));

               print(" values are , $BatsCount");
              //  we cannot add 6 th bastsmen
               if(BatsCount < 1){
                 print("inside limit checker of batsCount");

                   Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Min 3 Batsmen Required"),
                backgroundColor: Colors.blueAccent,
                duration: Duration(seconds: 3),
              ));
                //  Scaffold.of(context).showSnackBar(
                //    SnackBar(
                //      content: Text("Select min 3 Batsmen"),
                //      backgroundColor: Colors.redAccent,)
                //  );
                }else if(BowCount < 3){
                 Scaffold.of(context).showSnackBar(
                   SnackBar(
                     content: Text("Selected min 3 Bowlers"),
                     backgroundColor: Colors.redAccent,)
                 );
                }else if(WKCount < 1){
                 Scaffold.of(context).showSnackBar(
                   SnackBar(
                     content: Text("Selected min 1 WK"),
                     backgroundColor: Colors.redAccent,)
                 );
                }else if(AllCount < 1){
                 Scaffold.of(context).showSnackBar(
                   SnackBar(
                     content: Text("Selected min 1 All Rounders"),
                     backgroundColor: Colors.redAccent,)
                 );
                }
                else {
                  Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CapVCapSelection(text: "cap Vcap set", team: MyfavPlayers),
        ));
                }
             
              // myTotalBidLimit = (myTotalBidLimit - team['base_price']);
              //     MyfavPlayers.add(team);
              print("values is");
              print(myTotalBidLimit);
              print("teamis ${MyfavPlayers}");
}          

//  if(team['category'] == "Batsmen"){
//                playerMaxlimitValidator(context,team['category'],team,3,1);
//             }else if(team['category'] == "Bow"){
//                playerMaxlimitValidator(context,team['category'],team,3,5);
//             }else if(team['category'] == "WK"){
//                playerMaxlimitValidator(context,team['category'],team,1,2);
//             }else if(team['category'] == "All"){
//                playerMaxlimitValidator(context,team['category'],team,1,3);
//             }
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