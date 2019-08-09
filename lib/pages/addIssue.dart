import 'package:flutter/material.dart';
//import 'package:validate/validate.dart';  //for validation
import 'package:test_app_1/utils/fire_db_help_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AddIssue extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddIssueMode();
  }
}

class MyData {
  String name = '';
  String phone = '';
  String email = '';
  String age = '';
}

class IssueData {
  String category = 'Pension';
  String from = 'Atmakur-unit1-1234';
  String priority = 'medium';
  String subject = '';
  final logit = FieldValue.serverTimestamp().toString();
  final logit1 = FieldValue.serverTimestamp();


   toJson() {
    return {'category': category,'from': from, 'createdAt': DateTime.now(), 'status': 'Untouched','priority': priority, 'subject': subject, 'logs': { 'from': 'Volunteer', 'time': logit } };
  }
}

class AddIssueMode extends State<AddIssue> {
  String _priority = "Pension";
  String title;
  String description;
  
  final _priorities = ["Pension","YSR Rythu Bharosa", "Fee reimbursement", "Aarogyasri", ];
  final schemes_list = ["Pension","YSR Rythu Bharosa", "Fee reimbursement", "Aarogyasri", ];

  
  
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
    final TextEditingController category = new TextEditingController();
  final TextEditingController subject = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
    static IssueData issueData = new IssueData();
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 16.0,
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    );
    return new MaterialApp(
        // theme: new ThemeData(
        //   primarySwatch: Colors.lightGreen,
        // ),
        home: new Scaffold(
          resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.indigoAccent,
          appBar: new AppBar(
            title: new Text('Add Issues'),
          ),
          body:  Container(
              margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 15.0,
                      spreadRadius: -5.0,
                      offset: Offset(0.0, 7.0)),
                ],
              ),
              width: 320.0,
              height: 420.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                       SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0),
                child:
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Choose Scheme/ Category',
                          contentPadding: EdgeInsets.zero,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                             value: _priority,
                            onChanged: (newValue) => {
                              setState(() {
                               issueData.category = newValue;
                                print('---------> ${newValue}');
            _priority = newValue;
          })
                             },
                            items: _priorities.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: textStyle,
                            
                          ),
                        ),
                      ),
                      ),
                      TextField(
                          maxLength: 30,
                         
          //                    onChanged: (value) => {
          //                       // print('-->%%%%%%%%%%%%%%%%%%%%%%%');
          //                     setState(() {
          //                       issueData.subject = value;
          //   _priority = value;
          // })
          //                    },
                          onChanged: (value) {
                          print('-->%%%%%%%%%%%%%%%%%%%%%%%123');
                          issueData.subject = value;
                            this.title = value;
                          },
                          keyboardType: TextInputType.text,
                          controller: titleController,
                          style: textStyle,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 15.0),
                            labelStyle: textStyle,
                          )),
                          
                          
                      TextFormField(
                          maxLength: 50,
                          onEditingComplete: (){
                            print('-->%%%%%%%%%%%%%%%%%%%%%%%');
                          },
                           onSaved: (value) => {
                              setState(() {
                              //  issueData.subject = value;
            // _priority = value;
          })
                             },
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'age cannot be left empty';
                          //   }

                          //   if (value.length > 30) {
                          //     return 'age should be greater than 60';
                          //   }
                          // },
                          keyboardType: TextInputType.text,
                          controller: descriptionController,
                          style: textStyle,
                          decoration: InputDecoration(
                            hintText: 'Description',
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 15.0),
                            labelStyle: textStyle,
                          )),
                      
                      SizedBox(
                        height: 50.0,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.all(13.0),
                        elevation: 2.0,
                        textColor: Colors.white,
                        color: Colors.amber,
                        //  onPressed: () => Save(),
                        //  onPressed: () => _showBottomSheet(), 
                        onPressed: _submitDetails,
                            //                     onPressed: () => {
                            //                         addData2Fire("vol_tickets", issueData).then((onValue){
                            //   print("check for inserted uid $onValue");     
                            // })
                                                // },
                            // onPressed: () => {},
                                                child: Text(
                                                   "Add",
                                                  style: TextStyle(
                                                      fontSize: 18.0, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ));
                          }
                        
                          void _submitDetails() {

                            final FormState formState = _formKey.currentState;


                      addData2Fire("vol_tickets", issueData).then((onValue){
                              print("check for inserted uid $onValue");     
                            });
   
        formState.save();
        print("Name: ${issueData.category}");
        print("Phone: ${issueData.subject}");

        


        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Details"),
              //content: new Text("Hello World"),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text("Name : " + issueData.category),
                    new Text("Phone : " + issueData.subject),
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

class StepperBody extends StatefulWidget {
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
  }

  // @override
  // void dispose() {
  //   _focusNode.dispose();
  //   super.dispose();
  // }

  List<Step> steps = [
    new Step(
        title: const Text('Add Issues'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: new TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          autocorrect: false,
          onSaved: (String value) {
            data.name = value;
          },
          maxLines: 1,
          //initialValue: 'Aseem Wangoo',
          validator: (value) {
            if (value.isEmpty || value.length < 1) {
              return 'Please enter name';
            }
          },
          decoration: new InputDecoration(
              labelText: 'Enter your name',
              hintText: 'Enter a name',
              //filled: true,
              icon: const Icon(Icons.person),
              labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    new Step(
        title: const Text('Phone'),
        //subtitle: const Text('Subtitle'),
        isActive: true,
        //state: StepState.editing,
        state: StepState.indexed,
        content: new TextFormField(
          keyboardType: TextInputType.phone,
          autocorrect: false,
          validator: (value) {
            if (value.isEmpty || value.length < 10) {
              return 'Please enter valid number';
            }
          },
          onSaved: (String value) {
            data.phone = value;
          },
          maxLines: 1,
          decoration: new InputDecoration(
              labelText: 'Enter your number',
              hintText: 'Enter a number',
              icon: const Icon(Icons.phone),
              labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    new Step(
        title: const Text('Email'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        // state: StepState.disabled,
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
        )),
    new Step(
        title: const Text('Age'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        content: new TextFormField(
          keyboardType: TextInputType.number,
          autocorrect: false,
          validator: (value) {
            if (value.isEmpty || value.length > 2) {
              return 'Please enter valid age';
            }
          },
          maxLines: 1,
          onSaved: (String value) {
            data.age = value;
          },
          decoration: new InputDecoration(
              labelText: 'Enter your age',
              hintText: 'Enter age',
              icon: const Icon(Icons.explicit),
              labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
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
          onPressed: _submitDetails,
          color: Colors.blue,
        ),
      ]),
    ));
  }
}