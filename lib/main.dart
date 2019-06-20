import 'package:flutter/material.dart';
import 'package:test_app_1/pages/auction_homeP.dart';
import 'package:test_app_1/pages/myProfileP.dart';
import 'package:test_app_1/pages/razorPayHome.dart';
import 'package:test_app_1/pages/scratch_card.dart';
import 'package:test_app_1/pages/superviserDash.dart';
import 'package:test_app_1/pages/wallet_home.dart';
import 'package:test_app_1/pages/ysrcpDashboardP.dart';
import 'package:test_app_1/ui/screens/fixtures.dart';
import 'package:test_app_1/util/state_widget.dart';
import 'package:test_app_1/ui/theme.bloc.dart';
import 'package:test_app_1/ui/theme.dart';
import 'package:test_app_1/ui/screens/home.dart';
import 'package:test_app_1/ui/screens/sign_in.dart';
import 'package:test_app_1/ui/screens/sign_up.dart';
import 'package:test_app_1/ui/screens/forgot_password.dart';
import 'package:test_app_1/pages/Admin/add_matches_P.dart';
import 'package:test_app_1/services/authentication.dart';

final ThemeData _themeData = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.orange,
  accentColor: Colors.brown,
);

class MyApp extends StatelessWidget {
  MyApp() {
    //Navigation.initPaths();
  }

  void initState() {
    themeBloc.changeTheme(Themes.gameOrganizer);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp Title',
      theme: buildThemeGreen(),
     
      //onGenerateRoute: Navigation.router.generator,
      debugShowCheckedModeBanner: false,
      routes: {
        // '/': (context) => HomeScreen(),
        '/': (context) => YSRMainScreen(),
        '/dashboardYsr': (context) => YSRMainScreen(),
        '/volunteerDash': (context) => MyProfilePage(),
        '/superviseDash': (context) => SupervisorDash(),
        '/oldHome': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/add_matches': (context) => AddMatchesP(),
        '/wallet_home': (context) => WalletHome(),
        '/razorPay_home': (context) => RazorPayHome(),
        '/scratchCard': (context) => ScratchCardP(),
        // '/fixtures': (context) => FixturesScreen(auth: new Auth()),
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
