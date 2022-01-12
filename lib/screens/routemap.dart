import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RouteMap extends StatefulWidget {
  LatLng starting;
  LatLng ending;

  RouteMap({this.starting, this.ending});

  @override
  _MyAppState createState() => _MyAppState();
}

// Starting point latitude
double _originLatitude = 11.2588;
// Starting point longitude
double _originLongitude = 75.7804;
// Destination latitude
double _destLatitude = 11.6854;
// Destination Longitude
double _destLongitude = 76.1320;
// Markers to show points on the map
Map<MarkerId, Marker> markers = {};

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

class _MyAppState extends State<RouteMap> {
  // Google Maps controller
  Completer<GoogleMapController> _controller = Completer();
  // Configure map position and zoom
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(_originLatitude, _originLongitude),
    zoom: 12.4746,
  );
  LatLng currentPostion = LatLng(_originLatitude, _originLongitude);

  @override
  void initState() {
    _addMarker(
      widget.starting,
      "starting",
      BitmapDescriptor.defaultMarker,
    );

    _addMarker(
      widget.ending,
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );
    _getPolyline(widget.starting, widget.ending);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          polylines: Set<Polyline>.of(polylines.values),
          markers: Set<Marker>.of(markers.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          }),
    );
  }

  // This method will add markers to the map based on the LatLng position
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;
    // setState(() {});
  }

  void _getPolyline(LatLng start, LatLng end) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAyNUWcAbONUe-DqelZvgmz0gTBd8Lx9II",
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print("emd:" + result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
    setState(() {});
  }
}
