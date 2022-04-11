// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);
// @dart=2.9
import 'dart:convert';

List<Products> productsFromJson(String str) => List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

String productsToJson(List<Products> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Products {
  Products({
    this.id,
    this.code,
    this.name,
    this.baseUnit,
    this.stock,
    this.purchaseRate,
    this.salesRate,
    this.description,
    this.priceCode,
    this.interBarcode,
    this.wacCost,
    this.vatPerc,
  });

  int id;
  String code;
  String name;
  BaseUnit baseUnit;
  double stock;
  double purchaseRate;
  double salesRate;
  String description;
  String priceCode;
  String interBarcode;
  double wacCost;
  double vatPerc;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    baseUnit: baseUnitValues.map[json["BaseUnit"]],
    stock: json["Stock"],
    purchaseRate: json["PurchaseRate"].toDouble(),
    salesRate: json["SalesRate"].toDouble(),
    description: json["Description"],
    priceCode: json["PriceCode"],
    interBarcode: json["InterBarcode"],
    wacCost: json["WacCost"],
    vatPerc: json["VATPerc"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "BaseUnit": baseUnitValues.reverse[baseUnit],
    "Stock": stock,
    "PurchaseRate": purchaseRate,
    "SalesRate": salesRate,
    "Description": description,
    "PriceCode": priceCode,
    "InterBarcode": interBarcode,
    "WacCost": wacCost,
    "VATPerc": vatPerc,
  };
}

enum BaseUnit { NOS, THE_1_X15_KG, EMPTY, THE_1_X20, THE_1_X100, THE_1_X50_KG, THE_1_X1_KG, THE_1_X22_680, THE_1134_KG, BASE_UNIT_1134_KG, THE_1_X10_KG, THE_1_X25_KG, THE_4_X5, KG, THE_1_X12, THE_2750_GM, THE_1_X25 }

final baseUnitValues = EnumValues({
  "11.34kg": BaseUnit.BASE_UNIT_1134_KG,
  "": BaseUnit.EMPTY,
  "Kg": BaseUnit.KG,
  "Nos": BaseUnit.NOS,
  "11.34 Kg": BaseUnit.THE_1134_KG,
  "1x100": BaseUnit.THE_1_X100,
  "1x10 Kg": BaseUnit.THE_1_X10_KG,
  "1x12": BaseUnit.THE_1_X12,
  "1x15 Kg": BaseUnit.THE_1_X15_KG,
  "1x1 Kg": BaseUnit.THE_1_X1_KG,
  "1x20": BaseUnit.THE_1_X20,
  "1x22.680": BaseUnit.THE_1_X22_680,
  "1x25": BaseUnit.THE_1_X25,
  "1x25 Kg": BaseUnit.THE_1_X25_KG,
  "1x50kg": BaseUnit.THE_1_X50_KG,
  "2750 Gm": BaseUnit.THE_2750_GM,
  "4x5": BaseUnit.THE_4_X5
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
