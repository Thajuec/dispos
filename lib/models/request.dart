import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestModel {
  RequestModel({
    this.model,
    this.pk,
    this.fields,});

  RequestModel.fromJson(dynamic json) {
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
    this.date,
    this.reply,});

  Fields.fromJson(dynamic json) {
    content = json['content'];
    date = json['date'];
    reply = json['reply'];
  }
  String content;
  String date;
  String reply;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = content;
    map['date'] = date;
    map['reply'] = reply;
    return map;
  }

}

Future<List<RequestModel>> getRequest() async{
  var url = "http://192.168.43.187:8000/view_request";
  final SharedPreferences pref = await SharedPreferences.getInstance();
  var id = pref.getString('id')??"";
  // id = "11";
  var params = {
    'id':id
  };
  print("params: $params");
  Response res = await post(url, body: params);
  var list = (json.decode(res.body) as List)
      .map((data) => RequestModel.fromJson(data))
      .toList();
  print(list.elementAt(0));
  return list;
}