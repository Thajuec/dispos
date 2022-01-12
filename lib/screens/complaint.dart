import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodybite_app/screens/problem.dart';
import 'package:foodybite_app/screens/recent.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Complaints extends StatefulWidget {
  const Complaints({Key key}) : super(key: key);

  @override
  _ComplaintsState createState() => _ComplaintsState();
}



class _ComplaintsState extends State<Complaints> {
  TextEditingController ComplaintsController = TextEditingController();


  complaints() async {
    String complaints = ComplaintsController.text;


    var url = "http://192.168.43.187:8000/driver_problem";
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString('id')??"";
    var data = {
      "content": complaints,

      "id":id
    };
    print(data);
    var res = await http.post(url, body: data);
    var message = jsonDecode(res.body);
    // print("status code : ${res.statusCode}\ndata : ${data}\nmessage : $message");
    print(message);
    bool isInserted = message["result"] as bool;
    var content = "An error occured...";
    if(isInserted){
      content = "Problem registered successfully...";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
    ));
    if (res.statusCode == 200) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Problem()));
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
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
                            controller: ComplaintsController,
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
                                          complaints();
                                        },
                                      ),

                                      // text
                                    ],

                                  )

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
          Navigator.pushNamed(context, 'complaints');
        },
        label: Text('Recent Complaints'),
        icon: Icon(Icons.compare_arrows),
      ),
    );
  }
}
