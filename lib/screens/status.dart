import 'package:flutter/material.dart';
import 'package:foodybite_app/models/status.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Status extends StatefulWidget {
  const Status({Key key}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  Future<Placemark> getUserLocation(LatLng currentPosition) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    Placemark place = placemarks[0];
    return place;
  }

  Future<Placemark> _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    LatLng currentPosition;

    currentPosition = LatLng(position.latitude, position.longitude);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble("latitude", currentPosition.latitude);
    await preferences.setDouble("longitude", currentPosition.longitude);
    print("location changed" + currentPosition.toString());
    return await getUserLocation(currentPosition);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.blue,
        actions: <Widget>[
          FutureBuilder(
            future: _getUserLocation(), // function where you call your api
            builder: (BuildContext context, AsyncSnapshot<Placemark> snapshot) {
              // AsyncSnapshot<Your object type>
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('Please wait its loading...'));
              } else {
                if (snapshot.hasError)
                  return Center(child: Text('Error: location not found'));
                else {
                  print(snapshot.data);
                  return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: new Text(
                            '${snapshot.data.subLocality}',style: TextStyle(fontSize: 20.0),),
                      )); // snapshot.data  :- get your object which is pass from your downloadData() function
                }
              }
            },
          ),
          Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.location_on,
                  size: 30.0,
                ),
              )),
        ],
      ),
      body: FutureBuilder(
          future: getStatus(),
          builder: (BuildContext context,
              AsyncSnapshot<List<StatusModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Please wait its loading...'));
            } else if (snapshot.hasError)
              return Center(child: Text('Error: location not found'));
            else {
              List<StatusModel> list = snapshot.data;
              var color = Colors.blue;
              var level = "Bin has free space.                        Enjoy disposing garbages at right places.                                Bins are waiting......";
              if (list
                  .elementAt(0)
                  .fields
                  .content == "full") {
                level = "Bin is full. Kindly check after sometime";
                color = Colors.red;
              }
              return SafeArea(
                minimum: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 180.0, left: 10.0),
                        child: Icon(
                          Icons.delete_outlined,
                          color: color,
                          size: 150.0,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 30.0),
                      child: Text(
                        level,
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
