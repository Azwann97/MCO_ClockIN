import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mco_attendance_flutter_app/Controller/auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterGUI extends StatefulWidget {
  final Function toggleView;
  RegisterGUI({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterGUI> {

  final AuthHelper _auth = AuthHelper();
  final _key = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GeoPoint _CurrentLoc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          title: new Text("Instruction"),
          content: new Text("Please make sure that your current location is inside your house since your current location will be use as your home location for the future use"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
    _nameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {
      _CurrentLoc = GeoPoint(position.latitude, position.longitude );
      print("${position.longitude}, ${position.latitude}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final node = FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: data.size.height * 0.1,
                  child: Text(
                    "WFH CheckIN",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
                Container(
                  height: data.size.height * 0.05,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Register",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Container(height: data.size.height * 0.05),
                TextField(
                  controller: _nameController,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.black,),
                      hintText: "Enter name"
                  ),
                ),
                Container(height: data.size.height * 0.025),
                TextField(
                  controller: _emailController,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.black,),
                      hintText: "Enter email"
                  ),
                ),
                Container(height: data.size.height * 0.025),
                TextField(
                  controller: _passwordController,
                  onEditingComplete: () => node.nextFocus(),
                  obscureText: true,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.black,),
                      hintText: "Enter password"
                  ),
                ),
                Container(height: data.size.height * 0.025),
                Center(
                  child: RaisedButton(
                    child: Text("Register"),
                    onPressed: () async {
                      /*if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty ||
                          _nameController.text.isEmpty) {
                        print("all field must be fill in");
                        return;
                      }
                      try {
                        final user = await AuthHelper.signInWithEmail(
                            email: _emailController.text,
                            password: _passwordController.text);
                        if (user != null) {
                          print("login successful");
                        }
                      } catch (e) {
                        print(e);
                      }*/
                      //_getCurrentLocation();
                      register();
                    },
                  ),
                ),
                Center(
                  child: FlatButton(
                    onPressed: widget.toggleView,
                    child: Text(
                        'Already have an account? Login',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() async {
    await _getCurrentLocation();
    dynamic result = await _auth.registerWithEmailAndPassword(_emailController.text, _passwordController.text, _nameController.text, _CurrentLoc);
    if (result == null){
      print("email is not valid");
    }
    else {
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      Navigator.pop(context);
    }
  }
}
