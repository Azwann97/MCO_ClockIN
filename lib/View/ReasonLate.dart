import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mco_attendance_flutter_app/Controller/auth_helper.dart';
import 'package:flutter/material.dart';

class Reason extends StatefulWidget {
  int late;
  String docId;

  Reason(this.late, this.docId);

  @override
  _ReasonState createState() => _ReasonState();
}

class _ReasonState extends State<Reason> {
  int LIM;
  final AuthHelper _auth = AuthHelper();
  final _key = GlobalKey<FormState>();
  TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          title: new Text("Late"),
          content: new Text("You are late by $LIM minutes"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                print(widget.docId);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    });
    LIM = widget.late;
    _reasonController = TextEditingController(text: "");

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
                      "Reason on late clock in",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
                Container(height: data.size.height * 0.05),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  controller: _reasonController,
                  onEditingComplete: () => node.nextFocus(),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.black)
                      ),
                      //prefixIcon: Icon(Icons.person, color: Colors.black,),
                      hintText: "Your Reason"
                  ),
                ),
                Container(height: data.size.height * 0.025),
                Center(
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: () async {
                      await _saveReason();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _saveReason () async {
    FirebaseFirestore.instance.collection("checkIn").doc(widget.docId).update({
      'Reason':_reasonController.text.toString()
    });
  }

}

