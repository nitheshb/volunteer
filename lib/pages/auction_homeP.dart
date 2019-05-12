import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_app_1/data/data.dart';
import 'package:test_app_1/pages/overview_page.dart';
import 'package:test_app_1/utils/screen_size.dart';
import 'package:test_app_1/widgets/add_button.dart';
import 'package:test_app_1/widgets/credit_card.dart';
import 'package:test_app_1/widgets/payment_card.dart';
import 'package:test_app_1/widgets/user_card.dart';

class AuctionHome extends StatefulWidget {
  AuctionHomeState createState() => AuctionHomeState();
}

class AuctionHomeState extends State<AuctionHome> with TickerProviderStateMixin {
   // The GlobalKey keeps track of the visible state of the list items
  // while they are being animated.
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  int myTotalBidLimit;  // backing data
  List myfavPlayers;
  List<String> _data = ['Sun', 'Moon', 'Star'];
  Timer _timer;
  int _start = 10;
  // temp stats
  // baseprice
  int base_price = 10;
  String currentBidder , currentHighestBidder ;


void initState() {
    myTotalBidLimit = 100;
    myfavPlayers=[];
    super.initState();
  }
  

@override
void dispose() {
  _timer.cancel();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            color: Colors.grey.shade50,
            height: _media.height / 2,
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
                              color: Theme.of(context).primaryColor,
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
                      left: 20,
                    ),
                    height: _media.longestSide <= 775
                        ? _media.height / 4
                        : _media.height / 4.3,
                    width: _media.width,
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
                              child: CreditCard(
                                card: getCreditCards()[index],
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
                            onPressed: () => print("Menu"),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Player Auction $_start",
                              style: TextStyle(
                                  fontSize: _media.longestSide <= 775 ? 35 : 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Varela"),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 36,
                            ),
                            onPressed: () => print("add"),
                          )
                        ],
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
                      left: 25.0, right: 10, bottom: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Money",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  left: 25.0, right: 0, bottom: 20, top: 20),  
                  child:Row(
            children: <Widget>[
              colorCard("Rewards", 35.170, 1, context, Color(0xFF1b5bff)),
              colorCard("Wallet", 4320, -1, context, Color(0xFFff3f5e)),
            ],
          ),
          ),
          SizedBox(
            height: 25,
          ),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  height: screenAwareSize(
                      _media.longestSide <= 775 ? 110 : 80, context),
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: getUsersCard().length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: AddButton());
                        }

                        return Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: UserCardWidget(
                            user: getUsersCard()[index - 1],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, bottom: 15, right: 10, top: 40),
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
                Column(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
    Widget colorCard(
      String text, double amount, int type, BuildContext context, Color color) {
    final _media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 15, right: 15),
      padding: EdgeInsets.all(15),
      height: screenAwareSize(90, context),
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
          )
        ],
      ),
    );
  }


  // This is the animated row with the Card.
                Widget _buildItem(String item, Animation animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Card(
                      child: ListTile(
                        title: Text(
                          item,
                          style: TextStyle(fontSize: 20),
                        ),
                        trailing: Visibility(
                          child:IconButton(
                          icon: Icon(Icons.exit_to_app,color: Colors.green,
                        ),
                        onPressed: (){
                          _removeThisBidder(item);
                        },
                        ),
                        visible: item != currentHighestBidder ,
                        ),
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
}
