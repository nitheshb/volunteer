import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<GoogleSignInAccount> getSignedInAccount(
    GoogleSignIn googleSignIn) async {
  // Is the user already signed in?
  GoogleSignInAccount account = googleSignIn.currentUser;
  // Try to sign in the previous user:
  if (account == null) {
    account = await googleSignIn.signInSilently();
  }
  return account;
}

// Future<FirebaseUser> signIntoFirebase(
//     GoogleSignInAccount googleSignInAccount) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   GoogleSignInAuthentication googleAuth =
//       await googleSignInAccount.authentication;
//   return await _auth.signInWithGoogle(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );
// }


Future<FirebaseUser> signIntoFirebase(
    GoogleSignInAccount googleSignInAccount) async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;


final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );


  return await _auth.signInWithCredential(credential);
}

