// import 'dart:_http';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app_1/Interfaces/matches_I.dart';
import 'package:test_app_1/util/state_widget.dart';
import 'package:test_app_1/ui/screens/sign_in.dart';
import 'package:test_app_1/models/state.dart';


class CapVCapSelection extends StatefulWidget {
  CapVCapSelection({Key key, @required this.text, this.team, this.fixture  }) : super(key: key);
  final String text;
  final List team;
  final MatchesI fixture;
   int _selCaptainIndex = -1;
   int _selVCIndex = -1;
   int saveProgress = 0;

  @override
  _CapVCapSelectionState createState() => _CapVCapSelectionState();
}


class _CapVCapSelectionState extends State<CapVCapSelection> {  
  StateModel appState;
  int myTotalBidLimit;
  String collectionName = "TodayFixtures";
  bool isEditing = false;
  List MyfavPlayers;
  bool _loadingVisible = false;
  @override
  void initState() {
    print('transferred data = ${widget.team}');
    myTotalBidLimit = 100;
    MyfavPlayers= widget.team;
    super.initState();
  }

  


//  model 

 getMatches() {
    return Firestore.instance.collection(collectionName).snapshots();
  }

  addMatche() async {
 print("ghhhh");

 setState(() {
   widget.saveProgress = 1;
 });
 

 MyfavPlayers[widget._selCaptainIndex]['caption'] = true;
 MyfavPlayers[widget._selVCIndex]['vcaption'] = true;

 MyfavPlayers[widget._selCaptainIndex]['pid'] = MyfavPlayers[widget._selCaptainIndex]['pid'].toString()+"_c";
 MyfavPlayers[widget._selVCIndex]['pid'] = MyfavPlayers[widget._selVCIndex]['pid'].toString()+"_vc";
 
 print(MyfavPlayers);
try{
  print("processing azure api");
  var MyfavPlayersJ = json.encode(MyfavPlayers);
  var favPlayerA = MyfavPlayers.map((fruit) => fruit['pid'].toString()).toList();
print('fav players array is $favPlayerA');
  var body = {
    "uid": appState?.firebaseUserAuth?.uid ?? '',
  "fanteam": MyfavPlayersJ,
  "fanteam_a": favPlayerA,
  "cur_points": 0
};
    var url = 'https://ms-azure-endpoints.azurewebsites.net/addFanTeam';
var response = await Dio().post(url, data: body, options: 
  new Options(contentType:ContentType.parse("application/x-www-form-urlencoded")),
      );
var newTeamID = response.data;
var userId = appState?.firebaseUserAuth?.uid ?? '';

await update("dummy",userId ,newTeamID);

print('Response status: ${response}');
print('Response body: ${response.data}');
// print('Response body: ${json.decode(response.data)['obj']['_id']}');
setState(() {
  //  this value is set to 10 just me clear the if else and display tick icon.
   widget.saveProgress = 10;
 });
}
catch(e){
  print(e);
}
  
  }

  update( user, iamId,String newGameId) {
    print("inside update;;;;;");
    Firestore.instance.collection("Iam").document(iamId).updateData({"games": FieldValue.arrayUnion([newGameId])});
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
  print('=======>inside widgit data ${widget.team.length}');
    return Column(children: [
              Expanded(child: new ListView.builder(
          padding: const EdgeInsets.all(0.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,     
          itemCount: widget.team.length,
          itemBuilder: (BuildContext context, index){
          
                                            return  new  Card(
                                       child: ListTile(
                                         leading: CircleAvatar(
                                           backgroundColor: Colors.grey.shade800,
                                             backgroundImage: NetworkImage("https://d13ir53smqqeyp.cloudfront.net/player-images/1343.png"),
                                           ),
                                         title: Text(widget.team[index]["name"],style: TextStyle(
                                       fontSize: 20.0, // insert your font size here
                                     ),),
                                         subtitle: Text(widget.team[index]["base_price"].toString()),
                                         trailing: Row(
                                           mainAxisSize: MainAxisSize.min,
                                           // mainAxisAlignment: MainAxisAlignment.end,
                                      
                                           
                                           children: <Widget>[
                                              new Radio(
                                                           value: index,
                                                           groupValue: widget._selCaptainIndex,
                                                           
                                                onChanged: (int e) => _handleRadioValueChange1(e),
                                                                                              ),
                                                                                              new Text(
                                                                                                'Cap',
                                                                                                style: new TextStyle(fontSize: 16.0),
                                                                                              ),
                                                                                              new Radio(
                                                                                                value: index,
                                                                                                groupValue: widget._selVCIndex,
                                                                          onChanged: (int e) => _handleRadioValueChange2(e),
                                                                        ),
                                                                        new Text(
                                                                          'Vcap',
                                                                          style: new TextStyle(
                                                                            fontSize: 16.0,
                                                                          ),
                                                                        ),
                                                //   MaterialButton(
                                                //   child: Text('C'),
                                                //   minWidth: 50,
                                                //   textColor: Colors.black,
                                                //    shape: CircleBorder(side: BorderSide(
                                                //     color: Colors.blueAccent, width: 1.0,style: BorderStyle.solid)
                                                //   ),
                                                // )
                                                //       ,
                                                //       MaterialButton(
                                                //   child: Text('vc'),
                                                //   minWidth: 50,
                                                //   textColor: Colors.black,
                                                //    shape: CircleBorder(side: BorderSide(
                                                //     color: Colors.blueAccent, width: 1.0,style: BorderStyle.solid)
                                                //   ),
                                                // )
                                                                // color: Colors.blue,
                                                                // iconSize: 30,
                                                                // tooltip: 'Second screen',
                                                                // onPressed: () {
                                                                //   // move to other screen
                                                                //   addToFav(context, widget.team[index]);
                                                                // },
                                                      
                                                            
                                                            ],
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
                                                                                                  child: saveButtonAnime())),
                                                                                        ]);
                                                  }
                                                  // receive data from the FirstScreen as a parameter
                                                  // _SecondScreenState({Key key, @required this.text, this.team}) : super(key: key);
                                                
Widget saveButtonAnime() {
  print("save button state value is ${widget.saveProgress}");
    if (widget.saveProgress == 0) {
      return new Text(
        "Save My Team",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else if (widget.saveProgress == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

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
                                                                    print("fetching user value2 ${appState?.firebaseUserAuth?.uid ?? ''}");
                                                                  }
                                                    return  MaterialApp(
                                                      home: DefaultTabController(
                                                        length: 4,
                                                        child: Scaffold(
                                                          appBar: AppBar(
                                                            title: Text('Cap & Vcap Selection'),
                                                          ),
                                                          body: showPlayersListFilter(context, "Batsmen"),
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
                                                     
                                                            if(team['category'] == "Bat"){
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
                                                                    
                                                                    
                                                  void _handleRadioValueChange1(int value) {
                                                    print("selected Cap index is $value");


                                                    setState(() {
                                                      
      widget._selCaptainIndex = value;});
  }

  void _handleRadioValueChange2(int value) {
                                                    setState(() {
      widget._selVCIndex = value;});
  }

}
      
  