import 'package:flutter/material.dart';

enum Themes {
  light,
  dark,
  whapsapp,
  gameOrganizer,
  smartHome,
  networkGas,
  sliverProfile
}

ThemeData getThemeByType(Themes type) {
  switch (type) {
    case Themes.dark:
      return ThemeData(
        brightness: Brightness.light,
      );
    case Themes.whapsapp:
      return ThemeData(
        primaryColor: new Color(0xff075E54),
        accentColor: new Color(0xff25D366),
        fontFamily: 'Rubik',
      );
    case Themes.smartHome:
      return ThemeData(
        brightness: Brightness.light,
        backgroundColor: Color(0xfff7f8f9),
        fontFamily: 'Rubik',
        cardColor: Colors.white,
        accentColor: Color(0xffff1e39),
        //textTheme: TextTheme(),
      );
    case Themes.gameOrganizer:
      return ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: new Color(0xff00b965),
        ),
        accentColor: new Color(0xff00b965),
        backgroundColor: Color(0xfff7f8f9),
        fontFamily: 'Rubik',
        cardColor: Colors.white,
        //textTheme: TextTheme(),
      );
    case Themes.networkGas:
      {
        return ThemeData(
          brightness: Brightness.light,
          fontFamily: 'Roboto',
        );
      }
    case Themes.sliverProfile:
      {
        return ThemeData(
          brightness: Brightness.light,
          textTheme: TextTheme(
              title: TextStyle(
            color: Colors.black,
          )),
          fontFamily: 'Roboto',
        );
      }
    default:
      return ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Rubik',
      );
  }
}

const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

List<BoxShadow> shadow1 = [
  BoxShadow(
    offset: Offset(0.0, 0.3),
    blurRadius: 0.3,
    spreadRadius: -0.3,
    color: _kKeyUmbraOpacity.withOpacity(0.5),
  ),
  BoxShadow(
    offset: Offset(0.0, 0.3),
    blurRadius: 0.3,
    spreadRadius: 0.0,
    color: _kKeyPenumbraOpacity.withOpacity(0.5),
  ),
  BoxShadow(
    offset: Offset(0.0, 0.3),
    blurRadius: 0.3,
    spreadRadius: 0.0,
    color: _kAmbientShadowOpacity.withOpacity(0.5),
  ),
];




ThemeData buildThemBlue() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
        headline: base.headline.copyWith(
          fontFamily: 'Raleway',
          fontSize: 40.0,
          color: const Color(0xFF555555),
        ),
        title: base.title.copyWith(
          fontFamily: 'Raleway',
          fontSize: 15.0,
          color: const Color(0xFF555555),
        ),
        caption: base.caption.copyWith(
          color: const Color(0xFF555555),
        ),

        body1: base.body1.copyWith(color: const Color(0xFF555555)));
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.light();

  // And apply changes on it:
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryColor: const Color(0xFF2196F3),
    accentColor: const Color(0xFFFFFFFF),
    iconTheme: IconThemeData(
      color: const Color(0xFFCCCCCC),
      size: 20.0,
    ),
    buttonColor: Colors.white,
    backgroundColor: Colors.white,
  );
}


ThemeData buildThemeGreen() {
  // We're going to define all of our font styles
  // in this method:
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
        headline: base.headline.copyWith(
          fontFamily: 'Raleway',
          fontSize: 40.0,
          color: const Color(0xFF555555),
        ),
        title: base.title.copyWith(
          fontFamily: 'Raleway',
          fontSize: 15.0,
          color: const Color(0xFF555555),
        ),
        caption: base.caption.copyWith(
          color: const Color(0xFF555555),
        ),
        body1: base.body1.copyWith(color: const Color(0xFF555555),fontFamily: 'Raleway',),
        body2: base.body2.copyWith(color: const Color(0xFF555555),fontFamily: 'Raleway',),
        subhead: base.subhead.copyWith(color: const Color(0xFF555555),fontFamily: 'Raleway',),
        
        );
  }

  // We want to override a default light blue theme.
  final ThemeData base = ThemeData.light();

  // And apply changes on it:
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryColor: const Color(0xFF2196F3),
    accentColor: const Color(0xFFFFFFFF),
    iconTheme: IconThemeData(
      color: const Color(0xFFCCCCCC),
      size: 20.0,
    ),
    buttonColor: Colors.white,
    backgroundColor: Colors.white,
  );
}
