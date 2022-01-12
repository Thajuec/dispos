import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusModel {
  StatusModel({
    this.model,
    this.pk,
    this.fields,});

  StatusModel.fromJson(dynamic json) {
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
    });

  Fields.fromJson(dynamic json) {
    content = json['status'];

  }
  String content;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = content;

    return map;
  }

}

Future<List<StatusModel>> getStatus() async{
  var url = "http://192.168.43.187:8000/nearest_garbage";
  final SharedPreferences pref = await SharedPreferences.getInstance();
  var latitude = (pref.getDouble('latitude')??0.0).toString();
  var longitude = (pref.getDouble('longitude')??0.0).toString();

  var params = {
    'latitude':latitude,
    'longitude':longitude,

  };
  print("params: $params");
  Response res = await post(url, body: params);
  var list = (json.decode(res.body) as List)
      .map((data) => StatusModel.fromJson(data))
      .toList();
  print(res.body);
  return list;
  return [];
}