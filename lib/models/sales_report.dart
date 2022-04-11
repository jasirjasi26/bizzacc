// To parse this JSON data, do
//
//     final salesreport = salesreportFromJson(jsonString);
// @dart=2.9
import 'dart:convert';

Salesreport salesreportFromJson(String str) => Salesreport.fromJson(json.decode(str));

String salesreportToJson(Salesreport data) => json.encode(data.toJson());

class Salesreport {
  Salesreport({
    this.data,
    this.totalGrandTotal,
  });

  List<Datum> data;
  double totalGrandTotal;

  factory Salesreport.fromJson(Map<String, dynamic> json) => Salesreport(
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
    grandTotal: json["GrandTotal"],
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
