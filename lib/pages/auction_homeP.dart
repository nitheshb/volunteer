import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:flutter/material.dart';
import 'package:test_app_1/data/data.dart';
import 'package:test_app_1/pages/overview_page.dart';
import 'package:test_app_1/utils/fire_db_help_file.dart';
import 'package:test_app_1/utils/screen_size.dart';
import 'package:test_app_1/widgets/add_button.dart';
//import 'package:test_app_1/widgets/credit_card.dart';
import 'package:test_app_1/widgets/payment_card.dart';
import 'package:test_app_1/widgets/user_card.dart';

class AuctionHome extends StatefulWidget {
   AuctionHome({Key key, @required this.bidTableId}) : super(key: key);
  final String bidTableId;


  @override
  AuctionHomeState createState() => AuctionHomeState();
}

enum ScoreWidgetStatus {
  HIDDEN,
  BECOMING_VISIBLE,
  VISIBLE,
  BECOMING_INVISIBLE
}
class AuctionHomeState extends State<AuctionHome> with TickerProviderStateMixin {
   // The GlobalKey keeps track of the visible state of the list items
  // while they are being animated.
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersBottomSheetCallBack;
  PersistentBottomSheetController _controllerBtmSheet; // instance variable

  int _counter = 0;
  double _sparklesAngle = 0.0;
  ScoreWidgetStatus _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
  final duration = new Duration(milliseconds: 400);
  final oneSecond = new Duration(seconds: 1);
  Random random;
  String checkVal;
  Timer holdTimer, scoreOutETA;
  AnimationController scoreInAnimationController, scoreOutAnimationController,
      scoreSizeAnimationController, sparklesAnimationController;
  Animation scoreOutPositionAnimation, sparklesAnimation;


  String collectionName = "smartPool";
  List MyBidPlayers;
  bool _loadingVisible = false;

  DocumentSnapshot results;

  int myTotalBidLimit;  // backing data
  List myfavPlayers;
  // List<String> _data = ['Sun', 'Moon', 'Star'];
  List _data =[];
  List _data1 =[{"bidderFirstName": "Sun1"}, {"bidderFirstName": "Moon1"}, {"bidderFirstName": "Star"}, {"bidderFirstName": "Mars"}];
  // List TeamPlayer= [{"base_price": 10, "id": "505l8Eup4NxAq1tpWioY", "player_name": "Ranatunga12", "category": "Batsmen", "team_name": "Srilanka", "points": "5"}, {"base_price": 10, "id": "phG1enf7kELGqcBJxCQP", "player_name": "Sangakara13", "category": "WK", "team_name": "srilanka", "points": 5}];
 List TeamPlayer, biddersArray;
 Stream biddersSnap;
  Timer _timer;
  int _start = 10;
  // temp stats
  // baseprice
  int base_price = 10;
  String currentBidder , currentHighestBidder ;
  String currentBidderCopy,activeBidPrice, activeHighBidBy;
  Map currentBidderObj;
  final activeBidder =  ValueNotifier(0);

  // activeBidderNotifier.addListener(_myCallback);

getMatches() {
    return Firestore.instance.collection(collectionName).snapshots();
  }


void initState() {
    MyBidPlayers = [];
    myTotalBidLimit = 100;
    myfavPlayers=[];
    TeamPlayer = [];
    biddersArray = [];
    checkVal = "boxer";
    super.initState();
    random = new Random();
    _showPersBottomSheetCallBack = _showBottomSheet;
    scoreInAnimationController = new AnimationController(duration: new Duration(milliseconds: 150), vsync: this);
    scoreInAnimationController.addListener((){
      setState(() {}); // Calls render function
    });

   Firestore.instance.collection(collectionName).document(widget.bidTableId).snapshots().listen((onData) {
        print("change notifier");
   });

  Stream streamFunc()  {
   return   Firestore.instance.collection(collectionName).document(widget.bidTableId).snapshots();
  }
  // 1) set active high bidder val + acive bidder name to display in Ui near pic
//  2) check if current active bider is logged in username to trigger bidder toolkit

  streamFunc().listen((result){
    print("super2 synced values1 ${result.data} ");
    //   setState(() {
    //  activeBidPrice = result.data['currentBidState']['bidVal'];
    //  activeHighBidBy = result.data['currentBidState']['bidBy'];
    // });

// progressTimer();
// synchronous 

    if(result.data['currentBidder']['bidderFirstName']== "venu12(h)"){
      setState(() {
       currentBidderObj =  result.data['currentBidder'];
       currentBidderCopy =  result.data['currentBidder']['bidderFirstName'];
      });
      print("inside popen sheeet condition11");
       showbtmSheet();
   
    }else {
      print("chekck on this bro");
      _controllerBtmSheet.close();
    }

  
  });
    
    print("values of snap snap snap ===> ${biddersSnap}");
  // check for snap 
    // Firestore.instance.collection(collectionName).document(widget.bidTableId).snapshots();


   Firestore.instance.collection(collectionName).document(widget.bidTableId).get().then((onValue){
     print(" why checerrrrrrrrrrrrrr ${onValue['team']}");
     setState(() {
      results = onValue; 
      TeamPlayer = results.data['team'];
      biddersArray = results.data['bidder'];
      // _data = results.data['bidderDetails'];
     });

 

   
     
   });


scoreOutAnimationController = new AnimationController(vsync: this, duration: duration);
    scoreOutPositionAnimation = new Tween(begin: 100.0, end: 150.0).animate(
      new CurvedAnimation(parent: scoreOutAnimationController, curve: Curves.easeOut)
    );
    scoreOutPositionAnimation.addListener((){
      setState(() {});
    });
    scoreOutAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
      }
    });

    scoreSizeAnimationController = new AnimationController(vsync: this, duration: new Duration(milliseconds: 150));
    scoreSizeAnimationController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        scoreSizeAnimationController.reverse();
      }
    });
    scoreSizeAnimationController.addListener((){
      setState(() {});
    });

    sparklesAnimationController = new AnimationController(vsync: this, duration: duration);
    sparklesAnimation = new CurvedAnimation(parent: sparklesAnimationController, curve: Curves.easeIn);
    sparklesAnimation.addListener((){
      setState(() { });
    });

  }



getBidders(){
  return Firestore.instance.collection(collectionName).document(widget.bidTableId).snapshots();
}
  getBidderDetails(){
      return StreamBuilder<DocumentSnapshot>(
        stream: getBidders(),
        builder: (context, snapshot){
          if(snapshot.hasData != null){
            return Column(
              children: <Widget>[
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: snapshot.data.data['activeBidders'].length,
                  itemBuilder: (context, index){
                    print("---> truee1 checker ${snapshot.data.data['bidders']}");
                     print("snapshotterrrrrrrrrrrr ${snapshot.data.data['currentBidder']['bidderFirstName']}");
                      // if(snapshot.data.data['currentBidder']['bidderFirstName'] == "venu12(h)"){
                      //   setState((){
                      //       // checkVal = "boxer1";
                      //   }); 
                      // }
                    return new Column(children: <Widget>[
                      Card( 
                        color: snapshot.data.data['activeBidders'][index]['bidderFirstName'] == snapshot.data.data['currentBidder']['bidderFirstName'] ? Colors.blue : Colors.white,//                           <-- Card widget
                child: ListTile(
                  // leading: Icon(icons[index]),
                  title: Text(snapshot.data.data['activeBidders'][index]['bidderFirstName'],
                  style: TextStyle(fontSize: 20, color: snapshot.data.data['activeBidders'][index]['bidderFirstName'] == snapshot.data.data['currentBidder']['bidderFirstName'] ? Colors.white : Colors.black)),
                  trailing: Column(
                              children: <Widget>[
                                Visibility(
                              child: new IconButton(
                              icon: Icon(Icons.exit_to_app,color: Colors.green,
                            ),
                            onPressed: (){
                              // _removeThisBidder(snapshot.data.data[index]);
                             
                              
                              passMeDeleteBidderFire(collectionName, widget.bidTableId, snapshot.data.data['activeBidders'][index]);
                            },
                            ),
                            visible: snapshot.data.data['activeBidders'][index]['bidderFirstName'] != activeHighBidBy ,
                            ),
                            Visibility(
                              child:
        new CircularPercentIndicator(
                      radius: 45.0,
                      lineWidth: 4.0,
                      percent: (_start *10)/100,
                      center: new Text("$_start %"),
                      progressColor: Colors.red,
                    ),
                    visible: snapshot.data.data['activeBidders'][index]['bidderFirstName'] == activeHighBidBy
                            )
                              ],
                            ),
                ),
          )

                    ]);
                  },  
                  
                ),
              // _buildBoxerToolChild(),

               
              ],
            );

            
          }
          else{
            Text("error check...");
          }
         
          
        }
      );
  
  }
  

  Widget _buildBoxerToolChild() {
  if (checkVal == "boxer1") {
    return Text("boxer is");
  }else {
    print("valid of boxer1 is $checkVal");
    return StreamBuilder<DocumentSnapshot>(
        stream: getBidders(),
        builder: (context, snapshot){
          if(snapshot.hasData != null){
            // a _scaffoldKey.currentState
             Scaffold.of(context)
        .showBottomSheet((context, {bool enableDrag : false}) {
          return new Container(
            height: 150.0,
            color: Colors.white,
            padding: new EdgeInsets.all(8.0),
            child: new Wrap(
            children: <Widget>[
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              btnBidPrice('1',Colors.pink[300]),
              btnBidPrice('3',Colors.orange[300]),
              btnBidPrice('5',Colors.lightBlue[300]),
              btnBidPrice('-',Colors.purple[300]),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              btnBidAction('SKIP',Colors.pink[300]),
              btnBidAction('BID',Colors.purple[300]),
            ],
            ),
            ],
          ),
          );
        }) .closed
        .whenComplete(() {
          if (mounted) {
//        setState(() { // re-enable the button
//          _showBottomSheetCallback = _showBottomSheet;
//          print ("_showBottomSheetCallback enable");
//        });
          }
        });
            // return Column(
            //   children: <Widget>[
            //     Text("this is bootmsheet modal") ]);
                }
                }
                );
  }
}
toolChecker(){
  print("inside tool breaker");
  if(checkVal == "boxer"){
  _showPersBottomSheetCallBack();

}
}

@override
void dispose() {
  _timer.cancel();
  super.dispose();
  scoreInAnimationController.dispose();
   scoreOutAnimationController.dispose();
}

showbtmSheet() {
   setState(() {
      _showPersBottomSheetCallBack = null;
    });
  _controllerBtmSheet = _scaffoldKey
    .currentState
    .showBottomSheet((BuildContext context) {
       return new Container(
            height: 150.0,
            color: Colors.white,
            padding: new EdgeInsets.all(8.0),
            child: new Wrap(
            children: <Widget>[
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              btnBidPrice('1',Colors.pink[300]),
              btnBidPrice('3',Colors.orange[300]),
              btnBidPrice('6',Colors.lightBlue[300]),
              btnBidPrice('-',Colors.purple[300]),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              btnBidAction('SKIP',Colors.pink[300]),
              btnBidAction('BID',Colors.purple[300]),
            ],
            ),
            ],
          ),
          );
  },
);
}

 void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

     _scaffoldKey.currentState
        .showBottomSheet((BuildContext context, {bool enableDrag : false}) {
          return new Container(
            height: 150.0,
            color: Colors.white,
            padding: new EdgeInsets.all(8.0),
            child: new Wrap(
            children: <Widget>[
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              btnBidPrice('1',Colors.pink[300]),
              btnBidPrice('3',Colors.orange[300]),
              btnBidPrice('6',Colors.lightBlue[300]),
              btnBidPrice('-',Colors.purple[300]),
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              btnBidAction('SKIP',Colors.pink[300]),
              btnBidAction('BID',Colors.purple[300]),
            ],
            ),
            ],
          ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showBottomSheet;
            });
          }
        }) ;
  }


  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            color: Colors.grey.shade50,
            width: _media.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, bottom: 5, right: 10, top: 40),
                      
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Auction Ground",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                shopItem(),
                 Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, bottom: 15, right: 10),
                      child: getBidderDetails()
          //          child: ListView.builder(
          //     primary: false,
          //     shrinkWrap: true,
          //     itemCount: snapshot.data.documents.length,
          //     itemBuilder: (context, index){
          //       return new Column(children: <Widget>[
          //         Card( //                           <-- Card widget
          //   child: ListTile(
          //     // leading: Icon(icons[index]),
          //     title: Text(snapshot.data.document[index]['bidderFirstName']),
          //     trailing: Column(
          //                 children: <Widget>[
          //                   Visibility(
          //                 child: new IconButton(
          //                 icon: Icon(Icons.exit_to_app,color: Colors.green,
          //               ),
          //               onPressed: (){
          //                 _removeThisBidder(snapshot.data.document[index]);
          //               },
          //               ),
          //               visible: snapshot.data.document[index]['bidderFirstName'] != currentHighestBidder ,
          //               ),
          //               Visibility(
          //               child: new Text("$_start"),
          //               visible: snapshot.data.document[index]['bidderFirstName'] == currentBidder ,
          //               ),
          //                 ],
          //               ),
          //   ),
          // )

          //       ]);
          //     },  
          //   );
                
        
                        
                // child: Column(
                //   mainAxisSize: MainAxisSize.min,
                //   children: <Widget>[
                //     NotificationListener<OverscrollIndicatorNotification>(
                //       onNotification: (overscroll) {
                //         overscroll.disallowGlow();
                //       },
                //       child: SizedBox(
                //         height: 300,
                        
                //         child: AnimatedList(
                //           // Give the Animated list the global key
                //           key: _listKey,
                //           initialItemCount: _data.length,
                //           // Similar to ListView itemBuilder, but AnimatedList has
                //           // an additional animation parameter.
                //           itemBuilder: (context, index, animation) {
                //             // Breaking the row widget out as a method so that we can
                //             // share it with the _removeSingleItem() method.
                //             return _buildItem(_data[index], animation);
                //           },
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                 )
              ],
            ),
          ),
          Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 new Text('You have pushed the button this many times:'),
                 new Text ('$_counter', style: Theme.of(context).textTheme.display1), 
            ],
            )
          ),
          Padding(padding: new EdgeInsets.only( right: 20.0),
          child: new Stack(
            alignment: FractionalOffset.center,
            overflow: Overflow.visible,
            children: <Widget>[
              getScoreButton(),
              getClapButton(),
            ],)
          )
          
        ],
      ),
    );
  }


 Widget btnBidPrice(btnText, Color color) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: new RaisedButton(
              child: Text(btnText,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white                
              ),
              ),
              onPressed: (){
                print("price button is pressed $btnText");
                updateBidPriceFire(collectionName, widget.bidTableId,btnText, currentBidderCopy);
                                // myIncrement(btnText);
                              },
                              color: color,
                              padding: EdgeInsets.all(18.0),
                              shape: CircleBorder()
                
                    )
                    );
                  } // end of price button
                
                  Widget btnBidAction(btnText, Color color) {
                    return Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: new RaisedButton(
                              child: Text(btnText,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white                    
                              ),
                              ),
                              onPressed: (){
                                print("skip or save button is pressed");
                              },
                              color: color,
                              padding: EdgeInsets.all(20),
                              shape: StadiumBorder()
                
                    )
                    );
                  } // end of buttons skip and bid
                
                    void increment(Timer t) {
                      print("click check");
                    scoreSizeAnimationController.forward(from: 0.0);
                    sparklesAnimationController.forward(from: 0.0);
                    setState(() {
                      _counter++;
                      currentHighestBidder = currentBidder;
                      _sparklesAngle = random.nextDouble() * (2*pi);
                    });
                  }
                
                
                  void myIncrement(String val){
                    if(val == "-" ){
                      setState(() {
                     _counter--; 
                    });
                
                    }else{
                      setState(() {
                     _counter = _counter + int.parse(val); 
                     currentHighestBidder = currentBidder;
                    });
                    }
                    
                  }
                  void onTapDown(TapDownDetails tap) {
                    // User pressed the button. This can be a tap or a hold.
                    if (scoreOutETA != null) {
                      scoreOutETA.cancel(); // We do not want the score to vanish!
                    }
                    if(_scoreWidgetStatus == ScoreWidgetStatus.BECOMING_INVISIBLE) {
                      // We tapped down while the widget was flying up. Need to cancel that animation.
                      scoreOutAnimationController.stop(canceled: true);
                      _scoreWidgetStatus = ScoreWidgetStatus.VISIBLE;
                    }
                    else if (_scoreWidgetStatus == ScoreWidgetStatus.HIDDEN ) {
                        _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_VISIBLE;
                        scoreInAnimationController.forward(from: 0.0);
                    }
                    increment(null); // Take care of tap
                    holdTimer = new Timer.periodic(duration, increment); // Takes care of hold
                  }
                
                  void onTapUp(TapUpDetails tap) {
                    // User removed his finger from button.
                    scoreOutETA = new Timer(oneSecond, () {
                      scoreOutAnimationController.forward(from: 0.0);
                      _scoreWidgetStatus = ScoreWidgetStatus.BECOMING_INVISIBLE;
                    });
                    holdTimer.cancel();
                  }
                
                  Widget getScoreButton() {
                    var scorePosition = 0.0;
                    var scoreOpacity = 0.0;
                    var extraSize = 0.0;
                    switch(_scoreWidgetStatus) {
                      case ScoreWidgetStatus.HIDDEN:
                        break;
                      case ScoreWidgetStatus.BECOMING_VISIBLE :
                      case ScoreWidgetStatus.VISIBLE:
                        scorePosition = scoreInAnimationController.value * 100;
                        scoreOpacity = scoreInAnimationController.value;
                        extraSize = scoreSizeAnimationController.value * 3;
                        break;
                      case ScoreWidgetStatus.BECOMING_INVISIBLE:
                        scorePosition = scoreOutPositionAnimation.value;
                        scoreOpacity = 1.0 - scoreOutAnimationController.value;
                    }
                
                    var stackChildren = <Widget>[
                    ];
                
                    var firstAngle = _sparklesAngle;
                    var sparkleRadius = (sparklesAnimationController.value * 50) ;
                    var sparklesOpacity = (1 - sparklesAnimation.value);
                
                    for(int i = 0;i < 5; ++i) {
                      var currentAngle = (firstAngle + ((2*pi)/5)*(i));
                      var sparklesWidget =
                        new Positioned(child: new Transform.rotate(
                            angle: currentAngle - pi/2,
                            child: new Opacity(opacity: sparklesOpacity,
                                child : new Image.asset("assets/images/sparkles.png", width: 10.0, height: 10.0, ))
                          ),
                          left:(sparkleRadius*cos(currentAngle)) + 20,
                          top: (sparkleRadius* sin(currentAngle)) + 20 ,
                      );
                      stackChildren.add(sparklesWidget);
                    }
                
                    stackChildren.add(new Opacity(opacity: scoreOpacity, child: new Container(
                        height: 50.0 + extraSize,
                        width: 50.0  + extraSize,
                        decoration: new ShapeDecoration(
                          shape: new CircleBorder(
                              side: BorderSide.none
                          ),
                          color: Colors.pink,
                        ),
                        child: new Center(child:
                        new Text("+" + _counter.toString(),
                          style: new TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),))
                    )));
                
                
                    var widget =  new Positioned(
                        child: new Stack(
                          alignment: FractionalOffset.center,
                          overflow: Overflow.visible,
                          children: stackChildren,
                        )
                        ,
                        bottom: scorePosition
                    );
                    return widget;
                  }
                
                  Widget getClapButton() {
                    // Using custom gesture detector because we want to keep increasing the claps
                    // when user holds the button.
                
                    var extraSize = 0.0;
                    if (_scoreWidgetStatus == ScoreWidgetStatus.VISIBLE || _scoreWidgetStatus == ScoreWidgetStatus.BECOMING_VISIBLE) {
                      extraSize = scoreSizeAnimationController.value * 3;
                    }
                    return new GestureDetector(
                        onTapUp: onTapUp,
                        onTapDown: onTapDown,
                        child: new Container(
                          height: 60.0 + extraSize ,
                          width: 60.0 + extraSize,
                          padding: new EdgeInsets.all(10.0),
                          decoration: new BoxDecoration(
                              border: new Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                              borderRadius: new BorderRadius.circular(50.0),
                              color: Colors.white,
                              boxShadow: [
                                new BoxShadow(color: Theme.of(context).primaryColor, blurRadius: 8.0)
                              ]
                          ),
                          child: new ImageIcon(
                              new AssetImage("assets/images/clap.png"), color: Theme.of(context).primaryColor,
                              size: 30.0),
                        )
                    );
                  }
                
                  Widget highestBidCard(
                      String text, List amount, int type, BuildContext context, Color color, activePrice, activeHighBy) {
                        // int bidAmount = amount[0]['base_price'];
                    final _media = MediaQuery.of(context).size;
                    return Container(
                      margin: EdgeInsets.only(top: 0, left: 150),
                      padding: EdgeInsets.all(15),
                      height: screenAwareSize(70, context),
                      width: _media.width / 2 - 34,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 16,
                                spreadRadius: 0.2,
                                offset: Offset(0, 8)),
                          ]),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "100 as Highest Bid",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "By nithesh",
                            style: TextStyle(
                              
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                    Widget colorCard(
                      String text, List amount, int type, BuildContext context, Color color, activePrice, activeHighBy) {
                        int bidAmount = amount[0]['base_price'];
                    final _media = MediaQuery.of(context).size;
                    return Container(
                      margin: EdgeInsets.only(top: 15, right: 15),
                      padding: EdgeInsets.all(15),
                      height: screenAwareSize(120, context),
                      width: _media.width / 2 - 34,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 16,
                                spreadRadius: 0.2,
                                offset: Offset(0, 8)),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            text,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${type > 0 ? "" : "-"} \$ ${bidAmount}, \$ $activePrice",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "by $currentHighestBidder , $activeHighBy",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                
                
                Widget _buildBidder(String item) {
                  return Card(
                                      child: new ListTile(
                                        title: new Text(
                                          item,
                                          style: TextStyle(fontSize: 20 ),
                                        ),
                                        trailing:
                                        new Column(
                                          children: <Widget>[
                                            Visibility(
                                          child: new IconButton(
                                          icon: Icon(Icons.exit_to_app,color: Colors.green,
                                        ),
                                        onPressed: (){
                                          _removeThisBidder(item);
                                        },
                                        ),
                                        visible: item != currentHighestBidder ,
                                        ),
                                        Visibility(
                                        child: new Text("$_start"),
                                        visible: item == currentBidder ,
                                        ),
                                          ],
                                        )
                                         
                                      ),
                                    );
                
                }
                
                  // This is the animated row with the Card.
                                Widget _buildItem(String item, Animation animation) {
                                  return SizeTransition(
                                    sizeFactor: animation,
                                    child: new Card(
                                      child: new ListTile(
                                        title: new Text(
                                          item,
                                          style: TextStyle(fontSize: 20, color: Colors.white),
                                        ),
                                        trailing:
                                        new Column(
                                          children: <Widget>[
                                            Visibility(
                                          child: new IconButton(
                                          icon: Icon(Icons.exit_to_app,color: Colors.green,
                                        ),
                                        onPressed: (){
                                          _removeThisBidder(item);
                                        },
                                        ),
                                        visible: item != currentHighestBidder ,
                                        ),
                                        Visibility(
                                        child: new Text("$_start"),
                                        visible: item == currentBidder ,
                                        ),
                                          ],
                                        )
                                         
                                      ),
                                    ),
                                  );
                                }
                
                
                          void _removeThisBidder(bidder) {
                
                                  // if remove item === currentHighest bidder then he can't quit
                
                                  // if( )
                              
                                  // removes first element and insert it at last
                                  int removeIndex = 0;
                                  // Remove item from data list but keep copy to give to the animation.
                                  String removedItem = _data.removeAt(removeIndex);
                                  // This builder is just for showing the row while it is still
                                  // animating away. The item is already gone from the data list.
                                  AnimatedListRemovedItemBuilder builder = (context, animation) {
                                    return _buildItem(removedItem, animation);
                                  };
                                  // Remove the item visually from the AnimatedList.
                                  _listKey.currentState.removeItem(removeIndex, builder);
                              
                                }  
                
                        void progressTimer(){
                           const oneSec = const Duration(seconds: 1);
                                _timer = new Timer.periodic(
                                    oneSec,
                                    (Timer timer) => setState(() {
                                          if (_start < 1) {
                                            // bidderIndex= bidderIndex + 1;
                                            // updateCurrentBidder(bidderIndex);
                                            // _bidItemRotator();
                                            timer.cancel();
                                          } else {
                                            _start = _start - 1;
                                          }
                                        }));
                        }
                         void startTimer() {
                                  // cancels if the timer exists
                                  // this occurs when user skips his this turn after filling the score
                                  if(_start !=10){
                                    _timer.cancel();
                                    setState(() {
                                    _start = 10;
                                    });
                                  }
                
                                  //verify here for skip as this resets to index 0
                                    
                
                                    int bidderIndex = 0;
                                
                                   setState(() {
                                    currentBidder = _data[bidderIndex]['bidderFirstName'];
                                  });
                                  print("current bidder is $currentBidder");
                                const oneSec = const Duration(seconds: 1);
                                _timer = new Timer.periodic(
                                    oneSec,
                                    (Timer timer) => setState(() {
                                          if (_start < 1) {
                                            // bidderIndex= bidderIndex + 1;
                                            // updateCurrentBidder(bidderIndex);
                                            // _bidItemRotator();
                                            timer.cancel();
                                          } else {
                                            _start = _start - 1;
                                          }
                                        }));
                              }  
                              void updateCurrentBidder(int curIndex){
                                setState(() {
                                   currentBidder = _data[curIndex]['bidderFirstName'];
                                });
                              }
                
                               void _bidItemRotator(){
                                  // removes first element and insert it at last
                                  int removeIndex = 0;
                                  // Remove item from data list but keep copy to give to the animation.
                                  String removedItem = _data.removeAt(removeIndex);
                                  // This builder is just for showing the row while it is still
                                  // animating away. The item is already gone from the data list.
                                  AnimatedListRemovedItemBuilder builder = (context, animation) {
                                    return _buildItem(removedItem, animation);
                                  };
                                  // Remove the item visually from the AnimatedList.
                                  _listKey.currentState.removeItem(removeIndex, builder);
                              
                              
                                  //  adds the deleted item back to end of the list
                                  _insertDeletedItem(removedItem);
                                  
                
                                  // above this end of list rototar
                
                                  //start of tools sheet bottom
                                  if(currentBidder == "rahul"){
                                    _showPersBottomSheetCallBack();
                                  }else if(_showPersBottomSheetCallBack == null){
                                    Navigator.pop(context);
                                  }
                                }      
                
                                 void _insertDeletedItem(bidder) {
                                  String newItem = bidder;
                                  // Arbitrary location for demonstration purposes
                                  int insertIndex = _data.length;
                                  // Add the item to the data list.
                                  _data.insert(insertIndex, newItem);
                                  // Add the item visually to the AnimatedList.
                                  _listKey.currentState.insertItem(insertIndex);
                              
                                  // enables timer to keep on happen
                                  startTimer();
                                 
                                }    
                
                                void _bidOptionsModalBottomSheet(context){
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc){
                          return Container(
                            padding: new EdgeInsets.all(8.0),
                            child: new Wrap(
                            children: <Widget>[
                              Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                              btnBidPrice('1',Colors.pink[300]),
                              btnBidPrice('3',Colors.orange[300]),
                              btnBidPrice('5',Colors.lightBlue[300]),
                              btnBidPrice('-',Colors.purple[300]),
                            ],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                              btnBidAction('SKIP',Colors.pink[300]),
                              btnBidAction('BID',Colors.purple[300]),
                            ],
                            ),
                            ],
                          ),
                          );
                      }
                    );
                }

  Widget shopItem()
  {
    return Padding
    (
      padding: EdgeInsets.all(16.0),
      child: Stack
      (
        children: <Widget>
        [
          /// Item card
          Align
          (
            alignment: Alignment.topCenter,
            child: SizedBox.fromSize
            (
              size: Size.fromHeight(180.0),
              child: Stack
              (
                fit: StackFit.expand,
                children: <Widget>
                [
                  /// Item description inside a material
                  Container
                  (
                    margin: EdgeInsets.only(top: 20.0),
                    child: Material
                    (
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(12.0),
                      shadowColor: Color(0x802196F3),
                      color: Colors.white,
                      child: InkWell
                      (
                        // onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ItemReviewsPage())),
                        child: Padding
                        (
                          padding: EdgeInsets.all(24.0),
                          child: Column
                          (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [
                              /// Title and rating
                              Column
                              (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>
                                [
                                  // Padding(
                                  //       Text('Nike Jordan III', style: TextStyle(color: Colors.blueAccent)), padding: ,
                                  // ),
                        //           Padding
                        // (
                        //   padding: EdgeInsets.only(left:124.0),
                        //   child: Text('Nike JORDAN'))
               
                                               highestBidCard("Highest Bid0", TeamPlayer, 1, context, Color(0xFF1b5bff), activeBidPrice,activeHighBidBy),
                                                                                  ],
                              ),
                              /// Infos
                              Row
                              (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  
                                    /// Title and rating
                              Column
                              (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
        new Text("Rohit Sharma",
          style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
          ),),
        new Text("Batsmen", style:
          new TextStyle(color: Colors.grey),),
      ],
                              ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  /// Item image
                  Align
                  (
                    alignment: Alignment.topLeft,
                    child: Padding
                    (
                      padding: EdgeInsets.only(left: 16.0),
                      child: SizedBox.fromSize
                      (
                        size: Size.fromRadius(54.0),
                        child: Material
                        (
                          elevation: 20.0,
                          shadowColor: Color(0x802196F3),
                          shape: CircleBorder(),
                          child:  CircleAvatar(
  radius: 20,
  backgroundImage: NetworkImage('http://t1.gstatic.com/images?q=tbn:ANd9GcR_XkfDWQpnP4FqejGDaDo4xBXo9dFzLJgrQH0-HWdyG9-mhiBDP_Gx311LYemlGyOUt15_1vk')
)
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ),
          ),
          
        ],
      ),
    );
  }


                }

   


                
     
