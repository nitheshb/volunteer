import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:test_app_1/Interfaces/matches_I.dart';

 Future addData2Fire(collectionName, data)  {
    // LiveBidI user = LiveBidI(bidId: "controller.text", maxPlayers: "_prize.text", positions: "_positions.text", fee: "_fee.text", status: "_status.text", matchId: "_matchId.text");
    
DocumentReference reference;

    // print("data check at addData2Firebase ${data.toJson()}");
    // try {
    //   Firestore.instance.runTransaction(
    //     (Transaction transaction) async {
    //       await reference = Firestore.instance
    //           .collection(collectionName)
    //           .document()
    //           .setData(data.toJson());
    //     },
    //   );
    // } catch (e) {
    //   print(e.toString());
    // }

 final collRef = Firestore.instance.collection(collectionName);
  DocumentReference docReferance = collRef.document();

 return docReferance.setData(data.toJson()).then((doc) {
    print('hop ${docReferance.documentID}');
    return docReferance.documentID;
    
  }).catchError((error) {
    print(error);
  });

  }

   