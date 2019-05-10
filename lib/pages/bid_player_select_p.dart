import 'dart:async';

import 'package:flutter/material.dart';

class BidPlayerSelectP extends StatelessWidget {
  final String text;
  // receive data from the FirstScreen as a parameter
  BidPlayerSelectP({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('bid screen')),
      body: BodyLayout(),
    );
  }
}


class BodyLayout extends StatefulWidget {
  @override
  BodyLayoutState createState() {
    return new BodyLayoutState();
  }
}


class BodyLayoutState extends State<BodyLayout> {

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
    return Column(
      children: <Widget>[
      Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: Container(
          width: 300,
          height: 60,
          child: new Row(
                   children: <Widget>[
                     new Text("Player Name: Kohli"),
                     new IconButton(
      icon: new Icon(Icons.favorite_border),
      color: Colors.red,
      onPressed: () {
              // bid price will be incremented by 1 and bidder name is updated
              bidPriceIncreF(context, base_price);
                                                                    }
                  ),
                  new Text("$base_price by '$currentHighestBidder'"),
                                 ],
                               ),
                      ),
                    ),
                  ),
                      SizedBox(
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
                      RaisedButton(
                        child: Text('Insert item', style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          _insertSingleItem();
                        },
                      ),
                      RaisedButton(
                        child: Text('Remove item', style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          _removeSingleItem();
                        },
                      ),
                      RaisedButton(
                        child: Text('Rotator', style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          _bidItemRotator();
                        },
                      ),
                      Text("$_start"),
                      RaisedButton(
                        child: Text('Start Time', style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          startTimer();
                        },
                      ),
              
                    ],
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
              
                void _insertSingleItem() {
                  String newItem = "Planet";
                  // Arbitrary location for demonstration purposes
                  int insertIndex = _data.length;
                  // Add the item to the data list.
                  _data.insert(insertIndex, newItem);
                  // Add the item visually to the AnimatedList.
                  _listKey.currentState.insertItem(insertIndex);
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
              
                void _removeSingleItem() {

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

              //  this function takes care of updating below on fav icon click
              // * increment base_price of a player to db
              // * current highest bidder name in db
                void bidPriceIncreF(BuildContext context, int i) {
                 setState(() {
                    base_price = base_price + 1;
                    currentHighestBidder = currentBidder;
                 });

                }
              }
              
            