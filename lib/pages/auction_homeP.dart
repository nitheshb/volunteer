import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:test_app_1/data/data.dart';
import 'package:test_app_1/pages/overview_page.dart';
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

  int _counter = 0;
  double _sparklesAngle = 0.0;
  ScoreWidgetStatus _scoreWidgetStatus = ScoreWidgetStatus.HIDDEN;
  final duration = new Duration(milliseconds: 400);
  final oneSecond = new Duration(seconds: 1);
  Random random;
  Timer holdTimer, scoreOutETA;
  AnimationController scoreInAnimationController, scoreOutAnimationController,
      scoreSizeAnimationController, sparklesAnimationController;
  Animation scoreOutPositionAnimation, sparklesAnimation;


  String collectionName = "LiveBid";
  List MyBidPlayers;
  bool _loadingVisible = false;

  int myTotalBidLimit;  // backing data
  List myfavPlayers;
  List<String> _data = ['Sun', 'Moon', 'Star'];
  Timer _timer;
  int _start = 10;
  // temp stats
  // baseprice
  int base_price = 10;
  String currentBidder , currentHighestBidder ;

getMatches() {
    return Firestore.instance.collection(collectionName).snapshots();
  }


void initState() {
    MyBidPlayers = [];
    myTotalBidLimit = 100;
    myfavPlayers=[];
    super.initState();
    random = new Random();
    _showPersBottomSheetCallBack = _showBottomSheet;
    scoreInAnimationController = new AnimationController(duration: new Duration(milliseconds: 150), vsync: this);
    scoreInAnimationController.addListener((){
      setState(() {}); // Calls render function
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
  

@override
void dispose() {
  _timer.cancel();
  super.dispose();
  scoreInAnimationController.dispose();
   scoreOutAnimationController.dispose();
}

 void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState
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
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
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
            height: _media.height / 2.8,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Stack(
                        children: <Widget>[
                          Material(
                            elevation: 4,
                            child: Container(
                              color: Color(0xFF1b5bff),
                            ),
                          ),
                          Opacity(
                            opacity: 0.3,
                            child: Container(
                              color: Colors.black87,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 10,
                    ),
                    height: _media.longestSide <= 775
                        ? _media.height / 4
                        : _media.height / 4.4,
                    width: _media.width,
                    // padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 10),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: getCreditCards().length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OverviewPage())),
                              child: Card(child: 
                              
                                      Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          SizedBox(width: 10.0,),
                                          SizedBox(height: 30.0,),
                                          Column(
                                            children: <Widget>[
                                              Image.asset("assets/images/dhoni.jpg",height: screenAwareSize(110, context),
                                              width: screenAwareSize(110, context), ),
                                              Text("Dhoni")
                                              
                                            ],
                                            ),
                                            Column(
                                              crossAxisAlignment:  CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Stack(
            alignment: FractionalOffset.center,
            overflow: Overflow.visible,
            children: <Widget>[
              getScoreButton(),
              getClapButton(),
            ],)
                                              ],
                                            ),
                                            SizedBox(width: 10,),
                                                         Column(
                                            children: <Widget>[
                                               colorCard("Highest Bid", _counter, 1, context, Color(0xFF1b5bff)),

                                            ],),
                                            SizedBox(width: 10,)
                                        ],
                                      )
                                      ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: _media.longestSide <= 775
                      ? screenAwareSize(20, context)
                      : screenAwareSize(35, context),
                  left: 10,
                  right: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {print("Menu");
                            //  _bidOptionsModalBottomSheet(context);
                            _showPersBottomSheetCallBack();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () { print("start Timer");
                            startTimer();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade50,
            width: _media.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, bottom: 5, right: 10, top: 10),
                      
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Bidders",
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
                 Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, bottom: 15, right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: SizedBox(
                        height: 300,
                        child: AnimatedList(
                          // Give the Animated list the global key
                          key: _listKey,
                          initialItemCount: _data.length,
                          // Similar to ListView itemBuilder, but AnimatedList has
                          // an additional animation parameter.
                          itemBuilder: (context, index, animation) {
                            // Breaking the row widget out as a method so that we can
                            // share it with the _removeSingleItem() method.
                            return _buildItem(_data[index], animation);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
                myIncrement(btnText);
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


    Widget colorCard(
      String text, int amount, int type, BuildContext context, Color color) {
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
            "${type > 0 ? "" : "-"} \$ ${amount.toString()}",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "by $currentHighestBidder",
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


  // This is the animated row with the Card.
                Widget _buildItem(String item, Animation animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: new Card(
                      child: new ListTile(
                        title: new Text(
                          item,
                          style: TextStyle(fontSize: 20),
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


         void startTimer() {
                  // cancels if the timer exists
                  // this occurs when user skips his this turn after filling the score
                  if(_start !=10){
                    _timer.cancel();
                    setState(() {
                    _start = 10;
                    });
                  }

                   setState(() {
                    currentBidder = _data[0];
                  });
                  print(_data[0]);
                const oneSec = const Duration(seconds: 1);
                _timer = new Timer.periodic(
                    oneSec,
                    (Timer timer) => setState(() {
                          if (_start < 1) {
                            _bidItemRotator();
                            timer.cancel();
                          } else {
                            _start = _start - 1;
                          }
                        }));
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
                  if(currentBidder == "Moon"){
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
}
