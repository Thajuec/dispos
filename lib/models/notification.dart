import 'dart:convert';

import 'package:http/http.dart';

class NotificationModel {
  NotificationModel({
      this.model, 
      this.pk, 
      this.fields,});

  NotificationModel.fromJson(dynamic json) {
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
      this.date,});

  Fields.fromJson(dynamic json) {
    content = json['content'];
    date = json['date'];
  }
  String content;
  String date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = content;
    map['date'] = date;
    return map;
  }

}

Future<List<NotificationModel>> getNotification() async{
  var url = "http://192.168.43.187:8000/view_notification";

  Response res = await post(url,);
   var list = (json.decode(res.body) as List)
      .map((data) => NotificationModel.fromJson(data))
      .toList();
  print(list.elementAt(0));
  return list;
}