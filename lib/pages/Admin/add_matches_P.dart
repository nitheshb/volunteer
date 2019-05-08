import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../user.dart';

import 'package:test_app_1/Interfaces/matches_I.dart';


class AddMatchesP extends StatefulWidget {
  AddMatchesP() : super();

  final String title = "Add Matches";
  @override
  AddMatchesState createState() => AddMatchesState();
}

class AddMatchesState extends State<AddMatchesP> {
  //
  bool showTextField = false;
  TextEditingController controller = TextEditingController();
  TextEditingController _prize = TextEditingController();
  TextEditingController _positions = TextEditingController();
  TextEditingController _fee = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _status = TextEditingController();
  TextEditingController _matchId = TextEditingController();
  TextEditingController _teamId = TextEditingController();

  String collectionName = "Matches";
  bool isEditing = false;
  MatchesI curMatche;

  getMatches() {
    return Firestore.instance.collection(collectionName).snapshots();
  }

  addMatche() {
    MatchesI user = MatchesI(title: controller.text, prize: _prize.text, positions: _positions.text, fee: _fee.text, status: _status.text, matchId: _matchId.text);
    try {
      Firestore.instance.runTransaction(
        (Transaction transaction) async {
          await Firestore.instance
              .collection(collectionName)
              .document()
              .setData(user.toJson());
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  add() {
    if (isEditing) {
      // Update
      update(curMatche, controller.text);
      setState(() {
        isEditing = false;
      });
    } else {
      addMatche();
    }
    controller.text = '';
  }

  update(MatchesI user, String newName) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(user.reference, {'title': newName});
      });
    } catch (e) {
      print(e.toString());
    }
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
          title: Text(user.title),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // delete
              delete(user);
            },
          ),
          onTap: () {
            // update
            setUpdateUI(user);
          },
        ),
      ),
    );
  }

  setUpdateUI(MatchesI user) {
    controller.text = user.title;
    setState(() {
      showTextField = true;
      isEditing = true;
      curMatche = user;
    });
  }

  button() {
    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        child: Text(isEditing ? "UPDATE" : "ADD"),
        onPressed: () {
          add();
          setState(() {
            showTextField = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                showTextField = !showTextField;
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            showTextField
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                            labelText: "Title", hintText: "Enter title"),
                      ),
                      TextFormField(
                        controller: _prize,
                        decoration: InputDecoration(
                            labelText: "Prize", hintText: "Prize Amount"),
                      ),
                      TextFormField(
                        controller: _fee,
                        decoration: InputDecoration(
                            labelText: "fee", hintText: "Indiviual entry fee"),
                      ),
                       TextFormField(
                        controller: _date,
                        decoration: InputDecoration(
                            labelText: "Date", hintText: "Match Date"),
                      ),
                       TextFormField(
                        controller: _status,
                        decoration: InputDecoration(
                            labelText: "status", hintText: "ongoing/closed/open,waiting"),
                      ),
                       TextFormField(
                        controller: _matchId,
                        decoration: InputDecoration(
                            labelText: "MatchId", hintText: "usually this is auto generated"),
                      ),
                       TextFormField(
                        controller: _teamId,
                        decoration: InputDecoration(
                            labelText: "Team Id", hintText: "Select Team Id from other screens"),
                      ),
                       TextFormField(
                        controller: _positions,
                        decoration: InputDecoration(
                            labelText: "Positions", hintText: "postions 30/5/2"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      button(),
                    ],
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Matches",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: buildBody(context),
            ),
          ],
        ),
      ),
    );
  }
}