// To parse this JSON data, do
//
//     final orderSave = orderSaveFromJson(jsonString);
// @dart=2.9
// To parse this JSON data, do
//
//     final orderSave = orderSaveFromJson(jsonString);

import 'dart:convert';

OrderSave orderSaveFromJson(String str) => OrderSave.fromJson(json.decode(str));

String orderSaveToJson(OrderSave data) => json.encode(data.toJson());

class OrderSave {
  OrderSave({
    this.id,
    this.amount,
    this.customerId,
    this.depotId,
    this.customerName,
    this.deliveryDate,
    this.items,
    this.orderId,
    this.orderingDate,
    this.qty,
    this.taxAmount,
    this.updatedBy,
    this.updatedTime,
    this.totalVat,
    this.totalGst,
    this.totalCess,
    this.salesTypeId,
    this.status,
    this.refNo,
    this.locationId,
    this.financialPeriodId,
    this.employeeId,
    this.currencyId,
  });

  int id;
  double amount;
  int customerId;
  int depotId;
  String customerName;
  DateTime deliveryDate;
  List<Item> items;
  String orderId;
  DateTime orderingDate;
  int qty;
  int taxAmount;
  int updatedBy;
  DateTime updatedTime;
  int totalVat;
  int totalGst;
  int totalCess;
  int salesTypeId;
  String status;
  String refNo;
  int locationId;
  int financialPeriodId;
  int employeeId;
  int currencyId;

  factory OrderSave.fromJson(Map<String, dynamic> json) => OrderSave(
    id: json["Id"],
    amount: json["Amount"].toDouble(),
    customerId: json["CustomerID"],
    depotId: json["DepotID"],
    customerName: json["CustomerName"],
    deliveryDate: DateTime.parse(json["DeliveryDate"]),
    items: List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
    orderId: json["OrderID"],
    orderingDate: DateTime.parse(json["OrderingDate"]),
    qty: json["Qty"],
    taxAmount: json["TaxAmount"],
    updatedBy: json["UpdatedBy"],
    updatedTime: DateTime.parse(json["UpdatedTime"]),
    totalVat: json["TotalVAT"],
    totalGst: json["TotalGST"],
    totalCess: json["TotalCESS"],
    salesTypeId: json["SalesTypeID"],
    status: json["Status"],
    refNo: json["RefNo"],
    locationId: json["LocationID"],
    financialPeriodId: json["FinancialPeriodID"],
    employeeId: json["EmployeeID"],
    currencyId: json["CurrencyID"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Amount": amount,
    "CustomerID": customerId,
    "DepotID": depotId,
    "CustomerName": customerName,
    "DeliveryDate": deliveryDate.toIso8601String(),
    "Items": List<dynamic>.from(items.map((x) => x.toJson())),
    "OrderID": orderId,
    "OrderingDate": orderingDate.toIso8601String(),
    "Qty": qty,
    "TaxAmount": taxAmount,
    "UpdatedBy": updatedBy,
    "UpdatedTime": updatedTime.toIso8601String(),
    "TotalVAT": totalVat,
    "TotalGST": totalGst,
    "TotalCESS": totalCess,
    "SalesTypeID": salesTypeId,
    "Status": status,
    "RefNo": refNo,
    "LocationID": locationId,
    "FinancialPeriodID": financialPeriodId,
    "EmployeeID": employeeId,
    "CurrencyID": currencyId,
  };
}

class Item {
  Item({
    this.itemId,
    this.itemName,
    this.qty,
    this.rate,
    this.taxAmount,
    this.total,
    this.unitId,
    this.updatedBy,
    this.updatedTime,
    this.gstAmount,
    this.vatAmount,
    this.cessAmount,
    this.inclusiveRate,
    this.discAmount,
    this.discPercentage,
  });

  int itemId;
  String itemName;
  int qty;
  double rate;
  int taxAmount;
  double total;
  int unitId;
  int updatedBy;
  dynamic updatedTime;
  int gstAmount;
  int vatAmount;
  int cessAmount;
  double inclusiveRate;
  int discAmount;
  int discPercentage;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    itemId: json["ItemID"],
    itemName: json["ItemName"],
    qty: json["Qty"],
    rate: json["Rate"].toDouble(),
    taxAmount: json["TaxAmount"],
    total: json["Total"].toDouble(),
    unitId: json["UnitID"],
    updatedBy: json["UpdatedBy"],
    updatedTime: json["UpdatedTime"],
    gstAmount: json["GSTAmount"],
    vatAmount: json["VATAmount"],
    cessAmount: json["CESSAmount"],
    inclusiveRate: json["InclusiveRate"].toDouble(),
    discAmount: json["DiscAmount"],
    discPercentage: json["DiscPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "ItemID": itemId,
    "ItemName": itemName,
    "Qty": qty,
    "Rate": rate,
    "TaxAmount": taxAmount,
    "Total": total,
    "UnitID": unitId,
    "UpdatedBy": updatedBy,
    "UpdatedTime": updatedTime,
    "GSTAmount": gstAmount,
    "VATAmount": vatAmount,
    "CESSAmount": cessAmount,
    "InclusiveRate": inclusiveRate,
    "DiscAmount": discAmount,
    "DiscPercentage": discPercentage,
  };
}
