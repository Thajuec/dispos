import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodybite_app/pallete.dart';
import 'package:foodybite_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;

import 'login-screen.dart';

class CreateNewAccount extends StatefulWidget {
  @override
  _CreateNewAccountState createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  TextEditingController UsernameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController MobileController = TextEditingController();
  TextEditingController Password1Controller = TextEditingController();
  TextEditingController Password2Controller = TextEditingController();

  userRegister() async {
    String username = UsernameController.text;
    String email = EmailController.text;
    String mobile = MobileController.text;
    String password1 = Password1Controller.text;
    String password2 = Password2Controller.text;

    var url = "http://192.168.43.187:8000/user_registration";
    var data = {
      "full_name": username,
      "email": email,
      "mobile": "+91"+mobile,
      "password1": password1,
      "password2": password2
    };

    var res = await http.post(url, body: data);
    var message = jsonDecode(res.body);
    // print("status code : ${res.statusCode}\ndata : ${data}\nmessage : $message");

    if (res.statusCode == 200) {
      bool data=message['result'];
      print(data);
if(data) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Registration Successful"),
  ));
}
else{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("INVALID SUBMISION"),
  ));}
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message["errors"].toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(image: 'assets/images/bin3.jpg'),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.width * 0.1,
                  ),
                  Stack(
                    children: [
                      Center(
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: CircleAvatar(
                              radius: size.width * 0.10,
                              backgroundColor: Colors.grey[400].withOpacity(
                                0.4,
                              ),
                              child: Icon(
                                FontAwesomeIcons.user,
                                color: kWhite,
                                size: size.width * 0.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: size.height * 0.08,
                      //   left: size.width * 0.56,
                      //   child: Container(
                      //     height: size.width * 0.1,
                      //     width: size.width * 0.1,
                      //     decoration: BoxDecoration(
                      //       color: kBlue,
                      //       shape: BoxShape.circle,
                      //       border: Border.all(color: kWhite, width: 1),
                      //     ),
                      //     child: Icon(
                      //       FontAwesomeIcons.arrowUp,
                      //       color: kWhite,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                  SizedBox(
                    height: size.width * 0.0,
                  ),
                  Column(
                    children: [
                      TextInputField(
                        controller: UsernameController,
                        icon: FontAwesomeIcons.user,
                        hint: 'Username',
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                      ),
                      TextInputField(
                        controller: EmailController,
                        icon: FontAwesomeIcons.envelope,
                        hint: 'Email',
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                      ),

                      TextInputField(
                        controller: MobileController,
                        icon: FontAwesomeIcons.mobile,
                        hint: 'Mobile',
                        inputAction: TextInputAction.next,
                      ),
                      PasswordInput(
                        controller: Password1Controller,
                        icon: FontAwesomeIcons.lock,
                        hint: ' Password',
                        inputAction: TextInputAction.done,
                      ),
                      PasswordInput(
                        controller: Password2Controller,
                        icon: FontAwesomeIcons.userLock,
                        hint: ' Confirm Password',
                        inputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RoundedButton(
                        buttonName: 'Register',
                        click: userRegister,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: kBodyText,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/h');
                            },
                            child: Text(
                              'Login',
                              style: kBodyText.copyWith(
                                  color: kBlue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
