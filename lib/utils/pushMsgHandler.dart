import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState1 createState() => _MessageHandlerState1();
}

class _MessageHandlerState1 extends State<MessageHandler> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

    // TODO...

    @override
    void initState() {

        // ...

        _fcm.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        content: ListTile(
                        title: Text(message['notification']['title']),
                        subtitle: Text(message['notification']['body']),
                        ),
                        actions: <Widget>[
                        FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
                ),
            );
        },
        onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
            // TODO optional
        },
        onResume: (Map<String, dynamic> message) async {
            print("onResume: $message");
            // TODO optional
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[300],
      
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.notifications,
                color: Colors.blueGrey,
            ),
          )
        ],
      ),
      body: Container(
        child:Column(
      children: <Widget>[
        RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.all(13.0),
                        elevation: 2.0,
                        textColor: Colors.white,
                        color: Colors.amber,
                        //  onPressed: () => Save(),
                        onPressed: () => _saveDeviceToken(),
                        child: Text(
                       "Save Token",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                         RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.all(13.0),
                        elevation: 2.0,
                        textColor: Colors.white,
                        color: Colors.amber,
                        //  onPressed: () => Save(),
                   
                        onPressed: () => _fcm.subscribeToTopic('puppies'),
                        child: Text(
                       "I like puppies",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                         RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.all(13.0),
                        elevation: 2.0,
                        textColor: Colors.white,
                        color: Colors.amber,
                        //  onPressed: () => Save(),
                        
                        onPressed: () => _fcm.unsubscribeFromTopic('puppies'),
                        child: Text(
                       "I hate puppies",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                      ),
      
      ],
    ) ,
      )
    );
    
   
  }


 /// Get the token, save it to the database for current user
  _saveDeviceToken() async {

    print('token save is pressed');
    // Get the current user
    String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users1')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': 'Android' // optional
      });
    }
  }
  
}