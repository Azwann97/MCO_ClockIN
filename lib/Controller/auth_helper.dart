import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mco_attendance_flutter_app/model/AppUser.dart';
import 'package:mco_attendance_flutter_app/model/NewUser.dart';
import 'package:mco_attendance_flutter_app/Controller/UserDBHandler.dart';

class AuthHelper {

  static FirebaseAuth _auth = FirebaseAuth.instance;
  NewUser _currentUser;
  NewUser get currentUser => _currentUser;

  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  //signInWithEmail
  static signInWithEmail({String email, String password}) async {
    final res = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final User user = res.user;
    return user;
  }

  static signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final acc = await googleSignIn.signIn();
    final auth = await acc.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken
    );
    final res = await _auth.signInWithCredential(credential);
    return res.user;

  }

  //registerWithEmail
  Future registerWithEmailAndPassword(String email, String password, String name, GeoPoint currentLoc) async {

    try {
      // create user authenticate AuthResult = UserCredential
      UserCredential result = await _auth.createUserWithEmailAndPassword(email:email, password: password);
      User user = result.user;
      //create user profile
      _currentUser = NewUser(
        id: result.user.uid,
        email: email,
        name: name,
        home: new GeoPoint (currentLoc.latitude, currentLoc.longitude),
        UImage: "https://firebasestorage.googleapis.com/v0/b/mco-attendanceprototype.appspot.com/o/blank_portrait-350x350.png?alt=media&token=b40f567a-eadb-42c8-b66d-698b4144c683"
        //UImage: "https://firebasestorage.googleapis.com/v0/b/enma-2d0a9.appspot.com/o/blank_portrait-350x350.png?alt=media&token=1d10269f-3c6b-4831-b446-be408c5accc1",

      );
      await DatabaseService().createUser(_currentUser);
      //await DatabaseService().createUser(_currentUser);
      return _userFromFirebaseUser(user);
    }  catch(e) {
      print(e.toString());
      return null;
    }
  }

  static logOut() async {
    GoogleSignIn().signOut();
    return await _auth.signOut();
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    }  catch(e){
      print(e.toString());
      return null;
    }
  }

}