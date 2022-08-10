// To parse this JSON data, do
//
//     final productgroup = productgroupFromJson(jsonString);
// @dart=2.9

import 'dart:convert';

List<Productgroup> productgroupFromJson(String str) => List<Productgroup>.from(json.decode(str).map((x) => Productgroup.fromJson(x)));

String productgroupToJson(List<Productgroup> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Productgroup {
  Productgroup({
    this.name,
  });

  String name;

  factory Productgroup.fromJson(Map<String, dynamic> json) => Productgroup(
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
  };
}
