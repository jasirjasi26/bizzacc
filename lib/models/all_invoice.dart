// To parse this JSON data, do
//
//     final allInvoice = allInvoiceFromJson(jsonString);
// @dart=2.9
// To parse this JSON data, do
//
//     final allInvoice = allInvoiceFromJson(jsonString);

import 'dart:convert';

AllInvoice allInvoiceFromJson(String str) => AllInvoice.fromJson(json.decode(str));

String allInvoiceToJson(AllInvoice data) => json.encode(data.toJson());

class AllInvoice {
  AllInvoice({
    this.data,
    this.totalGrandTotal,
  });

  List<Datum> data;
  double totalGrandTotal;

  factory AllInvoice.fromJson(Map<String, dynamic> json) => AllInvoice(
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
    this.invoiceId,
    this.voucherNo,
    this.invoiceDate,
    this.deliveryDate,
    this.grandTotal,
    this.customerName,
    this.depot,
  });

  int id;
  String invoiceId;
  String voucherNo;
  DateTime invoiceDate;
  DateTime deliveryDate;
  double grandTotal;
  String customerName;
  Depot depot;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    invoiceId: json["InvoiceID"] == null ? null : json["InvoiceID"],
    voucherNo: json["VoucherNo"],
    invoiceDate: DateTime.parse(json["InvoiceDate"]),
    deliveryDate: json["DeliveryDate"] == null ? null : DateTime.parse(json["DeliveryDate"]),
    grandTotal: json["GrandTotal"].toDouble(),
    customerName: json["CustomerName"],
    depot: depotValues.map[json["Depot"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "InvoiceID": invoiceId == null ? null : invoiceId,
    "VoucherNo": voucherNo,
    "InvoiceDate": invoiceDate.toIso8601String(),
    "DeliveryDate": deliveryDate == null ? null : deliveryDate.toIso8601String(),
    "GrandTotal": grandTotal,
    "CustomerName": customerName,
    "Depot": depotValues.reverse[depot],
  };
}

enum Depot { DEFAULT }

final depotValues = EnumValues({
  "Default": Depot.DEFAULT
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
