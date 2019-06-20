import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'overlay.dart';



class YSRMainScreen extends StatefulWidget {
  @override
  _YSRMainScreen createState() => _YSRMainScreen();
}

class _YSRMainScreen extends State<YSRMainScreen> {
  OverlaySheet overlaySheet = new OverlaySheet();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1b5bff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
       
              SizedBox(
            height: 60,
          ),
          Text(
            "My Volunteer Board",
            style: TextStyle(
              fontSize: 24,
              color:Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
          Container(
            color: Color(0xFF1b5bff),
            margin: EdgeInsets.only(top: 0),
            height: 520,
            child: Column(
              children: <Widget>[
                Expanded(
                    child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(9, (index) {
                    switch (index) {
                      case 0:
                        return Container(
                          margin: EdgeInsets.only(top: 0, left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new FlatButton(
                             child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.person_add,
                                  color: Color(0xFF1b5bff),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              onPressed: () {
                    Navigator.pushNamed(context, '/volunteerDash');
                  }),
             Text('Volunteer',  style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            )),
                  
                             
                            ],
                          ),
                        );
                        break;
                      case 1:
                        return Container(
                          margin: EdgeInsets.only(top: 0, left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new FlatButton(
                                child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.people,
                                  color: Color(0xFF1b5bff),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              onPressed: () {
                    Navigator.pushNamed(context, '/superviseDash');
                  }),
                              Text('Supervisor', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ))
                            ],
                          ),
                        );
                        break;
                      case 2:
                        return Container(
                          margin: EdgeInsets.only(top: 0, left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.star,
                                  color: Color(0xFF1b5bff),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              Text('Leader', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ))
                            ],
                          ),
                        );
                        break;
                      case 3:
                        return Container(
                          margin: EdgeInsets.only(top: 30, left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.cloud,
                                  color: Color(0xFF1b5bff),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              Text('Issues',style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ))
                            ],
                          ),
                        );
                        break;
                      case 4:
                        return Container(
                          margin: EdgeInsets.only(top: 30, left: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 60,
                                child: Icon(Icons.description,
                                    color: Color(0xFF1b5bff)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              Text('Documents', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ))
                            ],
                          ),
                        );
                        break;
                      case 5:
                        return Container(
                          margin: EdgeInsets.only(top: 30, left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.insert_chart,
                                  color: Color(0xFF1b5bff),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              Text('Stats',style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ))
                            ],
                          ),
                        );
                        break;
                      case 6:
                        return Container(
                          margin: EdgeInsets.only(top: 30, left: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.bubble_chart,
                                  color: Color(0xFF1b5bff),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              Text('Districts', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ))
                            ],
                          ),
                        );
                        break;
                      case 7:
                        return Container(
                          margin: EdgeInsets.only(top: 30, left: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.bug_report,
                                  color: Color(0xFF1b5bff),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              Text('Corruption', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ))
                            ],
                          ),
                        );
                        break;
                      case 8:
                        return Container(
                          margin: EdgeInsets.only(top: 30, left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  Icons.phone,
                                  color: Color(0xFF1b5bff),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              Text('Toll Frees', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ))
                            ],
                          ),
                        );
                        break;
                    }
                  }),
                ))
              ],
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

  void onTimer() {}
}