import 'package:flutter/material.dart';
import 'package:foodybite_app/profileModel.dart';
import 'package:foodybite_app/screens/bin.dart';
import 'package:foodybite_app/screens/cmplnt.dart';
import 'package:foodybite_app/screens/complaint.dart';
import 'package:foodybite_app/screens/home.dart';
import 'package:foodybite_app/screens/mapview.dart';
import 'package:foodybite_app/screens/msg.dart' as msg;
import 'package:foodybite_app/screens/polyline.dart';
import 'package:foodybite_app/screens/problem.dart';
import 'package:foodybite_app/screens/profile.dart';
import 'package:foodybite_app/screens/recent.dart';
import 'package:foodybite_app/screens/request.dart';
import 'package:foodybite_app/screens/routemap.dart';
import 'package:foodybite_app/screens/splash.dart';
import 'package:foodybite_app/screens/status.dart';
import 'package:foodybite_app/screens/user_home.dart';

import 'package:google_fonts/google_fonts.dart';
import 'screens/recent_request.dart';
import 'screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,

      title: 'Foodybite',
      theme: ThemeData(
        textTheme:
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

       home: splash(),

      routes: {
        '/h': (context) => LoginScreen(),
        'ForgotPassword': (context) => ForgotPassword(),
        'CreateNewAccount': (context) => CreateNewAccount(),
        'home':(context) => Home(),
        'RouteMap': (context) =>RouteMap(),
        'UserHome':(context)=> UserHome(),
        'msg':(context)=>msg.NotificationPage(),
        'cmplnt' :(context)=>Cmplnt(),
        'complaints':(context)=>Problem(),
        'request' :(context)=>Request(),
        'Recent':(context)=>Recent(),
        'Recent_request':(context)=>Recent_request(),
        'status':(context)=>Status(),
        'Profile':(context)=>UserProfileView(),
      },
    );
  }
}
