// TODO Implement this library.
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesI {
  String title,prize, positions,fee,status,matchId, bidType;
  List team;

  DocumentReference reference;

  MatchesI({this.title,this.prize,this.positions,this.fee,this.status,this.matchId, this.team, this.bidType});

  MatchesI.fromMap(Map<String, dynamic> map, {this.reference}) {
    title = map["title"];
    bidType = map["bid_type"];
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
    return {'title': title,'prize': prize, 'positions': positions, 'fee': fee, 'status': status, 'matchId': matchId, 'bid_type': bidType };
  }
}



class LiveBidI {
  String bidId, positions,status,matchId, bidType;
  List team;
  List bidderDetails;

  // this is supposted to be changed as list type
  Map bidders;
  int maxPlayers;

  DocumentReference reference;

  LiveBidI({this.bidId,this.maxPlayers,this.positions,this.matchId, this.team, this.bidType, this.bidders, this.bidderDetails});

  LiveBidI.fromMap(Map<String, dynamic> map, {this.reference}) {
    bidId = map["bidId"];
    maxPlayers = map["maxPlayers"];
    positions = map["positions"];
    matchId = map["matchId"];
    team = map["team"];
    bidType = map["bid_type"];
    bidders = map["bidders"];
    bidderDetails = map["bidderDetails"];
  }

  LiveBidI.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  toJson() {
    return {'bidId': bidId,'maxPlayers': maxPlayers, 'positions': positions,'matchId': matchId, 'bid_type': bidType, 'team': team, 'bidders': bidders, "bidderDetails": bidderDetails };
  }
}