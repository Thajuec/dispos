import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../profileModel.dart';



class UserProfileView extends StatefulWidget {
  const UserProfileView({Key key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  String field = "";

  List<Profile> models = [];

  Future<Profile> getuserdata() async {
    var url = "http://192.168.43.187:8000/user_profile";
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString('id')??"";
    // id = "11";
    var params = {
      'id': id
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
        body: FutureBuilder(future: getuserdata(),
            builder:  (BuildContext context, AsyncSnapshot<Profile> snapshot) {
              print(snapshot);
              if( snapshot.connectionState == ConnectionState.waiting){
                return  Center(child: Text('Please wait its loading...'));
              }else{
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                else
                  return mycard(context,fullName: snapshot.data.fields.fullName,email: snapshot.data.fields.email,
                    mobile: snapshot.data.fields.mobile.toString(),);  // snapshot.data  :- get your object which is pass from your downloadData() function
              }
            })
    );
  }
}

Widget mycard(BuildContext context,{
  String fullName,
  String email,
  String mobile,
}) {
  return Card(
    elevation: 5.0,
    margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
    child: Container(
        padding: EdgeInsets.all(15),
        child: Container(child: ListView(children: [
          ListTile(title: Center(child: Text("My Profile",),), ),
          ListTile(title: Text("fullname:"),trailing: Text("$fullName"), ),
          ListTile(title: Text("email:"),trailing: Text("$email"), ),
          ListTile(title: Text("mobile"),trailing: Text("$mobile"), ),


        ],),)
    ),
  );
}