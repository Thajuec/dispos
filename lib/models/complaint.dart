import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComplaintModel {
  ComplaintModel({
    this.model,
    this.pk,
    this.fields,});

  ComplaintModel.fromJson(dynamic json) {
    model = json['model'];
    pk = json['pk'];
    fields = json['fields'] != null ? Fields.fromJson(json['fields']) : null;
  }
  String model;
  int pk;
  Fields fields;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['model'] = model;
    map['pk'] = pk;
    if (fields != null) {
      map['fields'] = fields.toJson();
    }
    return map;
  }

}

class Fields {
  Fields({
    this.content,
    this.reply,
    this.date,});

  Fields.fromJson(dynamic json) {
    content = json['content'];
    reply = json['reply'];
    date = json['date'];
  }
  String content;
  String reply;
  String date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = content;
    map['reply'] = reply;
    map['date'] = date;
    return map;
  }

}

Future<List<ComplaintModel>> getComplaint() async{
  var url = "http://192.168.43.187:8000/view_complaint";
  final SharedPreferences pref = await SharedPreferences.getInstance();
  var id = pref.getString('id')??"";
  // id = "11";
  var params = {
    'id':id
  };
  print("params: $params");
  Response res = await post(Uri.parse(url), body: params);
  var list = (json.decode(res.body) as List)
      .map((data) => ComplaintModel.fromJson(data))
      .toList();
  print(list.elementAt(0));
  return list;
}