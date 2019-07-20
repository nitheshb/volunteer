import 'package:flutter/material.dart';
import 'package:test_app_1/model/todo.dart';
import 'package:intl/intl.dart';



class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State<TodoDetail> {
  Todo todo;
  final _priorities = ["Pension","YSR Rythu Bharosa", "Fee reimbursement", "Aarogyasri", ];
  final schemes_list = ["Pension","YSR Rythu Bharosa", "Fee reimbursement", "Aarogyasri", ];
  String _priority = "Pension";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit;
  final _formKey = GlobalKey<FormState>();
  //we'll create a key within our class
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    isEdit = todo.title == '' ? false : true;
    titleController.text = todo.title;
    descriptionController.text = todo.description;
  }

  TodoDetailState(this.todo);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 16.0,
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
   
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.indigoAccent,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
        child: Column(
          children: <Widget>[
            Text(
              isEdit ? "Edit the plan" : "Avail New Scheme",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                  color: Colors.white),
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              child: Text(
                "Please check the eligibility of scheme/benefit before applying",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
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
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Scheme Name',
                          contentPadding: EdgeInsets.zero,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            items: _priorities.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: textStyle,
                            value: retrievePriority(todo.priority),
                            onChanged: (value) => updatePriority(value),
                          ),
                        ),
                      ),
                      TextFormField(
                          maxLength: 30,
                          onSaved: (value) {
                            todo.title = value;
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
                          onSaved: (value) {
                            todo.description = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'age cannot be left empty';
                            }

                            if (value.length > 30) {
                              return 'age should be greater than 60';
                            }
                          },
                          keyboardType: TextInputType.text,
                          controller: descriptionController,
                          style: textStyle,
                          decoration: InputDecoration(
                            hintText: 'Age',
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 15.0),
                            labelStyle: textStyle,
                          )),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Upload/Take Pic',
                          contentPadding: EdgeInsets.zero,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            items: _priorities.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: textStyle,
                            value: retrievePriority(todo.priority),
                            onChanged: (value) => updatePriority(value),
                          ),
                        ),
                      ),
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
                        onPressed: () => _showBottomSheet(),
                        child: Text(
                          isEdit ? "Edit" : "Add",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isEdit
          ? FloatingActionButton(
              onPressed: () {
                debugPrint("Click Floated Back.");
                confirmDelete();
              },
              elevation: 5.0,
              backgroundColor: Colors.red,
              tooltip: "Cancel",
              child: new Icon(
                Icons.clear,
                size: 35.0,
              ))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text("Are you sure about deleting this todo?",
                style: TextStyle(fontSize: 15.0)),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('CANCEL'),
                  onPressed: () => Navigator.of(context).pop()),
              new FlatButton(
                  child: new Text(
                    'DELETE',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    // helper.deleteTodo(todo.id);
                    Navigator.of(context).pop();
                    Navigator.pop(context, true);
                  })
            ],
          ),
    );
  }

  void save() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      todo.date = new DateFormat.yMd().format(DateTime.now());
      if (todo.id != null) {
        // helper.updateTodo(todo);
      } else {
        // helper.insertTodo(todo);
      }
      Navigator.pop(context, true);
    }
  }

  void updatePriority(String value) {
    switch (value) {
      case 'Pension':
        todo.priority = 1;
        break;
      case 'Aarogyasri':
        todo.priority = 3;
        break;
      case 'Low':
        todo.priority = 3;
        break;
    }

    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value - 1];
  }
   String retrieveSchemes(int value) {
    return _priorities[value - 1];
  }



  void updateTitle() {
    setState(() {
      todo.title = titleController.text;
    });
  }

  void updateDescription() {
    setState(() {
      todo.description = descriptionController.text;
    });
  }

  void  _showBottomSheet(){
    showModalBottomSheet(context: context, builder: (context) {
       return Container(
         height: 300,
         padding: EdgeInsets.all(12.0),
         child:Column(
         children: <Widget>[
           Text("Elgiable Docs",
           style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold
    ),),
           ListTile(
             leading: Image( image:AssetImage('assets/images/completed.png')),
             title: Text('Aadhar Card'),
             onTap: () => {},
           ),
           ListTile(
             leading: Image( image:AssetImage('assets/images/completed.png')),
             title: Text('White Ration Card'),
             onTap: () => {},
           ),
           ListTile(
             leading: Image( image:AssetImage('assets/images/completed.png')),
             title: Text('Finger Print'),
             onTap: () => {},
           ),
           ListTile(
             leading: Image( image:AssetImage('assets/images/non-completed.png')),
             title: Text('Age Certificate'),
             onTap: () => {},
           ),
           
         ],
       )
       );

    });
  }
}