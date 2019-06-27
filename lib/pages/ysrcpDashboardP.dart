import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:test_app_1/utils/screen_size.dart';
import 'overlay.dart';

var menuData = [
{'name': 'Volunteer', 'routeString': '/volunteerDash'},
{'name': 'Supervisor', 'routeString': '/superviseDash'},
{'name': 'Leader', 'routeString': '/volunteerDash'},
{'name': 'Live Stastics', 'routeString': '/liveStatsHome'},
{'name': 'Opinion Polls', 'routeString': '/opinionPool'},
{'name': 'Issues iSSUES iSS', 'routeString': '/volunteerDash'},
{'name': 'Aspriants', 'routeString': '/volunteerDash'},
{'name': 'Corruption', 'routeString': '/superviseDash'},
{'name': 'Toll Free', 'routeString': '/volunteerDash'},
];

class YSRMainScreen extends StatefulWidget {
  @override
  _YSRMainScreen createState() => _YSRMainScreen();
}

class _YSRMainScreen extends State<YSRMainScreen> {
  OverlaySheet overlaySheet = new OverlaySheet();

  
  Widget AddItemsButton(BuildContext context, String dispText,  String routeUrl) {
    // print('---> data inside iconMaker')
      return Container(
       margin: EdgeInsets.only(right:10.0),
        child:Material
                    (
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(12.0),
                      shadowColor: Color(0x802196F3),
                      color: Colors.white,
                    
    child: Container(
      // margin: EdgeInsets.only(right: 10.0),
      width: 100.0,
      height: 120.0,
      alignment: Alignment.center,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
         iconMaker(context,dispText, routeUrl),
          Text(
            dispText,
            style: TextStyle(
                inherit: true,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
                    )
                    );
  }
  @override
  Widget build(BuildContext context) {
     final _media = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Color(0xFF1b5bff),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
        children: <Widget>[
       
              SizedBox(
            height: 100,
          ),
          Text(
            "My Volunteer Board",
            style: TextStyle(
              fontSize: 24,
              // color:Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
            SizedBox(
            height: 20,
          ),
             Container(
                  margin: EdgeInsets.only(left: 15, bottom : 0),
                  height: 500,
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        print('########data is ${menuData[index]['name']}');
                        var dataPart = menuData[index];
                        return Padding(
                          padding: EdgeInsets.only(top: 0),
                          
                          child: Column(
                            
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom:15.0),
                             child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                     mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  AddItemsButton(context, dataPart['name'], dataPart['routeString']),
                                   AddItemsButton(context, menuData[1]['name'], menuData[1]['routeString']),
                                   AddItemsButton(context, menuData[2]['name'], menuData[2]['routeString']),
                                ],
                              ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom:15.0),
                               child:Row(
                                     mainAxisSize: MainAxisSize.max,
                                     mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  AddItemsButton(context, menuData[3]['name'], menuData[3]['routeString']),
                                   AddItemsButton(context, menuData[4]['name'], menuData[4]['routeString']),
                                   AddItemsButton(context, menuData[5]['name'], menuData[5]['routeString']),
                                ],
                              ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom:15.0),
                               child: Row(
                                     mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  AddItemsButton(context, menuData[6]['name'], menuData[6]['routeString']),
                                   AddItemsButton(context, menuData[7]['name'], menuData[7]['routeString']),
                                   AddItemsButton(context, menuData[8]['name'], menuData[8]['routeString']),
                                ],
                              ),
                              )
                            ],
                            
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void onSearch() {
    Fluttertoast.showToast(
        msg: "Search Button !",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        textColor: Color(0xfffdd329));
  }

  void onOptions() {
    Fluttertoast.showToast(
        msg: "Option Button !",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        textColor: Color(0xfffdd329));
  }

  void onSettings() {
    Fluttertoast.showToast(
        msg: "Settings Button !",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        textColor: Color(0xfffdd329));
  }

  Widget iconMaker(context, checkText, routeUrl) {

    if (checkText == 'Volunteer'){
    return    IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");

                  Navigator.pushNamed(context, routeUrl);  
              //  _showDialog(dispText);
             
            },
            iconSize: 40.0,
          );
    }
    else if (checkText == 'Supervisor'){
    return    IconButton(
            icon: Icon(
              Icons.person_add,
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");
                  Navigator.pushNamed(context, routeUrl);
              //  _showDialog(dispText);
            },
            iconSize: 40.0,
          );
    }
    else if (checkText == 'Leader'){
    return    IconButton(
            icon: Icon(
              Icons.star,
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");
                  Navigator.pushNamed(context, routeUrl);
              //  _showDialog(dispText);
            },
            iconSize: 40.0,
          );
    }
    else if (checkText == 'Live Stastics'){
      print('inside ----------------> Live Stastics $routeUrl');
    return    IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");
                  Navigator.pushNamed(context, routeUrl);
              //  _showDialog(dispText);
            },
            iconSize: 40.0,
          );
    }
    else if (checkText == 'Opinion Polls'){
    return    IconButton(
            icon: Icon(
              Icons.insert_chart,
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");
                  Navigator.pushNamed(context, routeUrl);
              //  _showDialog(dispText);
            },
            iconSize: 40.0,
          );
    }
    else if (checkText == 'Issues'){
    return    IconButton(
            icon: Icon(
              Icons.cloud,
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");
                  Navigator.pushNamed(context, routeUrl);
              //  _showDialog(dispText);
            },
            iconSize: 40.0,
          );
    }
    else if (checkText == 'Aspriants'){
    return    IconButton(
            icon: Icon(
              Icons.people,
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");
                  Navigator.pushNamed(context, routeUrl);
              //  _showDialog(dispText);
            },
            iconSize: 40.0,
          );
    }
    else if (checkText == 'Corruption'){
    return    IconButton(
            icon: Icon(
              Icons.bug_report,
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");
                  Navigator.pushNamed(context, routeUrl);
              //  _showDialog(dispText);
            },
            iconSize: 40.0,
          );
    }
    else if (checkText == 'Toll Free'){
    return    IconButton(
            icon: Icon(
              Icons.phone,
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");
                  Navigator.pushNamed(context, routeUrl);
              //  _showDialog(dispText);
            },
            iconSize: 40.0,
          );
    }
    else{
        return    IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");

              
                  Navigator.pushNamed(context, routeUrl);
    
  
              //  _showDialog(dispText);
             
            },
            iconSize: 40.0,
          );
    }
  }

  void onTimer() {}
}