import 'package:mco_attendance_flutter_app/Controller/auth_helper.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({ this.toggleView });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
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
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Container(height: data.size.height * 0.05),
                /*RaisedButton(
                  child: Text("Login with Google"),
                  onPressed: () async {
                    try {
                      await AuthHelper.signInWithGoogle();
                    } catch (e) {
                      print(e);
                    }
                  },
                ),*/
                //googlesignin
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
                Container(height: data.size.height * 0.05),
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
                Container(height: data.size.height * 0.05),
                Center(
                  child: RaisedButton(
                    child: Text("Login"),
                    onPressed: () async {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        print("Email and password cannot be empty");
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
                      }
                    },
                  ),
                ),
                Center(
                  child: FlatButton(
                    onPressed: widget.toggleView,
                    child: Text(
                        'Create an Account if you\'re new',
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
}