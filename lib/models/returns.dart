// To parse this JSON data, do
//
//     final returns = returnsFromJson(jsonString);
// @dart=2.9
// To parse this JSON data, do
//
//     final returns = returnsFromJson(jsonString);

import 'dart:convert';

Returns returnsFromJson(String str) => Returns.fromJson(json.decode(str));

String returnsToJson(Returns data) => json.encode(data.toJson());

class Returns {
  Returns({
    this.data,
    this.totalGrandTotal,
  });

  List<Datum> data;
  double totalGrandTotal;

  factory Returns.fromJson(Map<String, dynamic> json) => Returns(
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
    totalGrandTotal: json["TotalGrandTotal"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    "TotalGrandTotal": totalGrandTotal,
  };
}

class Datum {
  Datum({
    this.id,
    this.returnId,
    this.voucherNo,
    this.returnDate,
    this.deliveryDate,
    this.grandTotal,
    this.customerName,
    this.depot,
  });

  int id;
  String returnId;
  String voucherNo;
  DateTime returnDate;
  dynamic deliveryDate;
  double grandTotal;
  String customerName;
  String depot;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    returnId: json["ReturnID"],
    voucherNo: json["VoucherNo"],
    returnDate: DateTime.parse(json["ReturnDate"]),
    deliveryDate: json["DeliveryDate"],
    grandTotal: json["GrandTotal"].toDouble(),
    customerName: json["CustomerName"],
    depot: json["Depot"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ReturnID": returnId,
    "VoucherNo": voucherNo,
    "ReturnDate": returnDate.toIso8601String(),
    "DeliveryDate": deliveryDate,
    "GrandTotal": grandTotal,
    "CustomerName": customerName,
    "Depot": depot,
  };
}
