import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodybite_app/screens/routemap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' show cos, sqrt, asin;

class Routelist extends StatefulWidget {
  const Routelist({Key key}) : super(key: key);

  @override
  State<Routelist> createState() => _RoutelistState();
}

class _RoutelistState extends State<Routelist> {
  Future<Position> myLocation =
  Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  LatLng currentPosition;

  @override
  void initState() {
    super.initState();
  }
  update(loc) async {



    var url = "http://192.168.43.187:8000/update_garbage_status";

    var data = {
      "location_latitude": loc.latitude.toString(),
      "location_longitude":loc.longitude.toString(),
    };
    print(data);
    var res = await http.post(url, body: data);
    var message = jsonDecode(res.body);
    // print("status code : ${res.statusCode}\ndata : ${data}\nmessage : $message");
    print(message);



    if (res.statusCode == 200) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Routelist()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mycontext = context;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: initLoader(),
            builder:
                (BuildContext context, AsyncSnapshot<List<LatLng>> snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      LatLng loc = snapshot.data.elementAt(index);
                      return FutureBuilder(
                          future: getUserLocation(loc),
                          builder: (BuildContext context,
                              AsyncSnapshot<Placemark> snapshot) {
                            if (snapshot.hasData) {
                              return Card(
                                  child: ListTile(
                                    title: Text(snapshot.data.subLocality),
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RouteMap(starting: currentPosition,ending: loc,)));
                                    },
                                    onLongPress: (){
                                      print(loc);
                                      update(loc);
                                      // loc.latitude;
                                      // loc.latitude;
                                    },
                                    subtitle: Text(
                                        "${snapshot.data.locality}\n${loc.latitude},${loc.longitude}"),
                                  ));
                            } else {
                              return Card(
                                  child: ListTile(
                                    title: Text("${loc.latitude},${loc.longitude}"),
                                  ));
                            }
                          });
                    });
              } else {
                return Center(child: Text("loading"));
              }
            }),
      ),
    );
  }

  Future<List<LatLng>> initLoader() async {
    currentPosition = await _getUserLtLng();
    var list = await cmplnt();
    print(list);
    return list;
  }

  Future<LatLng> _getUserLtLng() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // setState(() {
    final currentPostion = LatLng(position.latitude, position.longitude);
    print("location changed" + currentPostion.toString());
    return currentPostion;
    // });
  }

  Future<List> cmplnt() async {
    var url = "http://192.168.43.187:8000/view_route";
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString('id')??"";
    // id = "11";
    var params = {
      'id':id
    };

    print(params);
    var res = await http.post(url, body: params);
    List message = jsonDecode(res.body);
    print(currentPosition);
    List<LatLng> locList = [];
    message.forEach((element) {
      double a = double.parse(element['location_latitude']);
      double b = double.parse(element['location_longitude']);
      LatLng loc = LatLng(a, b);

      locList.add(loc);
    });
    locList.sort((a, b) {
      // double distanceInMeters = Geolocator.distanceBetween(
      //     52.2165157, 6.9437819, 52.3546274, 4.8285838);

      return Geolocator.distanceBetween(a.latitude, a.longitude,
          currentPosition.latitude, currentPosition.longitude)
          .compareTo(Geolocator.distanceBetween(b.latitude, b.longitude,
          currentPosition.latitude, currentPosition.longitude));
    });


    // print(locList);
    // print("status code : ${res.statusCode}\ndata : ${data}\nmessage : $message");

    //   {
    //     "location_latitude": "11.2572741",
    //   "location_longitude": "75.7793725"
    // },
    return locList;
  }

  // double calculateDistance(lat1, lon1, lat2, lon2) {
  //   var p = 0.017453292519943295;
  //   var c = cos;
  //   var a = 0.5 -
  //       c((lat2 - lat1) * p) import 'dart:convert';
  //
  // import 'package:flutter/material.dart';
  // import 'package:foodybite_app/screens/routemap_copy.dart';
  // import 'package:geocoding/geocoding.dart';
  // import 'package:geolocator/geolocator.dart';
  // import 'package:google_maps_flutter/google_maps_flutter.dart';
  // import 'package:shared_preferences/shared_preferences.dart';
  // import 'package:http/http.dart' as http;
  // import 'dart:math' show cos, sqrt, asin;
  //
  // class Routelist extends StatefulWidget {
  //   const Routelist({Key key}) : super(key: key);
  //
  //   @override
  //   State<Routelist> createState() => _RoutelistState();
  // }
  //
  // class _RoutelistState extends State<Routelist> {
  //   Future<Position> myLocation =
  //       Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   LatLng currentPosition;
  //
  //   @override
  //   void initState() {
  //     super.initState();
  //   }
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     final mycontext = context;
  //     return Scaffold(
  //       body: SafeArea(
  //         child: FutureBuilder(
  //             future: initLoader(),
  //             builder:
  //                 (BuildContext context, AsyncSnapshot<List<LatLng>> snapshot) {
  //               if (snapshot.hasData) {
  //                 print(snapshot.data);
  //                 return ListView.builder(
  //                     itemCount: snapshot.data.length,
  //                     itemBuilder: (context, index) {
  //                       LatLng loc = snapshot.data.elementAt(index);
  //                       return FutureBuilder(
  //                           future: getUserLocation(loc),
  //                           builder: (BuildContext context,
  //                               AsyncSnapshot<Placemark> snapshot) {
  //                             if (snapshot.hasData) {
  //                               return Card(
  //                                   child: ListTile(
  //                                 title: Text(snapshot.data.subLocality),
  //                                 onTap: () {
  //                                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => RouteMap(starting: currentPosition,ending: loc,)));
  //                                 },
  //                                 subtitle: Text(
  //                                     "${snapshot.data.locality}\n${loc.latitude},${loc.longitude}"),
  //                               ));
  //                             } else {
  //                               return Card(
  //                                   child: ListTile(
  //                                 title: Text("${loc.latitude},${loc.longitude}"),
  //                               ));
  //                             }
  //                           });
  //                     });
  //               } else {
  //                 return Center(child: Text("loading"));
  //               }
  //             }),
  //       ),
  //     );
  //   }
  //
  //   Future<List<LatLng>> initLoader() async {
  //     currentPosition = await _getUserLtLng();
  //     var list = await cmplnt();
  //     print(list);
  //     return list;
  //   }
  //
  //   Future<LatLng> _getUserLtLng() async {
  //     var position = await GeolocatorPlatform.instance
  //         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //
  //     // setState(() {
  //     final currentPostion = LatLng(position.latitude, position.longitude);
  //     print("location changed" + currentPostion.toString());
  //     return currentPostion;
  //     // });
  //   }
  //
  //   Future<List> cmplnt() async {
  //     var url = "https://garbagemonitoring.herokuapp.com/view_route";
  //     final SharedPreferences pref = await SharedPreferences.getInstance();
  //     // var id = pref.getString('id') ?? "";
  //     var data = {"id": "37"};
  //     print(data);
  //     var res = await http.post(url, body: data);
  //     List message = jsonDecode(res.body);
  //     print(currentPosition);
  //     List<LatLng> locList = [];
  //     message.forEach((element) {
  //       double a = double.parse(element['location_latitude']);
  //       double b = double.parse(element['location_longitude']);
  //       LatLng loc = LatLng(a, b);
  //
  //       locList.add(loc);
  //     });
  //     locList.sort((a, b) {
  //       // double distanceInMeters = Geolocator.distanceBetween(
  //       //     52.2165157, 6.9437819, 52.3546274, 4.8285838);
  //
  //       return Geolocator.distanceBetween(a.latitude, a.longitude,
  //               currentPosition.latitude, currentPosition.longitude)
  //           .compareTo(Geolocator.distanceBetween(b.latitude, b.longitude,
  //               currentPosition.latitude, currentPosition.longitude));
  //     });
  //
  //     // print(locList);
  //     // print("status code : ${res.statusCode}\ndata : ${data}\nmessage : $message");
  //
  //     //   {
  //     //     "location_latitude": "11.2572741",
  //     //   "location_longitude": "75.7793725"
  //     // },
  //     return locList;
  //   }
  //
  //   // double calculateDistance(lat1, lon1, lat2, lon2) {
  //   //   var p = 0.017453292519943295;
  //   //   var c = cos;
  //   //   var a = 0.5 -
  //   //       c((lat2 - lat1) * p) / 2 +
  //   //       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  //   //   return 12742 * asin(sqrt(a));
  //   // }
  //
  //   Future<Placemark> getUserLocation(LatLng currentPosition) async {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         currentPosition.latitude, currentPosition.longitude);
  //     Placemark place = placemarks[0];
  //     return place;
  //   }
  // }/ 2 +
  //       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  //   return 12742 * asin(sqrt(a));
  // }

  Future<Placemark> getUserLocation(LatLng currentPosition) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    Placemark place = placemarks[0];
    return place;
  }
}
