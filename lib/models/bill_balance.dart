// To parse this JSON data, do
//
//     final billbalance = billbalanceFromJson(jsonString);
// @dart=2.9

import 'dart:convert';

Billbalance billbalanceFromJson(String str) => Billbalance.fromJson(json.decode(str));

String billbalanceToJson(Billbalance data) => json.encode(data.toJson());

class Billbalance {
  Billbalance({
    this.data,
    this.totalAmount,
    this.totalBalance,
  });

  List<Datum> data;
  double totalAmount;
  double totalBalance;

  factory Billbalance.fromJson(Map<String, dynamic> json) => Billbalance(
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
    totalAmount: json["TotalAmount"].toDouble(),
    totalBalance: json["TotalBalance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    "TotalAmount": totalAmount,
    "TotalBalance": totalBalance,
  };
}

class Datum {
  Datum({
    this.voucherNo,
    this.voucherDate,
    this.amount,
    this.balance,
    this.overDue,
  });

  String voucherNo;
  DateTime voucherDate;
  double amount;
  double balance;
  double overDue;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    voucherNo: json["VoucherNo"],
    voucherDate: DateTime.parse(json["VoucherDate"]),
    amount: json["Amount"].toDouble(),
    balance: json["Balance"].toDouble(),
    overDue: json["OverDue"],
  );

  Map<String, dynamic> toJson() => {
    "VoucherNo": voucherNo,
    "VoucherDate": voucherDate.toIso8601String(),
    "Amount": amount,
    "Balance": balance,
    "OverDue": overDue,
  };
}
