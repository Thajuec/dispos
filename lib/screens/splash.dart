import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodybite_app/screens/login-screen.dart';




class splash extends StatefulWidget {
  const splash({Key key}) : super(key: key);

  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

backgroundColor: Colors.black,

      body: Container(height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 70,left: 60,right: 30),
          child: Image.asset("assets/images/logo2.png",height:10,width: 10,),

        ),


        // child: Image.network("https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"),
      ),
      // appBar: AppBar(
      //   title:Text("splash screen"),
      //   backgroundColor: Colors.red,
      //   centerTitle: true,
      // ),


    );
  }
}
