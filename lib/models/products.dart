// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);
// @dart=2.9
// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

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
    this.productImage,
    this.groupName,
    this.defaultSalesUnit,
    this.defaultPurchaseUnit,
    this.unit
  });

  int id;
  String code;
  String name;
  BaseUnit baseUnit;
  double stock;
  double purchaseRate;
  double salesRate;
  Description description;
  String priceCode;
  String interBarcode;
  double wacCost;
  double vatPerc;
  String productImage;
  String groupName;
  Unit defaultSalesUnit;
  Unit defaultPurchaseUnit;
  String unit;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    baseUnit: baseUnitValues.map[json["BaseUnit"]],
    stock: json["Stock"],
    purchaseRate: json["PurchaseRate"].toDouble(),
    salesRate: json["SalesRate"].toDouble(),
    description: descriptionValues.map[json["Description"]],
    priceCode: json["PriceCode"],
    interBarcode: json["InterBarcode"],
    wacCost: json["WacCost"],
    vatPerc: json["VATPerc"],
    productImage: json["ProductImage"] == null ? null : json["ProductImage"],
    groupName: json["GroupName"],
    defaultSalesUnit: unitValues.map[json["DefaultSalesUnit"]],
    defaultPurchaseUnit: unitValues.map[json["DefaultPurchaseUnit"]],
    unit: json["BaseUnit"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "BaseUnit": baseUnitValues.reverse[baseUnit],
    "Stock": stock,
    "PurchaseRate": purchaseRate,
    "SalesRate": salesRate,
    "Description": descriptionValues.reverse[description],
    "PriceCode": priceCode,
    "InterBarcode": interBarcode,
    "WacCost": wacCost,
    "VATPerc": vatPerc,
    "ProductImage": productImage == null ? null : productImage,
    "GroupName": groupName,
    "DefaultSalesUnit": unitValues.reverse[baseUnit],
    "DefaultPurchaseUnit": unitValues.reverse[baseUnit],
  };
}

enum Unit { PKT, BOX }

final unitValues = EnumValues({
  "BOX": Unit.BOX,
  "PKT": Unit.PKT
});

enum BaseUnit { PKT }

final baseUnitValues = EnumValues({
  "PKT": BaseUnit.PKT
});

enum Description { EMPTY, THE_1, THE_162 }

final descriptionValues = EnumValues({
  "": Description.EMPTY,
  "اولي اولي جيلي 1 كجم": Description.THE_1,
  "تذوق البندق 162 جرام": Description.THE_162
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
