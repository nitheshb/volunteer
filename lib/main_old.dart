import 'package:flutter/material.dart';
import 'package:test_app_1/services/authentication.dart';
import 'package:test_app_1/pages/root_page.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
        home: new RootPage(auth: new Auth()));
  }
}
