import 'package:flutter/material.dart';
import 'package:test_app_1/models/state.dart';
import 'package:test_app_1/util/state_widget.dart';
import 'package:test_app_1/ui/screens/sign_in.dart';
import 'package:test_app_1/ui/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app_1/Interfaces/matches_I.dart';
import 'package:test_app_1/pages/fan_player_select_P.dart';
import 'package:test_app_1/pages/bid_player_select_p.dart';
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
    return Padding(
      key: ValueKey(user.title),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // move to other screen
              _send2BidScreen(context);
                          },

          ),
          title: Text(user.title),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // move to other screen
              _send2FanSelectScreen(context, user);
                          },
                        ),
                        onTap: () {
                          // update
                          print("its seleted");
                        },
                      ),
                    ),
                  );
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
                                      onPressed: () {},
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
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BidPlayerSelectP(text: textToSend,),
        ));
  }
