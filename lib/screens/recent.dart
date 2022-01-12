import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodybite_app/models/complaint.dart';

class Recent extends StatefulWidget {
  const Recent({Key key}) : super(key: key);

  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  List<ComplaintModel> list=[];

  @override

  void initState() {
    getComplaint().then((value) {
      setState(() {
        list = value;
      });
      print("list length : ${list.length}");
    } );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.account_circle,
        //     size: 37.00,
        //     color: Colors.white,
        //   ),
        // ),
        backgroundColor: Colors.blue
        ,
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
                    trailing: Text(list.elementAt(i).fields.reply??""
                        ""),
                  ),
                );
              })),
    );
  }
}
