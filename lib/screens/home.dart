import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodybite_app/screens/complaint.dart';
import 'package:foodybite_app/screens/mapview.dart';
import 'package:foodybite_app/screens/polyline.dart';
import 'package:foodybite_app/screens/route.dart';
import 'package:foodybite_app/screens/routelist.dart';
import 'package:foodybite_app/screens/routemap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bin.dart';
import 'notification.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit from App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }
  @override


  int _selectedIndex = 0;
  static TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List _widgetOptions = <Widget>[
    Bin(),
    Routelist(),
    Complaints(),

    // Request(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.blue,
          actions: <Widget>[
            FutureBuilder(
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
        body: Container(decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://media.istockphoto.com/photos/blue-fabric-texture-background-with-copy-space-picture-id1276890859?b=1&k=20&m=1276890859&s=170667a&w=0&h=MO-Q7sOTJge5dhq8SJgvqWelzuiBbD9BdPsG7Cy64gI="),
            fit: BoxFit.cover,
          ),
        ),
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.room_outlined),
              label: 'RouteMap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.comment),
              label: 'Complaints',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }



}
