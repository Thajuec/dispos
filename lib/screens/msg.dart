import 'package:flutter/material.dart';
import 'package:foodybite_app/models/notification.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}


class _NotificationState extends State<NotificationPage> {

  List<NotificationModel> list=[];

@override
  void initState() {
    getNotification().then((value) {
      setState(() {

        list = value;
      });
      print("list length : ${list.length}");
    } );
    super.initState();
  }
  Future<Placemark> getUserLocation(LatLng currentPosition) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    Placemark place = placemarks[0];
    return place;
  }
  LatLng currentPosition;
  Future<Placemark> _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    currentPosition = LatLng(position.latitude, position.longitude);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setDouble("latitude", currentPosition.latitude);
    await preferences.setDouble("longitude", currentPosition.longitude);
    print("location changed" + currentPosition.toString());
    return await getUserLocation(currentPosition);

  }
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: FutureBuilder(
          future: _getUserLocation(), // function where you call your api
          builder: (BuildContext context, AsyncSnapshot<Placemark> snapshot) {  // AsyncSnapshot<Your object type>
            if( snapshot.connectionState == ConnectionState.waiting){
              return  Center(child: Text('Please wait its loading...'));
            }else{
              if (snapshot.hasError)
                return Center(child: Text('Error: location not found'));
              else {
                print(snapshot.data);
                return Center(
                    child: new Text(
                        '${snapshot.data.subLocality}')); // snapshot.data  :- get your object which is pass from your downloadData() function
              }
            }
          },
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
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
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 80, left: 10.0),
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'My Account',
                style: TextStyle(fontSize: 20.0),
              ),
              onTap: () {
                Navigator.pushNamed(context, 'Profile');
              },
            ),
            ListTile(
              title: const Text('Notifications', style: TextStyle(fontSize: 20.0)),
              onTap: () {
                Navigator.pushNamed(context, 'msg');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
          minimum: EdgeInsets.all(15),
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    title: Text(list.elementAt(i).fields.content),
                    subtitle: Text(list.elementAt(i).fields.date),

                  ),
                );
              })),
    );
  }
}
