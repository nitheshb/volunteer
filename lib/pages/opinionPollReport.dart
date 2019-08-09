import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:test_app_1/Interfaces/matches_I.dart';
import 'package:test_app_1/utils/screen_size.dart';
import 'package:test_app_1/widgets/add_button.dart';
import 'package:test_app_1/widgets/donut_charts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:test_app_1/widgets/percent_indicator.dart';
import 'package:test_app_1/widgets/user_card.dart';
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

class OpinionPollDash extends StatefulWidget {

  @override
  _SupervisorDashState createState() => _SupervisorDashState();
}

class _SupervisorDashState extends State<OpinionPollDash> {
   bool showTextField = false;

  TextEditingController controller = TextEditingController();

  TextEditingController _prize = TextEditingController();

  TextEditingController _positions = TextEditingController();

  TextEditingController _fee = TextEditingController();

  TextEditingController _date = TextEditingController();

  TextEditingController _status = TextEditingController();

  TextEditingController _matchId = TextEditingController();

  TextEditingController _teamId = TextEditingController();

  String collectionName = "Volunteers";

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

  

  Widget buildUserTile(BuildContext contex, DocumentSnapshot user) {
    print("data is ${user.data}");
    return vaweCard(
            context,
            user.data['Name'],
            user.data['Address'],
            int.parse(user.data['Issues']),
            1,
            Colors.grey.shade100,
            Color(0xFFff596b),
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
        // return  ListTile(
        //     title: Text("fhdfkdfdfk"),
        //   );
          // Text("indis yao yo item");
          return ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
            buildUserTile(context,snapshot.data.documents[index] ),
          );
          // return buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    // return ListView(
    //   children: snapshot.map((data) => buildListItem(context, data)).toList(),
    // );
  }

   Widget buildListItem(BuildContext context, String name, double amount, int type,
      Color fillColor, Color bgColor) {
    // final user = MatchesI.fromSnapshot(data);
    return Padding(
      key: ValueKey(name),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(name),
          trailing: FlatButton(
            color:Colors.red[200],
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),

            ),
            child: Text("Action", style: TextStyle(color: Colors.white),),
          
          onPressed: () {
            print("inside caction");
             Navigator.pushNamed(context, '/issueDetails');

            // update
            // setUpdateUI(user);
          },
        )
        ),
      ),
    );
  }

    Widget buildForm(BuildContext context) {
     return   Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                            labelText: "Name", hintText: "Name"),
                      ),
                      TextFormField(
                        controller: _prize,
                        decoration: InputDecoration(
                            labelText: "PersonId", hintText: "Id"),
                      ),
                      TextFormField(
                        controller: _fee,
                        decoration: InputDecoration(
                            labelText: "Place", hintText: "address"),
                      ),
                       TextFormField(
                        controller: _date,
                        decoration: InputDecoration(
                            labelText: "Date", hintText: "Match Date"),
                      ),
                       TextFormField(
                        controller: _status,
                        decoration: InputDecoration(
                            labelText: "Status", hintText: "ongoing/closed/open,waiting"),
                      ),
                      // button(),
                    ],
                  );
    }
// user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Create New volunteer",style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )),
          content: buildForm(context),
          actions: <Widget>[

            
            // usually buttons at the bottom of the dialog
            Row(
              children: <Widget>[

                
                new FlatButton(
                  child: new Text("Save"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
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
    final _media = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 20,
          top: 70,
        ),
        children: <Widget>[
          SizedBox(
            height: 0,
          ),
          Text(
            "Nellore District Opinion Pools",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
          Row(
            children: <Widget>[
              colorCard("Ration: Old Rice vs New Rice","", 35.170, 1, context, Colors.greenAccent),
              
              // colorCard("Credit Debt", 4320, -1, context, Color(0xFFff3f5e)),
            ],
          ),
          Row(
            children: <Widget>[
              colorCard("How is the quality of newly introduced rice","", 35.170, 1, context, Colors.greenAccent),
              
              // colorCard("Credit Debt", 4320, -1, context, Color(0xFFff3f5e)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
           Row(
            children: <Widget>[
              colorCard("Will you send kid to government School,", "if van is arranged ?",35.170, 1, context, Colors.greenAccent),
              
              // colorCard("Credit Debt", 4320, -1, context, Color(0xFFff3f5e)),
            ],
          ),
  
                
           SizedBox(height: 20.0,),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Detail Stats of Rice Taste",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Varela",
                  ),
                ),
                TextSpan(
                  text: "    July 2018",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontFamily: "Varela",
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 15,
              right: 20,
            ),
            height:
                screenAwareSize(_media.longestSide <= 775 ? 180 : 130, context),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 180,
                  width: 160,
                  child: DonutPieChart(
                    series,
                    animate: true,
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      donutCard(Colors.indigo, "Women"),
                      donutCard(Colors.yellow, "Men"),
                      donutCard(Colors.greenAccent, "Old age"),
                      donutCard(Colors.pinkAccent, "Children"),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Budgets",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Varela",
                  ),
                ),
                TextSpan(
                  text: "    July",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontFamily: "Varela",
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 15,
              right: 20,
            ),
            padding: EdgeInsets.all(10),
            height: screenAwareSize(45, context),
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
            child: LinearPercentIndicator(
              width: screenAwareSize(
                  _media.width - (_media.longestSide <= 775 ? 100 : 160),
                  context),
              lineHeight: 20.0,
              percent: 0.68,
              backgroundColor: Colors.grey.shade300,
              progressColor: Color(0xFF1b52ff),
              animation: true,
              animateFromLastPercent: true,
              alignment: MainAxisAlignment.spaceEvenly,
              animationDuration: 1000,
              linearStrokeCap: LinearStrokeCap.roundAll,
              center: Text(
                "68.0%",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
         
        
        ],
      ),
    );
  }

  Widget vaweCard(BuildContext context, String name, String address, int amount, int type,
      Color fillColor, Color bgColor1) {

        var bgColor = amount == 0 ?  Colors.greenAccent : Color(0xFFff596b) ;
    return GestureDetector(
  onTap: () {
    Navigator.pushNamed(context, '/volunteerStats');
  },
  child:  Container(
      margin: EdgeInsets.only(
        top: 5,
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
                0,
              ),
              Text(
                amount.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )
               
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
                name,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "${address.toString()}",
                 style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    )
    );
  }

  Widget donutCard(Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 0,
            top: 18,
            right: 10,
          ),
          height: 15,
          width: 15,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            inherit: true,
          ),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        )
      ],
    );
  }

  Widget colorCard(
      String text, String text2, double amount, int type, BuildContext context, Color color) {
    final _media = MediaQuery.of(context).size;
    return new GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, '/PollsCollector');
          print("Container clicked");
        },
    child: Container(
      margin: EdgeInsets.only(top: 15, right: 15),
      padding: EdgeInsets.all(15),
      height: 180,
      width: _media.width - 40,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 16,
                spreadRadius: 0.2,
                offset: Offset(0, 8)),
          ]),
      child:Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 15.0),
                                      Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child:Row(
                      children: <Widget>[
                       
                        SizedBox(width: 5.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(text, 
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            )
                            ),
                            SizedBox(height: 5.0),
                            Text(text2,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            )
                            )
                          ],
                        )
                      ],
                    )
                  ),
                ],
              ),
                                      SizedBox(height: 15.0),
                                      Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                '13.5 lakh',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.blueAccent),
                                              ),
                                              SizedBox(height: 7.0),
                                              Text(
                                                'Yes',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16.0,
                                                  color: Colors.white
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 25.0),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                '50k',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.yellowAccent),
                                              ),
                                              SizedBox(height: 7.0),
                                              Text(
                                                'No',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16.0,
                                                  color: Colors.white
                                                ),
                                              )
                                            ],
                                          ),
                                           SizedBox(width: 25.0),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                '10k',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.pink[300]),
                                              ),
                                              SizedBox(height: 7.0),
                                              Text(
                                                'Women',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16.0,
                                                  color: Colors.white
                                                ),
                                              )
                                            ],
                                          )
                                        
                                        ],
                                      )
                                    ],
                                  ),
                                
                                      ],
     
                                    ),
    )
    );
  }

  Widget AddItemsButton(BuildContext context, String dispText) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      alignment: Alignment.center,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade50,
            blurRadius: 8.0,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.pinkAccent,
            ),
            onPressed: () {
              print("add money");
              // Navigator.pushNamed(context,'/razorPay_home');
              
    // Navigator.pushNamed(context, '/dashboardYsr');
  
              _showDialog();
              // Navigator.pushNamed(context,'/scratchCard');
            },
            iconSize: 40.0,
          ),
          Text(
            dispText,
            style: TextStyle(
                inherit: true,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.black45),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
