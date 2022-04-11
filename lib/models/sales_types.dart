// To parse this JSON data, do
//
//     final salestypes = salestypesFromJson(jsonString);
// @dart=2.9
import 'dart:convert';

List<Salestypes> salestypesFromJson(String str) => List<Salestypes>.from(json.decode(str).map((x) => Salestypes.fromJson(x)));

String salestypesToJson(List<Salestypes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Salestypes {
  Salestypes({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Salestypes.fromJson(Map<String, dynamic> json) => Salestypes(
    id: json["id"],
    name: json["Name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Name": name,
  };
}
