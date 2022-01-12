import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:foodybite_app/screens/recent.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Cmplnt extends StatefulWidget {
  const Cmplnt({Key key}) : super(key: key);

  @override
  _CmplntState createState() => _CmplntState();
}

class _CmplntState extends State<Cmplnt> {
  TextEditingController CmplntController = TextEditingController();


  cmplnt() async {
    String cmplnt = CmplntController.text;


    var url = "http://192.168.43.187:8000/user_complaint_get";
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString('id')??"";
    var data = {
      "content": cmplnt,
      "id":id
    };
    print(data);
    var res = await http.post(url, body: data);
    var message = jsonDecode(res.body);
    // print("status code : ${res.statusCode}\ndata : ${data}\nmessage : $message");
    print(message);
    bool isInserted = message["result"] as bool;
    var content = "An error occured";
    if(isInserted){
      content = "Complaint registered successfully...";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
    ));
    if (res.statusCode == 200) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Recent()));
    }
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              // child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(

                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.insert_comment,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                // child: Icon(
                                //   Icons.add_circle,
                                //   color: Colors.grey.shade700,
                                //   size: 25.0,
                                // ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),

                        Container(
                          child: TextFormField(
                            controller: CmplntController,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,//Normal textInputField will be displayed
                            maxLines: 5,
                            decoration: InputDecoration(hintText: "Description"),

                          ),
                          // decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),

                        Container(
                          margin: EdgeInsets.only(right: 220,top: 30),
                          height: 60.0,
                          child: SizedBox.fromSize(
                            size: Size(60, 60), // button width and height
                            child: ClipOval(
                              child: Material(
                                color: Colors.blue[300], // button color
                                child: InkWell(
                                  splashColor: Colors.grey[600],
                                  // splash color
                                  onTap: () {},
                                  // button pressed
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(

                                        icon: Icon(
                                          Icons.send,
                                        ),
                                        iconSize: 30,
                                        color: Colors.white,
                                        splashColor: Colors.grey,
                                        onPressed: () {
                                          cmplnt();
                                        },
                                      ),

                                      // text
                                    ],
                                  ),

                                ),
                              ),
                            ),
                          ),

                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton.extended( backgroundColor: Colors.blue[300],
         onPressed:(){
           Navigator.pushNamed(context, 'Recent');
         },
        label: Text('Recent Complaints'),
        icon: Icon(Icons.compare_arrows),
      ),
    );
  }
}
