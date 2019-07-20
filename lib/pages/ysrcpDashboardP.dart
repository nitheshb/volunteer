import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:test_app_1/utils/screen_size.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'overlay.dart';

var menuData = [
{'name': 'Volunteer', 'routeString': '/volunteerDash'},
{'name': 'Supervisor', 'routeString': '/superviseDash'},
{'name': 'Leader', 'routeString': '/leaderView'},
{'name': 'Live Stastics', 'routeString': '/liveStatsHome'},
{'name': 'Opinion Polls', 'routeString': '/opinionPool'},
{'name': 'Issues', 'routeString': '/volunteerDash'},
{'name': 'Aspriants', 'routeString': '/volunteerDash'},
{'name': 'Corruption', 'routeString': '/superviseDash'},
{'name': 'Toll Free', 'routeString': '/smartMenu'},
];

class YSRMainScreen extends StatefulWidget {
  @override
  _YSRMainScreen createState() => _YSRMainScreen();
}

class _YSRMainScreen extends State<YSRMainScreen> {
  OverlaySheet overlaySheet = new OverlaySheet();
int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

 Widget _buildBottomCard(double width, double height){
    return Container(
      width: width,
      height: 70,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        // color: Color(0XFFFA280F),
        gradient: LinearGradient(
          colors: [const Color(0xFF667eea  ),const Color(0xFF764ba2) ]
        ),
        // color: Color(0xFF1b5bff),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16)
        )
      ),
      child: _buildBottomCardChildren(),
    );
  }

   Widget _buildBottomCardChildren(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
    
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // _buildButton(Icons.radio_button_checked),
            // _buildButton(Icons.home),
            // _buildButton(Icons.settings),
          ],
        )
      ],
    );
  }
    Text _buildText(String title){
    return Text(title,
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold
    ),
    );
  }
  
  IconButton _buildButton(IconData icon){
    return IconButton(
      onPressed: (){},
      icon: Icon(icon, color: Colors.white,),
    );
  }
  Widget AddItemsButton(BuildContext context, String dispText,  String routeUrl) {
    // print('---> data inside iconMaker')
      return Container(
       margin: EdgeInsets.only(right:10.0),
        child:Material
                    (
                      //  elevation: 14.0,
                      // borderRadius: BorderRadius.circular(12.0),
                      // shadowColor: Color(0x802196F3),
                      // color: Colors.white,
                    
    child: Container(
      // margin: EdgeInsets.only(right: 10.0),
      width: 100.0,
      height: 120.0,
      alignment: Alignment.center,
      padding: EdgeInsets.all(12.0),
       decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF667eea  ),const Color(0xFF764ba2) ]
        ),

        // color:Color(0xFF1b5bff),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1
          )
        ]
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
                fontSize: 15.0,
                color: Colors.white),
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
     final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Color(0xFF1b5bff),
      bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.add, size: 30),
            Icon(Icons.list, size: 30),
            Icon(Icons.compare_arrows, size: 30),
            Icon(Icons.call_split, size: 30),
            Icon(Icons.perm_identity, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
      body: 
      Container(
        margin: EdgeInsets.only(top: 16),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
                child: _buildBottomCard(width, height)
            ),
      Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
        children: <Widget>[
       
              SizedBox(
            height: 55,
          ),
       
        GradientText(
  "POCKET DIARY",
  shaderRect: Rect.fromLTWH(0.0, 0.0, 50.0, 50.0),
   gradient: LinearGradient(
          colors: [const Color(0xFF667eea  ),const Color(0xFF764ba2) ]
        ),
  style: TextStyle(fontSize: 40.0,),
),
        
            SizedBox(
            height: 10,
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
          ]
        )
        )
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
              color: Colors.white,
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
              color: Colors.white,
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
              color: Colors.white,
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
              color: Colors.white,
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
              color: Colors.white,
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
              color: Colors.white,
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
              color: Colors.white,
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
              color: Colors.white,
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
              color: Colors.white,
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
              color: Colors.white,
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