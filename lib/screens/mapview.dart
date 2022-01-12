import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodybite_app/screens/get_current_position.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition kerala = CameraPosition(
    target: LatLng(10.850516, 76.271080),
    zoom: 7.4746,
  );

  CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(17.43296265331129, -12.08832357078792),
      tilt: 59.440717697143555,
      zoom: 20.151926040649414
  );

  @override
  void initState() {
    _getUserLocation();
  }

  LatLng currentPostion;

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      _kLake = CameraPosition(
          target: currentPostion,
          bearing: 192.8334901395799,
          tilt: 59.440717697143555,
          zoom:15.151926040649414);
      print(currentPostion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: kerala,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended( backgroundColor: Colors.black,
        onPressed: _goToTheLake,
        label: Text('current locaion'),
        icon: Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
