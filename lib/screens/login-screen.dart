import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodybite_app/pallete.dart';
import 'package:foodybite_app/screens/get_current_position.dart';
import 'package:foodybite_app/screens/user_home.dart';
import 'package:foodybite_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController UsernameController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  login({String password, String username}) async {
    var url = "http://192.168.43.187:8000/userlogin";

    var parameter = {
      "email": username,
      "password1": password,
    };

    Response res = await post(url, body: parameter);
    print("statuscode : ${res.statusCode}");
    var data = jsonDecode(res.body);

    bool isUser = data['result'] as bool;
    print(parameter);
    String message = "Email address or password incorrect!";
    if (isUser) {
      message = "login successful";
      String role = data['user']['role'];
      String id = data['user']['id'].toString();
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('id', id);
      await pref.setString('role', role);

      print(message);

      if (role == 'public') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM // Also possible "TOP" and "CENTER"
              );
          return UserHome();
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM // Also possible "TOP" and "CENTER"
              );
          return Home();
        }));
      }
    } else {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: BackgroundImage(
            image: 'assets/images/bin3.jpg',

          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Flexible(
                child: Center(
                  child: Image.asset('assets/images/logo5.png',width: 200,height: 200,),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextInputField(
                    icon: FontAwesomeIcons.envelope,
                    hint: 'Email',
                    controller: UsernameController,
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                  ),
                  PasswordInput(
                    icon: FontAwesomeIcons.lock,
                    hint: 'Password',
                    controller: PasswordController,
                    inputAction: TextInputAction.done,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RoundedButton(
                    buttonName: 'Login',
                    click: () {

                      login(username: UsernameController.text,password: PasswordController.text);
                      // await determinePosition().then((value) => () {
                      //       print("${value.latitude} ${value.longitude}");
                      //     });
                      // print("fuction call");
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),



              // GestureDetector(
              //   onTap: () => Navigator.pushNamed(context, 'home'),
              //   child: Container(
              //     child: Text(
              //       'Home',
              //       style: kBodyText,
              //     ),
              //     decoration: BoxDecoration(
              //         border:
              //             Border(bottom: BorderSide(width: 1, color: kWhite))),
              //   ),
              // ),




              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'CreateNewAccount'),
                child: Container(
                  child: Text(
                    'Create New Account',
                    style: kBodyText,
                  ),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(width: 1, color: kWhite))),
                ),
              ),














              // GestureDetector(
              //   onTap: () => Navigator.pushNamed(context, 'UserHome'),
              //   child: Container(
              //     child: Text(
              //       'user home',
              //       style: kBodyText,
              //     ),
              //     decoration: BoxDecoration(
              //         border:
              //             Border(bottom: BorderSide(width: 1, color: kWhite))),
              //   ),
              // ),











              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }
}
