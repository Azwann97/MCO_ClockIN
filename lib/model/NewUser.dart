import 'package:cloud_firestore/cloud_firestore.dart';

class NewUser {

  final String id;
  final String name;
  final String email;
  final GeoPoint home;
  final String UImage;

  NewUser({this.id, this.name, this.email, this.home, this.UImage});

  NewUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        email = data['email'],
        home = data['Home'],
        UImage = data['User Image'];


  Map<String, dynamic> toJson() {
    return {
      'user id': id,
      'name': name,
      'email': email,
      'Home': home,
      'User Image': UImage
    };
  }
}