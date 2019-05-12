import 'package:flutter/material.dart';
import 'package:test_app_1/pages/auction_homeP.dart';
import 'package:test_app_1/pages/razorPayHome.dart';
import 'package:test_app_1/pages/scratch_card.dart';
import 'package:test_app_1/pages/wallet_home.dart';
import 'package:test_app_1/ui/screens/fixtures.dart';
import 'package:test_app_1/util/state_widget.dart';
import 'package:test_app_1/ui/theme.dart';
import 'package:test_app_1/ui/screens/home.dart';
import 'package:test_app_1/ui/screens/sign_in.dart';
import 'package:test_app_1/ui/screens/sign_up.dart';
import 'package:test_app_1/ui/screens/forgot_password.dart';
import 'package:test_app_1/pages/Admin/add_matches_P.dart';



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
        '/add_matches': (context) => AddMatchesP(),
        '/wallet_home': (context) => WalletHome(),
        '/razorPay_home': (context) => RazorPayHome(),
        '/scratchCard': (context) => ScratchCardP(),
        '/fixtures': (context) => FixturesScreen(),
        '/auctionHome': (context)=> AuctionHome(),
        
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
