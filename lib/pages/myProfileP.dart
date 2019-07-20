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

class MyProfilePage extends StatefulWidget {

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

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
  String collectionName1 = "Issues";

  bool isEditing = false;

  String dataSelect = "Houses";

  MatchesI curMatche;
  void initState() {
    dataSelect = "Houses"; 
    super.initState();
  }

  getMatches() {
    if(dataSelect == "Houses"){
    return Firestore.instance.collection(collectionName).snapshots();
    }else {
       return Firestore.instance.collection(collectionName1).snapshots();
    }
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
  return  dataSelect == "Issues" ?
     buildListItem(
            context,
            user.data['title'],
            200,
            1,
            Colors.grey.shade100,
            Color(0xFF716cff),
          ) : vaweCard (
            context,
            user.data['title'],
            "panta Street",
            1,
            Colors.grey.shade100,
            Color(0xFF716cff),
          );



          

  }
   Widget buildIssueTile(BuildContext contex, DocumentSnapshot user) {
    print("data is ${user.data}");
    return vaweCard(
            context,
            user.data['title'],
            "panta Street",
            1,
            Colors.grey.shade100,
            Colors.red,
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
          List snData = snapshot.data.documents;

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
            itemBuilder: (context, index) =>            buildUserTile(context,snapshot.data.documents[index] ),
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
            color:Colors.redAccent,
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
                            labelText: "సమస్య", hintText: "pension"),
                      ),
                      TextFormField(
                        controller: _prize,
                        decoration: InputDecoration(
                            labelText: "PersonId", hintText: "atk12345"),
                      ),
                      TextFormField(
                        controller: _fee,
                        decoration: InputDecoration(
                            labelText: "Description", hintText: "Reason about issue"),
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

      Widget memberbuildForm(BuildContext context) {
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
  void _showDialog(dilogCategory) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return dilogCategory == "Add Issues" ? AlertDialog(
          title: new Text("Create Issue",style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )),
          content:  buildForm(context),
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
        ) : AlertDialog(
          title: new Text(dilogCategory,style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        )),
          content: memberbuildForm(context),
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
            "My Volunteer Board",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
          Row(
            children: <Widget>[
              colorCard("Cash", 35.170, 1, context, Color(0xFF1b5bff)),
              // colorCard("Credit Debt", 4320, -1, context, Color(0xFFff3f5e)),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
                  margin: EdgeInsets.only(left: 0, bottom : 10),
                  height: screenAwareSize(
                      _media.longestSide <= 775 ? 110 : 80, context),
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) { 
                          return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: AddItemsButton(context, "Add Person"));
                        }
                        if (index == 1) { 
                          return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: AddItemsButton(context, "Add Issues"));
                        }
                        if (index == 2) { 
                          return Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: AddItemsButton(context, "Add Navatram"));
                        }

                        return Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: AddItemsButton(context, "Add Issues"),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, bottom: 15, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "All",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Issues",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Old Issues",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Corruption",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                buildBody(context),
                 Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: 0,
                        itemBuilder: (BuildContext context, int index) {
                          return vaweCard(
            context,
            "Ram Prasad",
            "panta Street",
            1,
            Colors.grey.shade100,
            Color(0xFF716cff),
          );
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: ListView.separated(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 85.0),
                            child: Divider(),
                          );
                        },
                        padding: EdgeInsets.zero,
                        itemCount: 0,
                        itemBuilder: (BuildContext context, int index) {
                          return vaweCard(
            context,
            "Ram Prasad",
            "panta Street",
            1,
            Colors.grey.shade100,
            Color(0xFF716cff),
          );
                        },
                      ),
                    ),
                  ],
                ),
      
       
         
        ],
      ),
    );
  }

  Widget vaweCard(BuildContext context, String name, String address, int type,
      Color fillColor, Color bgColor) {
    return Container(
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
                6,
              ),
              Text(
                "pic",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
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
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                address,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          
        ],
      ),
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
      String text, double amount, int type, BuildContext context, Color color) {
    final _media = MediaQuery.of(context).size;
    return Container(
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
                        Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            image: DecorationImage(
                              image: NetworkImage('http://t1.gstatic.com/images?q=tbn:ANd9GcR_XkfDWQpnP4FqejGDaDo4xBXo9dFzLJgrQH0-HWdyG9-mhiBDP_Gx311LYemlGyOUt15_1vk'),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Arjuna',
                            style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            )
                            ),
                            SizedBox(height: 5.0),
                            Text('Panta Street, Atmakur...',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white
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
                                          GestureDetector(
  onTap: () {
    print("issues is tapped");
    setState(() {
      dataSelect = "Houses"; 
    });
  },
  child: 
                                           new Container(
                                             height: 58.0,
                                        width: 100.0,
     color:dataSelect == "Houses" ? Colors.white :  Color(0xFF1b5bff),
    child:
                                          Column(
                                            children: <Widget>[
                                             SizedBox(height: 5.0),
                                              Text(
                                                '7',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                         color: dataSelect == "Houses" ?  Color(0xFF1b5bff): Colors.white),
                                              ),
                                              SizedBox(height: 7.0),
                                  Text(
                                                'Houses',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16.0,
                                                  color: dataSelect == "Houses" ?  Color(0xFF1b5bff): Colors.white
                                                ),
                                              ),
                                              SizedBox(height: 2.0),
                                              
                                              
                                            ],
                                          ),
                                           )
                                              ),
                                          SizedBox(width: 25.0),
                                              GestureDetector(
  onTap: () {
    print("issues is tapped");
    setState(() {
      dataSelect = "Issues"; 
    });
  },
  child: 
                                           new Container(
                                             height: 58.0,
                                        width: 100.0,
     color:dataSelect == "Issues" ? Colors.white : Color(0xFF1b5bff),
    child:
                                          Column(
                                            children: <Widget>[
                                             SizedBox(height: 5.0),
                                              Text(
                                                '2',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                        color: dataSelect == "Issues" ?  Color(0xFF1b5bff): Colors.white ),
                                              ),
                                              SizedBox(height: 7.0),
                                  Text(
                                                'Issues',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16.0,
                                                  color: dataSelect == "Issues" ?  Color(0xFF1b5bff): Colors.white
                                                ),
                                              ),
                                              SizedBox(height: 2.0),
                                              
                                              
                                            ],
                                          ),
                                           )
                                              ),
                                          SizedBox(width: 25.0),
                                          
                                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      SizedBox(height: 15.0),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 15.0,
                                          ),
                                          Text(
                                            '4.9',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14.0,
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20.0),
                                      Container(
                                        height: 30.0,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF2560FA),
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Center(
                                       child:   GestureDetector(
  onTap: () {
    Navigator.pushNamed(context, '/superviseDash');
  },
  child: Icon(Icons.send,
  color: Colors.white, size: 14.0),
),
                     
                                        ),
                                      )
                                    ],
                                  )
                                      ],
                                    ),
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
            color: Colors.lightBlue.shade50,
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
              color: Colors.blue,
            ),
            onPressed: () {
              print("add money");

               if( dispText == "Add Issues") {
                  Navigator.pushNamed(context, '/addIssue');
               }else if( dispText == "Add Person") {
                  Navigator.pushNamed(context, '/addFamily');
               }else {
                  Navigator.pushNamed(context, '/addScheme');
               }
  
              //  _showDialog(dispText);
             
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
