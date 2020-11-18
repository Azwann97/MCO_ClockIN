import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geodesy/geodesy.dart';
import 'MapView.dart';

class UserDetails extends StatelessWidget {
  UserDetails({this.document});
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {

    final data = MediaQuery.of(context);
    return new ListView.builder(
      primary: false,
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String name = document[i].data()['name'].toString();
        String email = document[i].data()['email'].toString();
        GeoPoint home = document[i].data()['Home'];
        String UImage = document[i].data()['User Image'].toString();

        return Container(
          child: Column(
            children: <Widget>[
              Container(
                height: data.size.height*0.7,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height:data.size.height*0.3,
                        width:200,
                        margin: EdgeInsets.only(top: 30, bottom: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          //border: Border.all(width: 3, color: Colors.blueGrey),
                          image: DecorationImage(
                              image: NetworkImage(UImage),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: FaIcon(Icons.person, color: Colors.blueAccent),
                            ),
                            new Expanded(child: Text(name, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(Icons.mail_outline, color: Colors.blueAccent,),
                            ),
                            new Expanded(child: Text(email, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          height: data.size.height*0.1,
                          //width: double.infinity,
                          child: RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              color: Colors.blueAccent,
                              onPressed: (){
                                //Navigator.pop(context);
                                //print(UserImage);
                                Navigator.of(context).push(new MaterialPageRoute(
                                    builder: (BuildContext context) => new ViewOnMap(point: home)
                                ));
                              },
                              icon: Icon(FontAwesomeIcons.map, color: Colors.white,),
                              label: Text("View Home on Map", style: TextStyle(color: Colors.white))
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*Container(
                height: data.size.height*0.1,
                width: double.infinity,
                child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    color: Colors.blueAccent,
                    onPressed: (){
                      Navigator.pop(context);
                      //print(UserImage);
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new EditProfile(
                            name: name,
                            Email: email,
                            UImage : UImage,
                            index: document[i].reference,
                          )
                      ));
                    },
                    icon: Icon(FontAwesomeIcons.edit, color: Colors.white,),
                    label: Text("Edit", style: TextStyle(color: Colors.white))
                ),
              ),*/
            ],
          ),
        );
      },
    );
  }
}