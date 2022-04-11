// To parse this JSON data, do
//
//     final allOrder = allOrderFromJson(jsonString);
// @dart=2.9
// To parse this JSON data, do
//
//     final allOrder = allOrderFromJson(jsonString);

import 'dart:convert';

AllOrder allOrderFromJson(String str) => AllOrder.fromJson(json.decode(str));

String allOrderToJson(AllOrder data) => json.encode(data.toJson());

class AllOrder {
  AllOrder({
    this.data,
    this.totalGrandTotal,
  });

  List<Datum> data;
  double totalGrandTotal;

  factory AllOrder.fromJson(Map<String, dynamic> json) => AllOrder(
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
    this.orderId,
    this.voucherNo,
    this.orderDate,
    this.deliveryDate,
    this.grandTotal,
    this.customerName,
    this.depot,
  });

  int id;
  String orderId;
  String voucherNo;
  DateTime orderDate;
  DateTime deliveryDate;
  double grandTotal;
  String customerName;
  Depot depot;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    orderId: json["OrderID"],
    voucherNo: json["VoucherNo"],
    orderDate: DateTime.parse(json["OrderDate"]),
    deliveryDate: DateTime.parse(json["DeliveryDate"]),
    grandTotal: json["GrandTotal"].toDouble(),
    customerName: json["CustomerName"],
    depot: depotValues.map[json["Depot"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "OrderID": orderId,
    "VoucherNo": voucherNo,
    "OrderDate": orderDate.toIso8601String(),
    "DeliveryDate": deliveryDate.toIso8601String(),
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
