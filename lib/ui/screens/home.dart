import 'package:flutter/material.dart';
import 'package:test_app_1/models/state.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:test_app_1/ui/screens/fixtures.dart';
import 'package:test_app_1/util/state_widget.dart';
import 'package:test_app_1/ui/screens/sign_in.dart';
import 'package:test_app_1/utils/imagesU.dart';
import 'package:test_app_1/ui/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app_1/utils/screen_size.dart';
import 'package:test_app_1/Interfaces/matches_I.dart';
import 'package:test_app_1/pages/fan_player_select_P.dart';
import 'package:test_app_1/pages/bid_player_select_p.dart';
import 'package:test_app_1/widgets/donut_charts.dart';
import 'package:test_app_1/widgets/wave_progress.dart';

var data = [
  new DataPerItem('Home', 35, Colors.greenAccent),
  new DataPerItem('Food & Drink', 25, Colors.yellow),
  new DataPerItem('Hotel & Restaurant', 24, Colors.indigo),
  new DataPerItem('Travelling', 40, Colors.pinkAccent),
];

var series = [
  new charts.Series(
    domainFn: (DataPerItem clickData, _) => clickData.name,
    measureFn: (DataPerItem clickData, _) => clickData.percent,
    colorFn: (DataPerItem clickData, _) => clickData.color,
    id: 'Item',
    data: data,
  ),
];

class CImages {
  CImages({this.image});
  String image;
}

final List<CImages> _cImages = <CImages>[
  CImages(image: 'assets/images/img2.gif'),
  CImages(image: 'assets/images/img3.png'),
  CImages(image: 'assets/images/img4.jpg'),
  CImages(image: 'assets/images/img1.png'),
];

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StateModel appState;
  bool _loadingVisible = false;
  String collectionName = "scheduleMaker";
  @override
  void initState() {
    super.initState();
  }


  getMatches() {
    return Firestore.instance.collection(collectionName).snapshots();
  }




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

                    return new DefaultTabController (
                      length:3,
                      child: Scaffold(
                        backgroundColor: Colors.white,
                        appBar:  AppBar(
                          // backgroundColor: Color(0xFF5C3997),
                          actions: <Widget>[
                            Row(children: <Widget>[
                              Container(
                                height: 100.0,
                                width: 150.0,
                                padding: const EdgeInsets.all(5.0),
                                // color: Color(0xFF5C3997),
                                child: Image.asset('logo'),
                              ),
                              SizedBox(width:130.0),
                              IconButton(
                                onPressed: () {
                                  debugPrint("Notification Tapped");
                                },
                                icon: Icon(Icons.notifications),
                              )
                            ],)
                          ],
                          // bottom: TabBar(
                          //   isScrollable: true,
                          //   tabs: <Widget>[
                          //     Tab(text: "CRICKET"), 
                          //     Tab(text: "KABADDI"), 
                          //     Tab(text: "NBA"), 
                          //     Tab(text: "FOOTBALL"), 
                          //   ],
                          // )
                        ),
                        body: Stack(children: <Widget>[
                          Column(
                            children: <Widget>[
                              Material(
                                elevation: 5.0,
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: TabBar(
                                    indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide(
                                       width:2.0
                                      )
                                    ),
                                    labelColor: Colors.black,
                                    tabs: [
                                      Tab(
                                        text: "FIXTURES"
                                      ),
                                      Tab(
                                        text: "LIVE"
                                      ),
                                      Tab(
                                        text: "RESULTS"
                                      ),
      
                                    ],
                                    
                                  )
                                ),
                              ),
                              Expanded(child: Container(
                                child:
                                StreamBuilder<QuerySnapshot>(
      stream: getMatches(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Documents of fixtures 1 ${snapshot.data.documents.length}");
          // return buildList(context, snapshot.data.documents);
        
                            return     ListView.builder(
                                  padding: const EdgeInsets.all(15.0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (BuildContext context, int index){
                                    DocumentSnapshot ds = snapshot.data.documents[index];
                                    print("ds snap is ${ds['matchDetails']['team-1']}");
                                    return new GestureDetector(
                                      onTap: (){

                                      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FixturesScreen(matchId: ds['matchDetails']['unique_id'], matchDetails:ds['matchDetails']),
        ));
                                    },
                                   child:   Padding(
                                               padding: EdgeInsets.only(top: 4.0), 
                                    child :Container (
                                      height: 100.0,
                                      width: 188.0,
                                      child: Card(
              elevation: 3,
              color: Colors.white,
                                        child: 
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[

                                          Padding(
                                               padding: EdgeInsets.only(top: 12.0),
                                          child:  Row(
                                            children: <Widget>[
                                              Column(children: <Widget>[
                                               Image.network(ds['matchDetails']['team_1_pic'],height: 50.0,
                                              width: 50.0),
                                              Text(ds['matchDetails']['team-1'], style: TextStyle(fontWeight: FontWeight.bold))
                                              ],)
                                            ],
                                            )
                                             ),
                                            Column(
                                              crossAxisAlignment:  CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text("Indian T20 League"),
                                                SizedBox(height: 10.0,),
                                                Text("vs", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16.0)),
                                                SizedBox(height: 10.0,),
                                                Row(
                                                  children: [
                                                    Container(
                                                      child: Text("07h 10m 27s")
                                                    )
                                                  ]
                                                  )
                                              ],
                                            ),
                                             Padding(
                                               padding: EdgeInsets.only(top: 12.0),
                                          child:  Row(
                                            children: <Widget>[
                                              Column(children: <Widget>[
                                              Image.network(ds['matchDetails']['team_2_pic'],height: 50.0,
                                              width: 50.0),
                                              Text(ds['matchDetails']['team-2'], style: TextStyle(fontWeight: FontWeight.bold))
                                              ],)
                                            ],
                                            )
                                             )
                                        ],
                                      )
                                      ),
                                    )
                                   )
                                    );
                                  },
                                );
                                }
        return CircularProgressIndicator();
      },
    ),
                                decoration: new BoxDecoration(
                                  boxShadow: [
                                        new BoxShadow(
                                          color: Colors.grey.shade300,
                                          
                                          blurRadius: 20.0,
                                          ),
                                          ],
                                  borderRadius: BorderRadius.circular(15),
      ),
                              ),
                              
                              )
                            ],
                          ),

                        ],
                        )
                      )
                      
                    );
        
              
            
                  }
                }
              }



 
