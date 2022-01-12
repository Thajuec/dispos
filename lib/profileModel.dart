class Profile {
  Profile({
      this.model, 
      this.pk, 
      this.fields,});

  Profile.fromJson(dynamic json) {
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
      this.fullName, 
      this.email, 
      this.mobile,});

  Fields.fromJson(dynamic json) {
    fullName = json['full_name'];
    email = json['email'];
    mobile = json['mobile'];
  }
  String fullName;
  String email;
  String mobile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['full_name'] = fullName;
    map['email'] = email;
    map['mobile'] = mobile;
    return map;
  }

}
