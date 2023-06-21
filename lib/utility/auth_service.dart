import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'bottom_nav_bar.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async{
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final User? user =
        (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  void signOut() {
    _auth.signOut();
    _googleSignIn.signOut();
    //FirebaseAuth.instance.signOut();
  }
  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapShot) {
        if (snapShot.hasData) {
          return BottomBar(bottomIndex: 3); // Modify  1 to 0 (Do it later)
        } else {
          return BottomBar(bottomIndex: 3);
        }
      },
    );
  }
}