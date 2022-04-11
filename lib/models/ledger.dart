// To parse this JSON data, do
//
//     final ledger = ledgerFromJson(jsonString);
// @dart=2.9
import 'dart:convert';

Ledger ledgerFromJson(String str) => Ledger.fromJson(json.decode(str));

String ledgerToJson(Ledger data) => json.encode(data.toJson());

class Ledger {
  Ledger({
    this.data,
    this.totalDebit,
    this.totalCredit,
    this.totalBalance,
  });

  List<Datum> data;
  double totalDebit;
  double totalCredit;
  double totalBalance;

  factory Ledger.fromJson(Map<String, dynamic> json) => Ledger(
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
    totalDebit: json["TotalDebit"].toDouble(),
    totalCredit: json["TotalCredit"],
    totalBalance: json["TotalBalance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    "TotalDebit": totalDebit,
    "TotalCredit": totalCredit,
    "TotalBalance": totalBalance,
  };
}

class Datum {
  Datum({
    this.voucherNo,
    this.voucherDate,
    this.particulars,
    this.debit,
    this.credit,
    this.balance,
  });

  String voucherNo;
  DateTime voucherDate;
  String particulars;
  double debit;
  double credit;
  double balance;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    voucherNo: json["VoucherNo"],
    voucherDate: DateTime.parse(json["VoucherDate"]),
    particulars: json["Particulars"],
    debit: json["Debit"].toDouble(),
    credit: json["Credit"],
    balance: json["Balance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "VoucherNo": voucherNo,
    "VoucherDate": voucherDate.toIso8601String(),
    "Particulars": particulars,
    "Debit": debit,
    "Credit": credit,
    "Balance": balance,
  };
}
