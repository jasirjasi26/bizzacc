// To parse this JSON data, do
//
//     final units = unitsFromJson(jsonString);
// @dart=2.9
// To parse this JSON data, do
//
//     final units = unitsFromJson(jsonString);

// To parse this JSON data, do
//
//     final units = unitsFromJson(jsonString);

import 'dart:convert';

List<Units> unitsFromJson(String str) => List<Units>.from(json.decode(str).map((x) => Units.fromJson(x)));

String unitsToJson(List<Units> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Units {
  Units({
    this.productId,
    this.productName,
    this.unitId,
    this.unitName,
    this.unitCf,
    this.salesRate,
  });

  int productId;
  String productName;
  int unitId;
  UnitName unitName;
  double unitCf;
  double salesRate;

  factory Units.fromJson(Map<String, dynamic> json) => Units(
    productId: json["ProductID"],
    productName: json["ProductName"],
    unitId: json["UnitID"],
    unitName: unitNameValues.map[json["UnitName"]],
    unitCf: json["UnitCF"],
    salesRate: json["SalesRate"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ProductID": productId,
    "ProductName": productName,
    "UnitID": unitId,
    "UnitName": unitNameValues.reverse[unitName],
    "UnitCF": unitCf,
    "SalesRate": salesRate,
  };
}

enum UnitName { NOS, BOX, THE_1_X1_KG, THE_1_X10_KG, THE_1_X50_KG, KG, THE_1_X25, THE_1_X15_KG, THE_2750_GM, THE_1_X100, THE_1_X25_KG, THE_1_X22_680, THE_1_X20, THE_4_X5, THE_1_X12, THE_1134_KG, UNIT_NAME_1134_KG, DEFAULT }

final unitNameValues = EnumValues({
  "Box": UnitName.BOX,
  "Default": UnitName.DEFAULT,
  "Kg": UnitName.KG,
  "Nos": UnitName.NOS,
  "11.34kg": UnitName.THE_1134_KG,
  "1x100": UnitName.THE_1_X100,
  "1x10 Kg": UnitName.THE_1_X10_KG,
  "1x12": UnitName.THE_1_X12,
  "1x15 Kg": UnitName.THE_1_X15_KG,
  "1x1 Kg": UnitName.THE_1_X1_KG,
  "1x20": UnitName.THE_1_X20,
  "1x22.680": UnitName.THE_1_X22_680,
  "1x25": UnitName.THE_1_X25,
  "1x25 Kg": UnitName.THE_1_X25_KG,
  "1x50kg": UnitName.THE_1_X50_KG,
  "2750 Gm": UnitName.THE_2750_GM,
  "4x5": UnitName.THE_4_X5,
  "11.34 Kg": UnitName.UNIT_NAME_1134_KG
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
