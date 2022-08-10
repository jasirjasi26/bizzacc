// To parse this JSON data, do
//
//     final salesinvoicedetail = salesinvoicedetailFromJson(jsonString);
// @dart=2.9
// To parse this JSON data, do
//
//     final salesinvoicedetail = salesinvoicedetailFromJson(jsonString);

import 'dart:convert';

Salesinvoicedetail salesinvoicedetailFromJson(String str) => Salesinvoicedetail.fromJson(json.decode(str));

String salesinvoicedetailToJson(Salesinvoicedetail data) => json.encode(data.toJson());

class Salesinvoicedetail {
  Salesinvoicedetail({
    this.data,
    this.totalQty,
    this.totalNetAmount,
  });

  List<Datum> data;
  double totalQty;
  double totalNetAmount;

  factory Salesinvoicedetail.fromJson(Map<String, dynamic> json) => Salesinvoicedetail(
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
    totalQty: json["TotalQty"].toDouble(),
    totalNetAmount: json["TotalNetAmount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    "TotalQty": totalQty,
    "TotalNetAmount": totalNetAmount,
  };
}

class Datum {
  Datum({
    this.voucherNo,
   // this.voucherDate,
    this.slNo,
    this.code,
    this.product,
    this.productGroup,
    this.qty,
    this.free,
    this.unit,
    this.rate,
    this.discount,
    this.vat,
    this.netAmount,
  });

  String voucherNo;
  // DateTime voucherDate;
  int slNo;
  String code;
  String product;
  double qty;
  double free;
  Unit unit;
  double rate;
  double discount;
  double vat;
  double netAmount;
  String productGroup;


  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    voucherNo: json["VoucherNo"],
    //voucherDate: DateTime.parse(json["VoucherDate"]),
    slNo: json["SlNo"],
    code: json["Code"],
    product: json["Product"],
    productGroup: json["ProductGroup"],
    qty: json["Qty"],
    free: json["Free"],
    unit: unitValues.map[json["Unit"]],
    rate: json["Rate"].toDouble(),
    discount: json["Discount"].toDouble(),
    vat: json["VAT"].toDouble(),
    netAmount: json["NetAmount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "VoucherNo": voucherNo,
   // "VoucherDate": voucherDate.toIso8601String(),
    "SlNo": slNo,
    "Code": code,
    "Product": product,
    "ProductGroup": productGroup,
    "Qty": qty,
    "Free": free,
    "Unit": unitValues.reverse[unit],
    "Rate": rate,
    "Discount": discount,
    "VAT": vat,
    "NetAmount": netAmount,
  };
}

enum ProductGroup { SHAPARAK_WAFER, OSHON_FUN_CON, SHOCK2_SHOCK, ULKER_HOBBY }

// final productGroupValues = EnumValues({
//   "OSHON FUN CON ": ProductGroup.OSHON_FUN_CON,
//   "SHAPARAK WAFER": ProductGroup.SHAPARAK_WAFER,
//   "SHOCK2SHOCK": ProductGroup.SHOCK2_SHOCK,
//   "ULKER HOBBY ": ProductGroup.ULKER_HOBBY
// });

enum Unit { DEFAULT, BOX, PKT }

final unitValues = EnumValues({
  "BOX": Unit.BOX,
  "Default": Unit.DEFAULT,
  "PKT": Unit.PKT
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
