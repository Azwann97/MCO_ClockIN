import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mco_attendance_flutter_app/Controller/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:mco_attendance_flutter_app/View/StartupLoading.dart';
import 'package:mco_attendance_flutter_app/View/UserProfile.dart';
import 'DrawerList.dart';
import 'ReasonLate.dart';
import 'UserProfile.dart';

class HomePage extends StatefulWidget {
  final String uid;
  HomePage({this.uid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng l1;
  LatLng _CurrentLoc;
  int diff;
  String docId;
  double _distance;
  String _cDate = '';
  String _cLocation = "";
  DateTime now = DateTime.now();
  String currentTime;

  _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {
      _cLocation = "${position.longitude}, ${position.latitude}";
      _CurrentLoc = LatLng(position.latitude, position.longitude );
    });
  }

   _getHomeLocation() async {
    await FirebaseFirestore.instance.collection('users').where('user id', isEqualTo: widget.uid).get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i=0; i<docs.docs.length; i++) {
          initHome(docs.docs[i].data);
        }
      }
    });
  }

  void initHome(data) {
    //print(data()['email']);
    setState(() {
      l1 = LatLng(data()['Home'].latitude, data()['Home'].longitude);
      print(l1);

    });
  }

  _getCurrentDate() async {
    setState(() {
      currentTime = new DateTime(now.year, now.month, now.day).toString();
    });
  }

  _checkClockInData() async {
    await _getCurrentDate();
    await FirebaseFirestore.instance.collection('checkIn').where('user id', isEqualTo: widget.uid).where('Date', isEqualTo: currentTime).get().then((docs) {
      if (docs.docs.isNotEmpty) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Clock In Process Error!"),
              content: Text("You already clock in today"),
            )
        );
      }
      else {
        _checkIn();
      }
    });
  }

  void _checkIn() async {
    await _distanceCalculate();
    print(_distance);
    await _timeClockIn();
    if (_distance > 10.0){
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Clock In Process Error!"),
            content: Text("Your current location is outside of your home range"),
          )
      );
    }
    else {
      if (diff > 0.0){
        DocumentReference docRef =  await FirebaseFirestore.instance.collection("checkIn").add({
          'Date':currentTime,
          'Timestamp': Timestamp.now(),
          'user id': widget.uid,
          'Status':"Late",
          'Reason':""
        });
        print(docRef.id);
        setState(() {
          docId = docRef.id;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Reason(diff, docId)),
        );
      }
      else {
        FirebaseFirestore.instance.collection("checkIn").add({
          'Date':currentTime,
          'Timestamp': Timestamp.now(),
          'user id': widget.uid,
          'Status':"",
          'Reason':""
        });
      }
    }
  }

  _timeClockIn() async {
    TimeOfDay now = TimeOfDay.now();
    int nowInMinutes = now.hour * 60 + now.minute;

    TimeOfDay testDate = TimeOfDay(hour: 9, minute: 00);
    int testDateInMinutes = testDate.hour * 60 + testDate.minute;
    setState(() {
      diff = nowInMinutes - testDateInMinutes;
    });
  }

  _distanceCalculate() async {
    Geodesy geodesy = Geodesy();
    await  _getHomeLocation();
    await _getCurrentLocation();
    LatLng home = l1;
    LatLng l2 = _CurrentLoc;
    /*LatLng l2 = LatLng(58.64388889, 3.07000000);*/
    num distance = geodesy.distanceBetweenTwoGeoPoints(home, l2);
    //print("[distanceBetweenTwoGeoPoints] Distance: " + distance.toString());
    setState(() {
      _distance = distance;
    });
  }

  /*_getCurrentDate() async {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    setState(() {
      _cDate = dateParse.toString();
    });

  }*/

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('WFH Clock In'),
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
                    builder: (context) => new HomePage(uid: widget.uid),
                  ),
                );
              },),
              customList(Icons.person, 'Profile', () {
                Navigator.of(context).pop();
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => new Profile(uid: widget.uid),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: data.size.height*0.3,
              ),
              Center(
                child: RaisedButton(
                  elevation: 10.0,
                  color: Colors.lightBlueAccent,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      child: Text("Clock In Now", style: TextStyle(fontSize: 30.0, color: Colors.white),)),
                  onPressed: () {
                    _checkClockInData();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

