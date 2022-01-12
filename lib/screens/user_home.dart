import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodybite_app/screens/profile.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../profileModel.dart';
import 'msg.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
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

  }  @override
  String field = "";

  List<Profile> models = [];

  Future<Profile> getuserdata() async {
    var url = "http://192.168.43.187:8000/user_profile";
    var params = {
      'id':"37"
    };
    http.Response result = await http.post(Uri.parse(url),body: params);
    print(params);
    print("result body : ${result.body}");
    Iterable l = json.decode(result.body);
    var model = Profile.fromJson(l.elementAt(0));
    // List<UserView> ModelList =
    //     List<UserView>.from(l.map((model) => model.fromJson(model)));

    return model;
  }

  @override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.blue,
        actions: <Widget>[FutureBuilder(
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
                          '${snapshot.data.subLocality}',style: TextStyle(fontSize: 20.0,),),
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

                 Card(
                   child: Padding(
                     padding: const EdgeInsets.only(top: 500),
                     child: FutureBuilder(future: getuserdata(),

                        builder:  (BuildContext context, AsyncSnapshot<Profile> snapshot) {

                          print(snapshot);
                          if( snapshot.connectionState == ConnectionState.waiting){
                            return  Center(child: Text('Please wait its loading...'));
                          }else{
                            if (snapshot.hasError)
                              return Center(child: Text('Error: ${snapshot.error}'));
                            else
                              return mycard(context,fullName: snapshot.data.fields.fullName,email: snapshot.data.fields.email,
                                mobile: snapshot.data.fields.mobile,);  // snapshot.data  :- get your object which is pass from your downloadData() function
                          }
                        }
                     ),
                   ),
                 ),


          ],
        ),

      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://media.istockphoto.com/photos/blue-fabric-texture-background-with-copy-space-picture-id1276890859?b=1&k=20&m=1276890859&s=170667a&w=0&h=MO-Q7sOTJge5dhq8SJgvqWelzuiBbD9BdPsG7Cy64gI="),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(

          padding: const EdgeInsets.all(8.0),

          child: Column(
            children: [
          Container(


          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget> [Padding(
                padding: const EdgeInsets.all(1.0),
                child: CarouselSlider(items: [
                  Image.network("https://media.istockphoto.com/photos/sustainable-lifestyle-and-environmental-picture-id1263548947?b=1&k=20&m=1263548947&s=170667a&w=0&h=ybMGaURTF7vhin5PfYe0e3sqYUUBvfDVFEML5Tj1Wdk="),
                  Image.network("https://sp-ao.shortpixel.ai/client/to_avif,q_lossy,ret_img,w_1500,h_1000/https://www.trvst.world/static_images/waste-recycling/rrr-bea-johnson.png"),
                  Image.network("https://www.cityofkingsville.com/wp-content/uploads/2020/12/hand-holding-garbage-black-bag-putting-trash-scaled.jpg"),

                  Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAg30g1QHq_RvqEWsHnRe-OeMgHQKHzt_jIQ&usqp=CAU"),


                ], options: CarouselOptions(height: 200,initialPage: 1,autoPlay: true,enlargeCenterPage: true,),),
              ),


              ]


          ),


        ),
              SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center,

                children: [
                MyCard(click: (){
                Navigator.pushNamed(context, 'msg');
              },icon: Icons.notifications,text: 'Notification',),
                MyCard(click: (){
                  Navigator.pushNamed(context, 'status');
              },
                icon: Icons.delete_outline,text: 'Garbage Status',)],),



              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  MyCard(click: (){
                  Navigator.pushNamed(context, 'cmplnt');


                }, icon: Icons.event_note, text: 'Complaint'),
                  MyCard(click: (){
                    Navigator.pushNamed(context, 'request');

                  }, icon: Icons.add_comment,text: 'Request',)],
                ),
              ),
            ],
          ),
        ),
      ),




    );
  }
}


/// This is the stateless widget that the main application instantiates.
class MyCard extends StatelessWidget {

  IconData icon;
  String text;
  Function click;
   MyCard({Key key,this.icon,this.text,this.click}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: GestureDetector(onTap: click,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.vertical(bottom: Radius.circular(15),top: Radius.circular(15)),

            image: DecorationImage(
              image: NetworkImage(
                  "https://media.istockphoto.com/photos/blue-fabric-texture-background-with-copy-space-picture-id1276890859?b=1&k=20&m=1276890859&s=170667a&w=0&h=MO-Q7sOTJge5dhq8SJgvqWelzuiBbD9BdPsG7Cy64gI="),
              fit: BoxFit.fill,
            ),
          ),

            width: 150,
            height: 180,
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Icon(icon,size: 80.0,color: Colors.blue)),
                Center(child: Text(text))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
