import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mco_attendance_flutter_app/Controller/auth_helper.dart';
import 'package:flutter/material.dart';

class ViewOnMap extends StatefulWidget {
  final GeoPoint point;
  ViewOnMap({this.point});
  @override
  _ViewOnMapState createState() => _ViewOnMapState();
}

class _ViewOnMapState extends State<ViewOnMap> {
  final AuthHelper _auth = AuthHelper();
  final _key = GlobalKey<FormState>();
  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
      markerId: MarkerId('Home'),
      draggable: false,
      position: LatLng (widget.point.latitude, widget.point.longitude)
    ));

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text('Home', style: TextStyle( fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: LatLng(widget.point.latitude, widget.point.longitude), zoom: 19,),
            markers: Set.from(allMarkers),
        )
      ),
    );
  }
}

