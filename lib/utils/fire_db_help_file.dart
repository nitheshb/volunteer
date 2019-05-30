import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:test_app_1/Interfaces/matches_I.dart';


//  CREATE
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



// UPDATE 
// Total updates: 3
// s.no: u1
 Future findUpdateData2Fire(collectionName, data)  {
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

// s.no: u2
// insert to array of objects(maps)

Future insertArrayFire(collectionName, objectId,data ){


 List biddersPool = [data];
   final collRef = Firestore.instance.collection(collectionName);
  DocumentReference docRef = collRef.document();

  //  if (uid) {
  //     const ref = this.afs.collection('chats').doc(chatId);
  //     return ref.update({
  //       messages: firestore.FieldValue.arrayUnion(data)
  //     });

final DocumentReference docRef1 =
    Firestore.instance.document("$collectionName/$objectId");
docRef1.get().then((ghostExists) => {
        if(ghostExists.exists) {

          // do something
            docRef1.updateData({ 'bidders' : FieldValue.arrayUnion([data])}).then((value){
      return docRef1.documentID;
    }).catchError((error){
      print("@@ got error at ghost entry updater $error");
    })
        }else{
          //  create an new objectId
        

         Firestore.instance
              .collection(collectionName)
              .document(objectId).setData({"bidders": biddersPool})
              // .setData(biddersPool);

        }
      });
}

// s.no: u2
// update current bid Price with value pressed by user

Future updateBidPriceFire(collectionName, objectId,dataPrice, bidBy ){

print("names --> $collectionName $objectId");
  String biddersPrice = dataPrice;
   DocumentReference docRef = Firestore.instance.document("$collectionName/$objectId");
  //  DocumentReference docRef = collRef.document();

Map obj = {"bidVal": biddersPrice, "bidBy": bidBy };
  // update current bid Price
     docRef.updateData({"currentBidState": obj}).then((value){
      return docRef.documentID;
    }).catchError((error){
      print("@@ got error at updating bidPrice $error");
    });
}

// DELETE
// d1,

// s.no: d1
// delete Bidder from this turn when he pressed the pass/ skip button

Future passMeDeleteBidderFire(collectionName, objectId, skipperObj ){

print("skip me --> $collectionName $skipperObj");

final DocumentReference docRef1 = Firestore.instance.document("$collectionName/$objectId");
docRef1.get().then((ghostExists) => {


          // do something
            docRef1.updateData({ 'activeBidders' : FieldValue.arrayRemove([skipperObj])}).then((value){
              print("check for update delete array is ${docRef1.documentID}");
      return docRef1.documentID;
    }).catchError((error){
      print("@@ got error at skipping the users obj from activeBidders $error");
    })
        
});

//    DocumentReference docRef = Firestore.instance.document("$collectionName/$objectId");
//   //  DocumentReference docRef = collRef.document();

// Map obj = {"bidVal": biddersPrice, "bidBy": bidBy };
//   // update current bid Price
//      docRef.updateData({"currentBidState": obj}).then((value){
//       return docRef.documentID;
//     }).catchError((error){
//       print("@@ got error at updating bidPrice $error");
//     });
}



   