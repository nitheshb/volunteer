import 'package:flutter/material.dart';



class IssueDetails_p extends StatefulWidget {
  @override
  _IssueDetailsState createState() => _IssueDetailsState();
}

class _IssueDetailsState extends State<IssueDetails_p> {

  final double barsHeight = 40.0;
final double barsWidth = 3.0;
final Color inactiveBarColor = Colors.grey;
final Color activeBarColor = Colors.blue;

Map<String, bool> steps = {
  "Complaint Received by Volunteer": true,
  "Assigned to Grama Sachivalayam": true,
  "Response of Schivalayam": false,
  "Complaint Done": false,
};


Widget buildTracker(BuildContext context) {
  double rowPadding = (barsHeight - kRadialReactionRadius) / 2;
  double _barHeight = barsHeight;
  if (rowPadding < 0) {
    rowPadding = 0;
    _barHeight = kRadialReactionRadius;
  }
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    child: Stack(fit: StackFit.loose, children: <Widget>[

      Positioned(
        left: kRadialReactionRadius - barsWidth / 2,
        top: kRadialReactionRadius + rowPadding,
        bottom: kRadialReactionRadius + rowPadding,
        width: barsWidth,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: List.generate(steps.length - 1, (i) =>
          Container(
            margin: EdgeInsets.symmetric(vertical: kRadialReactionRadius / 2 - 2),
            height: _barHeight + 4,
            color: steps.values.elementAt(i) && steps.values.elementAt(i + 1) ? activeBarColor : inactiveBarColor,
          )
        ))
      ),
      Theme(
        data: Theme.of(context).copyWith(disabledColor: inactiveBarColor, unselectedWidgetColor: inactiveBarColor),
        child: Column(mainAxisSize: MainAxisSize.min, children: steps.keys.map((key) =>
          Padding(
            padding: EdgeInsets.symmetric(vertical: rowPadding),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Checkbox(
                value: steps[key],
                onChanged: steps[key] ? (_) {} : null,
                activeColor: activeBarColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Text(key,  style: TextStyle( color: key == "Assigned to Grama Sachivalayam" ? Colors.redAccent : Colors.black, fontSize: 20)),
            ])
          )
        ).toList())
      )

    ]),
  );
}

// esclations or close issue
Widget esclationClose() =>  Padding(
		    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[

			    	// First element
				    ListTile(
					    title: new DropdownButton<String>(
                 hint: new Text("Esclation...",
                          textAlign: TextAlign.center),
                           elevation: 2,
        style: TextStyle(color: Colors.purpleAccent, fontSize: 20),
        isDense: true,
        iconSize: 20.0,
                
  items: <String>['Esclate to Grama Sachivalayam', 'Esclate to Incharge', 'Esclate to MLA', 'Close Issue'].map((String value) {
    return new DropdownMenuItem<String>(
      value: value,
      
      child: new Text(value),
    );
  }).toList(),
  onChanged: (_) {},
),
				    ),
          ]
        )
);

				 

// old Issues body

 Widget bodyData() => DataTable(
      onSelectAll: (b) {},
      sortColumnIndex: 1,
      sortAscending: true,
      columns: <DataColumn>[
        DataColumn(
          label: Text("Rahim Old Issue's"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              names.sort((a, b) => a.firstName.compareTo(b.firstName));
            });
          },
          tooltip: "To display first name of the Name",
        ),
        DataColumn(
          label: Text("Completed On"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              names.sort((a, b) => a.lastName.compareTo(b.lastName));
            });
          },
          tooltip: "To display last name of the Name",
        ),
      ],
      rows: names
          .map(
            (name) => DataRow(
                  cells: [
                    DataCell(
                      Text(name.firstName),
                      showEditIcon: false,
                      placeholder: false,
                    ),
                    DataCell(
                      Text(name.lastName),
                      showEditIcon: false,
                      placeholder: false,
                    )
                  ],
                ),
          )
          .toList());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "Tracker",),
                Tab(text: "Action/ Esclation"),
                Tab(text: "old Issues"),
              ],
            ),
            title: Text('Issue Status'),
          ),
          body: TabBarView(
            children: [
              buildTracker(context),
              esclationClose(),
              bodyData(),
            ],
          ),
        ),
      ),
    );
  }
}

class Name {
  String firstName;
  String lastName;

  Name({this.firstName, this.lastName});
}

var names = <Name>[
  Name(firstName: "Pension Registration", lastName: "01-July-2018"),
  Name(firstName: "Badi Bata", lastName: "22-Jan-2019"),
  Name(firstName: "Ration not Reached", lastName: "16-Mar-2019"),
];