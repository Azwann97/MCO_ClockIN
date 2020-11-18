import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:mco_attendance_flutter_app/model/NewUser.dart';

class DatabaseService {

  final String uid ;
  final String email;
  DatabaseService({ this.uid, this.email });


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userCollection= FirebaseFirestore.instance.collection('users');
  final CollectionReference organizerCollection= FirebaseFirestore.instance.collection("event organizers");


  Future createUser(NewUser user) async {
    try {
      await userCollection.doc(user.id).set(user.toJson());
      //await userCollection.document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  /*Future createOrganizer(NewUser user) async {
    try {
      await organizerCollection.document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }*/

  Future getCurrentUser()  async {
    return FirebaseFirestore.instance.collection('User').where('user id' == uid).snapshots();
  }
}


