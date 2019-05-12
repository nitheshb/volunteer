import 'package:flutter/material.dart';
import 'package:test_app_1/models/state.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:test_app_1/util/state_widget.dart';
import 'package:test_app_1/ui/screens/sign_in.dart';
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

class FixturesScreen extends StatefulWidget {
  _FixturesScreenState createState() => _FixturesScreenState();
}

class _FixturesScreenState extends State<FixturesScreen> {
  StateModel appState;
  bool _loadingVisible = false;
  String collectionName = "Matches";
  @override
  void initState() {
    super.initState();
  }
   getMatches() {
    return Firestore.instance.collection(collectionName).snapshots();
  }
  delete(MatchesI user) {
    Firestore.instance.runTransaction(
      (Transaction transaction) async {
        await transaction.delete(user.reference);
      },
    );
  }

   Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getMatches(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          print("Documents ${snapshot.data.documents.length}");
          return buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final user = MatchesI.fromSnapshot(data);
    // return Column(
    //  children: <Widget>[
    //    vaweCard(context ,data, Colors.grey.shade100, Color(0xFF716cff))
    //  ],
    // );

    return Container(
      child: Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(context,user),
      ),
    )
    );
    // return Container(
    //   child: Padding(
    //   key: ValueKey(user.title),
    //   padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
    //   child: Container(
    //     decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(6),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.grey.shade100,
    //         blurRadius: 6,
    //         spreadRadius: 10,
    //       )
    //     ],
    //   ),
    //     child: ListTile(
    //       leading: IconButton(
    //         icon: Icon(Icons.arrow_back),
    //         onPressed: () {
    //           // move to other screen
    //           _send2BidScreen(context);
    //                       },

    //       ),
    //       title: Stack( 
    //         alignment: Alignment.center,
    //         children:<Widget>[
    //         Text(user.title)
    //       ]
    //         ),
    //       trailing: IconButton(
    //         icon: Icon(Icons.arrow_forward),
    //         onPressed: () {
    //           // move to other screen
    //           _send2FanSelectScreen(context, user);
    //                       },
    //                     ),
    //                     onTap: () {
    //                       // update
    //                       print("its seleted");
    //                     },
    //                   ),
    //                 ),
    //   )
    //               );
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
                    final logo = Hero(
                      tag: 'hero',
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 60.0,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/default.png',
                              fit: BoxFit.cover,
                              width: 120.0,
                              height: 120.0,
                            ),
                          )),
                    );
              
                    final signOutButton = Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        onPressed: () {
                          StateWidget.of(context).logOutUser();
                        },
                        padding: EdgeInsets.all(12),
                        color: Theme.of(context).primaryColor,
                        child: Text('SIGN OUT', style: TextStyle(color: Colors.white)),
                      ),
                    );

                    
   
                    final forgotLabel = FlatButton(
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                    );
              
                    final signUpLabel = FlatButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                    );
              
                    final signInLabel = FlatButton(
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                    );
                    
                    final CrudPage = FlatButton(
                      child: Text(
                        'CRUD PAGE',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_matches');
                      },
                    );
              
                    final topAppBar = AppBar(
                    elevation: 0.1,
                    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                    title: Text("Matches(H)"),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () {
                          StateWidget.of(context).logOutUser();
                        },
                                )
                              ],
                            );
              
                    
                            
                        final makeBottom = Container(
                              height: 55.0,
                              child: BottomAppBar(
                                color: Color.fromRGBO(58, 66, 86, 1.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.home, color: Colors.white),
                                      onPressed: () { 
                                        Navigator.pushNamed(context, '/wallet_home');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.blur_on, color: Colors.white),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.flash_on, color: Colors.white),
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/add_matches');
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.account_box, color: Colors.white),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                              ),
                            );
              //check for null https://stackoverflow.com/questions/49775261/check-null-in-ternary-operation
                    // final userId = appState?.firebaseUserAuth?.uid ?? '';
                    // final email = appState?.firebaseUserAuth?.email ?? '';
                    // final firstName = appState?.user?.firstName ?? '';
                    // final lastName = appState?.user?.lastName ?? '';
                    // final settingsId = appState?.settings?.settingsId ?? '';
                    // final userIdLabel = Text('App Id: ');
                    // final emailLabel = Text('Email: ');
                    // final firstNameLabel = Text('First Name: ');
                    // final lastNameLabel = Text('Last Name: ');
                    // final settingsIdLabel = Text('SetttingsId: ');
              
                    // final makeBody = LoadingScreen(
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    //         child: Center(
                    //           child: SingleChildScrollView(
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment: CrossAxisAlignment.stretch,
                    //               children: <Widget>[
                    //                 logo,
                    //                 SizedBox(height: 48.0),
                    //                 userIdLabel,
                    //                 Text(userId,
                    //                     style: TextStyle(fontWeight: FontWeight.bold)),
                    //                 SizedBox(height: 12.0),
                    //                 emailLabel,
                    //                 Text(email,
                    //                     style: TextStyle(fontWeight: FontWeight.bold)),
                    //                 SizedBox(height: 12.0),
                    //                 firstNameLabel,
                    //                 Text(firstName,
                    //                     style: TextStyle(fontWeight: FontWeight.bold)),
                    //                 SizedBox(height: 12.0),
                    //                 lastNameLabel,
                    //                 Text(lastName,
                    //                     style: TextStyle(fontWeight: FontWeight.bold)),
                    //                 SizedBox(height: 12.0),
                    //                 settingsIdLabel,
                    //                 Text(settingsId,
                    //                     style: TextStyle(fontWeight: FontWeight.bold)),
                    //                 SizedBox(height: 12.0),
                    //                 signOutButton,
                    //                 signInLabel,
                    //                 signUpLabel,
                    //                 forgotLabel,
                    //                 CrudPage,
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       inAsyncCall: _loadingVisible),
                    // );
              
                    return Scaffold(
                      backgroundColor: Colors.white,
                      appBar: topAppBar,
                      body: buildBody(context),
                      bottomNavigationBar: makeBottom,
                    );
                  }
                }




    Widget makeListTile(BuildContext context, data) {
      return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // move to other screen
              _send2BidScreen(context);
                          }
          ),
        ),
       

        title: Row( 
          children: <Widget> [
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Text(
          data.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
         Row(
          children: <Widget>[
            Icon(Icons.linear_scale, color: Colors.yellowAccent),
            Text(" Intermediate", style: TextStyle(color: Colors.white))
          ]
        )
            ]

          )
        ]),
        trailing: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // move to other screen
              _send2FanSelectScreen(context, data);
                          }
          ),
            );}

   


  Widget vaweCard(BuildContext context, data,
      Color fillColor, Color bgColor) {
    return Container(
      margin: EdgeInsets.only(
        top: 15,
        right: 20,
      ),
      padding: EdgeInsets.only(left: 15),
      height: screenAwareSize(80, context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            spreadRadius: 10,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              WaveProgress(
                screenAwareSize(45, context),
                fillColor,
                bgColor,
                67,
              ),
              Text(
                "80%",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "KKR vs SRH",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "4,999",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ],
      ),
    );
  }  
                
              }
              
        // get the text in the TextField and start the Second Screen
  void _send2FanSelectScreen(BuildContext context, user) {
    String textToSend = user.title;
    print("check");
    print(user.team);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(text: textToSend, team: user.team),
        ));
  }

  void _send2BidScreen(BuildContext context) {
    String textToSend = "sample text passed";
    Navigator.pushNamed(context, "/auctionHome");
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => BidPlayerSelectP(text: textToSend,),
    //     ));
  }
