// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesI {
  String title,prize, positions,fee,status,matchId;
  List team;

  DocumentReference reference;

  MatchesI({this.title,this.prize,this.positions,this.fee,this.status,this.matchId, this.team});

  MatchesI.fromMap(Map<String, dynamic> map, {this.reference}) {
    title = map["title"];
    prize = map["prize"];
    positions = map["positions"];
    fee = map["fee"];
    status = map["status"];
    matchId = map["matchId"];
    team = map["team"];
  }

  MatchesI.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {'title': title,'prize': prize, 'positions': positions, 'fee': fee, 'status': status, 'matchId': matchId };
  }
}