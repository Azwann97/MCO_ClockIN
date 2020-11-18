import 'package:flutter/material.dart';
import 'package:mco_attendance_flutter_app/View/LoginGui.dart';
import 'package:mco_attendance_flutter_app/View/RegisterGui.dart';

class Handler extends StatefulWidget {
  @override
  _HandlerState createState() => _HandlerState();
}

class _HandlerState extends State<Handler> {

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn  = !showSignIn );
  }
  @override
  Widget build(BuildContext context) {
    if ( showSignIn) {
      return Login(toggleView: toggleView);
    }  else {
      return RegisterGUI(toggleView: toggleView);
    }
  }
}