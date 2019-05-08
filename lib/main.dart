import 'package:flutter/material.dart';
import 'package:test_app_1/util/state_widget.dart';
import 'package:test_app_1/ui/theme.dart';
import 'package:test_app_1/ui/screens/home.dart';
import 'package:test_app_1/ui/screens/sign_in.dart';
import 'package:test_app_1/ui/screens/sign_up.dart';
import 'package:test_app_1/ui/screens/forgot_password.dart';
import 'package:test_app_1/pages/firebaseDemo.dart';



class MyApp extends StatelessWidget {
  MyApp() {
    //Navigation.initPaths();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp Title',
      theme: buildTheme(),
      //onGenerateRoute: Navigation.router.generator,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/add_matches': (context) => FireBaseFireStoreDemo(),
        
      },
    );
  }
}

void main() {
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );
  runApp(stateWidget);
}
