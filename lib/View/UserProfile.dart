import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mco_attendance_flutter_app/Controller/auth_helper.dart';
import 'package:flutter/material.dart';
import 'DrawerList.dart';
import 'HomePage.dart';
import 'StartupLoading.dart';
import 'UserDetails.dart';

class Profile extends StatefulWidget {
  final String uid;
  Profile({this.uid});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text('Home', style: TextStyle( fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(color: Colors.deepPurpleAccent),
                  child: StreamBuilder(
                      stream:FirebaseFirestore.instance.collection('users').doc(widget.uid).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SplashPage();
                        }
                        return Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data['User Image']
                                ),
                                backgroundColor: Colors.white,
                                radius: 50.0,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text("User Name", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                            ),
                            Align(
                              alignment: Alignment.centerRight + Alignment(0, .4),
                              child: Text("User Type", style: TextStyle(color: Colors.white, fontSize: 15.0),),
                            )
                          ],
                        );
                      }
                  )
              ),
              customList(Icons.home, 'HomePage', () {
                Navigator.of(context).pop();
                Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) =>  HomePage(uid: widget.uid),
                ),
                );
              },),
              customList(Icons.person, 'Profile', () {
                Navigator.of(context).pop();
                Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context) => Profile(uid: widget.uid),
                ),
                );
              },),
              customList(Icons.logout, 'LogOut', () async {
                Navigator.of(context).pop();
                await AuthHelper.logOut();
              })/*=>AuthHelper.logOut()*/
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: data.size.height * 0.05,
                  child: Text(
                    "User Profile",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
                Container(
                  height: data.size.height * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("users").where("user id", isEqualTo: widget.uid).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                            if(!snapshot.hasData){
                              return new Container(
                                height: data.size.height*0.7,
                                child: Center(
                                  child: SplashPage(),
                                ),
                              );
                            }
                            return Container(
                                height: data.size.height*0.7,
                                child: new UserDetails(document: snapshot.data.docs)
                            );
                          },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

