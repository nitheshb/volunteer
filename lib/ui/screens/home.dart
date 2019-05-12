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
  String collectionName = "Matches";
  @override
  void initState() {
    super.initState();
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
                      length:4,
                      child: Scaffold(
                        appBar:  AppBar(
                          backgroundColor: Color(0xFF0B4FFD),
                          actions: <Widget>[
                            Row(children: <Widget>[
                              Container(
                                height: 100.0,
                                width: 150.0,
                                padding: const EdgeInsets.all(5.0),
                                color: Color(0xFF0B4FFD),
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
                          bottom: TabBar(
                            isScrollable: true,
                            tabs: <Widget>[
                              Tab(text: "CRICKET"), 
                              Tab(text: "KABADDI"), 
                              Tab(text: "NBA"), 
                              Tab(text: "FOOTBALL"), 
                            ],
                          )
                        ),
                        body: Stack(children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                height:  160.0,
                                color: Colors.grey[350],
                                child: ListView.builder(
                                  
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:  _cImages.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return Container(
                                      child: Card(
                                        elevation: 2.0,
                                        child: Container(
                                          height: 150.0,
                                          width: 350.0,
                                          child: Image.asset(_cImages[index].image,fit: BoxFit.fill,),
                                          // fit: BoxFit.fill
                                        ),
                                      )
                                    );

                                  },
                                )
                              ),
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
                                    labelColor: Colors.blueGrey,
                                    tabs: [
                                      Tab(
                                        text: "FIXTURES"
                                      ),
                                      Tab(
                                        text: "LIVE"
                                      ),
                                      Tab(
                                        text: "RESULTS"
                                      )
                                    ]
                                  )
                                ),
                              ),
                              SizedBox(height: 25.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                Text("Pick an Upcoming match", style: TextStyle(color: Colors.grey[600])),
                                
                              ],),
                              
                              Expanded(child: Container(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(20.0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: 6,
                                  itemBuilder: (BuildContext context, int index){
                                    return new GestureDetector(
                                      onTap: (){
                                      Navigator.pushNamed(context, "/fixtures");
                                    },
                                   child: Container (
                                      height: 100.0,
                                      width: 188.0,
                                      child: Card(child: 
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Image.asset("assets/images/i.png", height: 100.0,
                                              width: 80.0),
                        
                                            ],),
                                            Column(
                                              crossAxisAlignment:  CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text("Indian T20 League"),
                                                SizedBox(height: 10.0,),
                                                Text("vs"),
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
                                            Row(
                                            children: <Widget>[
                                              Image.asset("assets/images/i.png",height: 100.0,
                                              width: 80.0),
                                              
                                            ],
                                            )
                                        ],
                                      )
                                      ),
                                    )
                                    );
                                  },
                                ),
                              ),)
                            ],
                          ),

                        ],
                        )
                      )
                      
                    );
        
              
            
                  }
                }
              }



 
