import 'package:flutter/material.dart';
//import 'package:validate/validate.dart';  //for validation



class AddFamily extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddFamilyMode();
  }
}

class MyData {
  String name = '';
  String phone = '';
  String email = '';
  String age = '';
}

class AddFamilyMode extends State<AddFamily> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        // theme: new ThemeData(
        //   primarySwatch: Colors.lightGreen,
        // ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Add Household Details'),
          ),
          body: new StepperBody(),
        ));
  }
}

class StepperBody extends StatefulWidget {
  int saveProgress = 0;
  @override
  _StepperBodyState createState() => new _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {

 
  int currStep = 0;
  static var _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static MyData data = new MyData();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
      // print('Has focus: $_focusNode.hasFocus');
    });

var crazyCheck =  Padding(
    padding: EdgeInsets.symmetric(vertical: 25.0),
    child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
            minWidth: 200.0,
            height: 300.0,
            onPressed: () {
                // getImage();
                print("pressed");
            },
            color: Colors.lightGreenAccent,
            child: new Icon(Icons.add_a_photo, size: 150.0,color: Colors.blue,
        ),
      ),
    ),
);
  }

   List<String> reportList = [
    "Ration",
    "old Age Pension",
    "Arogya Sri",
    "Akshara Bata",
    "BathRoom Built",
  ];

  List<String> selectedReportList = List();

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Current Benfits"),
            content: saveButtonAnime(reportList)
           ,
              
            actions: <Widget>[
              FlatButton(
                child: Text("SAVE"),
                onPressed: () =>
                {
                  setState(() {
                  widget.saveProgress = 1;
                  // saveButtonAnime1();
                   Navigator.of(context).pop();
                  //  saveButtonAnime1();
                })
               } 
              )
            ],
          );
        });
  }

  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   super.dispose();
  // }

Widget saveButtonAnime1() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Current Benfits"),
            content: saveButtonAnime(reportList)
           ,
              
            actions: <Widget>[
              FlatButton(
                child: Text("SAVE"),
                onPressed: () =>
                {
                  setState(() {
                  widget.saveProgress = 1;
                  // saveButtonAnime1();
                   Navigator.of(context).pop();
                  //  saveButtonAnime1();
                })
               } 
              )
            ],
          );
        });
  print("save button 1 state value is ${widget.saveProgress}");
 if (widget.saveProgress == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

Widget saveButtonAnime(reportList) {
  print("save button state value is ${widget.saveProgress}");
    if (widget.saveProgress == 0) {
      return new  MultiSelectChip(
              reportList,

              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
            );
    } else if (widget.saveProgress == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }


  List<Step> steps = [
    new Step(
        title: const Text('Holder Details'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: Column(
    children: <Widget>[
      TextFormField(
        decoration: InputDecoration(labelText: 'Name',
        icon: const Icon(Icons.person ),),
      ),
       new Row(
              children: <Widget>[
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Phone Number', icon: const Icon(Icons.phone),),
      ),
                            ),//flexible
                ),
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Aadhar Number', icon: const Icon(Icons.perm_identity),),
      ),
                            ),//flexible
                ),//container


              ],//widget
            ),
     new Row(
              children: <Widget>[
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Age', icon: const Icon(Icons.calendar_today),),
      ),
                            ),//flexible
                ),
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Sex', icon: const Icon(Icons.face),),
      ),
                            ),//flexible
                ),//container


              ],//widget
            ),
    ],
  )),
    new Step(
        title: const Text('Family Details'),
        //subtitle: const Text('Subtitle'),
        isActive: true,
        //state: StepState.editing,
        state: StepState.indexed,
        content: Column(
    children: <Widget>[
       new Row(
              children: <Widget>[
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Partner Name', icon: const Icon(Icons.person),),
      ),
                            ),//flexible
                ),
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Aadhar Number', icon: const Icon(Icons.perm_identity),),
      ),
                            ),//flexible
                ),//container


              ],//widget
            ),
     new Row(
              children: <Widget>[
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Age', icon: const Icon(Icons.calendar_today),),
      ),
                            ),//flexible
                ),
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Sex', icon: const Icon(Icons.tag_faces),),
      ),
                            ),//flexible
                ),//container


              ],//widget
            ),
       new Row(
              children: <Widget>[
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Child1 Name', icon: const Icon(Icons.face),),
      ),
                            ),//flexible
                ),
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Aadhar Number', icon: const Icon(Icons.perm_identity),),
      ),
                            ),//flexible
                ),//container


              ],//widget
            ),
     new Row(
              children: <Widget>[
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Age', icon: const Icon(Icons.calendar_today),),
      ),
                            ),//flexible
                ),
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Sex', icon: const Icon(Icons.tag_faces),),
      ),
                            ),//flexible
                ),//container


              ],//widget
            ), new Row(
              children: <Widget>[
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Child2 Name', icon: const Icon(Icons.face),),
      ),
                            ),//flexible
                ),
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Aadhar Number', icon: const Icon(Icons.perm_identity),),
      ),
                            ),//flexible
                ),//container


              ],//widget
            ),
     new Row(
              children: <Widget>[
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Age', icon: const Icon(Icons.calendar_today),),
      ),
                            ),//flexible
                ),
                new Container(
                  child:new Flexible(
                        child: new TextFormField(
        decoration: InputDecoration(labelText: 'Sex', icon: const Icon(Icons.tag_faces),),
      ),
                            ),//flexible
                ),//container


              ],//widget
            )
    ],
  )),
    new Step(
        title: const Text('Caste & Reservations'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        // state: StepState.disabled,
        content: Column(
    children: <Widget>[
      TextFormField(
        decoration: InputDecoration(labelText: 'Caste',
        icon: const Icon(Icons.linear_scale ),),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Handicap',
        icon: const Icon(Icons.local_hospital ),),
      ),
    ],
  )),
    new Step(
        title: const Text('Current Benfits'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        content: new TextFormField(
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          validator: (value) {
            if (value.isEmpty || !value.contains('@')) {
              return 'Please enter valid email';
            }
          },
          onSaved: (String value) {
            data.email = value;
          },
          maxLines: 1,
          decoration: new InputDecoration(
              labelText: 'Enter your email',
              hintText: 'Enter a email address',
              icon: const Icon(Icons.email),
              labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )
        ),
    // new Step(
    //     title: const Text('Fifth Step'),
    //     subtitle: const Text('Subtitle'),
    //     isActive: true,
    //     state: StepState.complete,
    //     content: const Text('Enjoy Step Fifth'))
  ];


  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: new Text(message)));
    }

    void _submitDetails() {
      final FormState formState = _formKey.currentState;

      if (!formState.validate()) {
        showSnackBarMessage('Please enter correct data');
      } else {
        formState.save();
        print("Name: ${data.name}");
        print("Phone: ${data.phone}");
        print("Email: ${data.email}");
        print("Age: ${data.age}");

        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Details"),
              //content: new Text("Hello World"),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text("Name : " + data.name),
                    new Text("Phone : " + data.phone),
                    new Text("Email : " + data.email),
                    new Text("Age : " + data.age),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      }
    }

    return new Container(
        child: new Form(
      key: _formKey,
      child: new ListView(children: <Widget>[
        new Stepper(
          steps: steps,
          type: StepperType.vertical,
          currentStep: this.currStep,
          onStepContinue: () {
            setState(() {
              if (currStep < steps.length - 1) {
                currStep = currStep + 1;
              } else {
                currStep = 0;
              }
              // else {
              // Scaffold
              //     .of(context)
              //     .showSnackBar(new SnackBar(content: new Text('$currStep')));

              // if (currStep == 1) {
              //   print('First Step');
              //   print('object' + FocusScope.of(context).toStringDeep());
              // }

              // }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currStep > 0) {
                currStep = currStep - 1;
              } else {
                currStep = 0;
              }
            });
          },
          onStepTapped: (step) {
            setState(() {
              currStep = step;
            });
          },
        ),
        new RaisedButton(
          child: new Text(
            'Save details',
            style: new TextStyle(color: Colors.white),
          ),
          // onPressed: _submitDetails,
          onPressed: () => _showReportDialog(),
          color: Colors.blue,
        ),
      ]),
    ));
  }
}

class MultiSelectChip extends StatefulWidget {
   List<String> reportList = [
    "Not relevant",
    "Illegal",
    "Spam",
    "Offensive",
    "Uncivil"
];
  // final List<String> reportList;
  final Function(List<String>) onSelectionChanged; // +added
  MultiSelectChip(
      this.reportList,
      {this.onSelectionChanged} // +added
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}
class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = List();
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item,  style: TextStyle(
            color: selectedChoices.contains(item) ? Colors.white : Colors.black)),
          selectedColor: Colors.blue,
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices); // +added
            });
          },
        ),
      ));
    });
    return choices;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}