// To parse this JSON data, do
//
//     final customers = customersFromJson(jsonString);
// @dart=2.9
// To parse this JSON data, do
//
//     final customers = customersFromJson(jsonString);

import 'dart:convert';

List<Customers> customersFromJson(String str) => List<Customers>.from(json.decode(str).map((x) => Customers.fromJson(x)));

String customersToJson(List<Customers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customers {
  Customers({
    this.id,
    this.code,
    this.name,
    this.balance,
  });

  int id;
  String code;
  String name;
  double balance;

  factory Customers.fromJson(Map<String, dynamic> json) => Customers(
    id: json["id"],
    code: json["Code"],
    name: json["Name"],
    balance: json["Balance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Code": code,
    "Name": name,
    "Balance": balance,
  };
}

