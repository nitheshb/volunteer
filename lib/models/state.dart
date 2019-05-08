import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app_1/models/user.dart';
import 'package:test_app_1/models/settings.dart';

class StateModel {
  bool isLoading;
  FirebaseUser firebaseUserAuth;
  User user;
  Settings settings;

  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
    this.settings,
  });
}
