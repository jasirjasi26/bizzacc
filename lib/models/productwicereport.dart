// To parse this JSON data, do
//
//     final salesinvoicedetail = salesinvoicedetailFromJson(jsonString);
// @dart=2.9
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
    totalQty: json["TotalQty"],
    totalNetAmount: json["TotalNetAmount"]??0,
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
    //this.voucherDate,
    this.slNo,
    this.code,
    this.product,
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    voucherNo: json["VoucherNo"],
    //voucherDate: DateTime.parse(json["VoucherDate"]),
    slNo: json["SlNo"],
    code: json["Code"],
    product: json["Product"],
    qty: json["Qty"],
    free: json["Free"],
    unit: unitValues.map[json["Unit"]],
    rate: json["Rate"],
    discount: json["Discount"] == null ? null : json["Discount"].toDouble(),
    vat: json["VAT"],
    netAmount: json["NetAmount"],
  );

  Map<String, dynamic> toJson() => {
    "VoucherNo": voucherNo,
    //"VoucherDate": voucherDate.toIso8601String(),
    "SlNo": slNo,
    "Code": code,
    "Product": product,
    "Qty": qty,
    "Free": free,
    "Unit": unitValues.reverse[unit],
    "Rate": rate,
    "Discount": discount == null ? null : discount,
    "VAT": vat,
    "NetAmount": netAmount,
  };
}

enum Unit { NOS, DEFAULT }

final unitValues = EnumValues({
  "Default": Unit.DEFAULT,
  "Nos": Unit.NOS
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
