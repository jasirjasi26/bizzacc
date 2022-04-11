// To parse this JSON data, do
//
//     final logindata = logindataFromJson(jsonString);
// @dart=2.9
// To parse this JSON data, do
//
//     final logindata = logindataFromJson(jsonString);

import 'dart:convert';

List<Logindata> logindataFromJson(String str) => List<Logindata>.from(json.decode(str).map((x) => Logindata.fromJson(x)));

String logindataToJson(List<Logindata> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Logindata {
  Logindata({
    this.id,
    this.userName,
    this.token,
    this.employeeId,
    this.accountId,
    this.rateEdit,
    this.dateEdit,
    this.receipt,
    this.salesReport,
    this.stockVisiblity,
    this.hidePurchaseRate,
    this.salesManWiseCustomers,
    this.arabicPrint,
    this.imageSelection,
    this.salesRateLessThanPurchaseRate,
    this.blockNegativeStock,
    this.blockSalesRateLessThanMinimumSalesRate,
    this.hideCashReceived,
    this.hideCardReceived,
    this.hideRoundoff,
    this.hideTotalStock,
    this.cashAccountId,
    this.cashAccountName,
    this.bankAccountId,
    this.bankAccountName,
    this.mobilePrevilage,
    this.depotId,
    this.depotName,
    this.roundOff,
  });

  int id;
  String userName;
  String token;
  int employeeId;
  int accountId;
  bool rateEdit;
  bool dateEdit;
  bool receipt;
  bool salesReport;
  bool stockVisiblity;
  bool hidePurchaseRate;
  bool salesManWiseCustomers;
  bool arabicPrint;
  bool imageSelection;
  bool salesRateLessThanPurchaseRate;
  bool blockNegativeStock;
  bool blockSalesRateLessThanMinimumSalesRate;
  bool hideCashReceived;
  bool hideCardReceived;
  bool hideRoundoff;
  bool hideTotalStock;
  int cashAccountId;
  String cashAccountName;
  int bankAccountId;
  String bankAccountName;
  String mobilePrevilage;
  int depotId;
  String depotName;
  String roundOff;

  factory Logindata.fromJson(Map<String, dynamic> json) => Logindata(
    id: json["id"],
    userName: json["UserName"],
    token: json["Token"],
    employeeId: json["EmployeeID"],
    accountId: json["AccountID"],
    rateEdit: json["RateEdit"],
    dateEdit: json["DateEdit"],
    receipt: json["Receipt"],
    salesReport: json["SalesReport"],
    stockVisiblity: json["StockVisiblity"],
    hidePurchaseRate: json["HidePurchaseRate"],
    salesManWiseCustomers: json["SalesManWiseCustomers"],
    arabicPrint: json["ArabicPrint"],
    imageSelection: json["ImageSelection"],
    salesRateLessThanPurchaseRate: json["SalesRateLessThanPurchaseRate"],
    blockNegativeStock: json["blockNegativeStock"],
    blockSalesRateLessThanMinimumSalesRate: json["BlockSalesRateLessThanMinimumSalesRate"],
    hideCashReceived: json["HideCashReceived"],
    hideCardReceived: json["HideCardReceived"],
    hideRoundoff: json["HideRoundoff"],
    hideTotalStock: json["HideTotalStock"],
    cashAccountId: json["CashAccountID"],
    cashAccountName: json["CashAccountName"],
    bankAccountId: json["BankAccountID"],
    bankAccountName: json["BankAccountName"],
    mobilePrevilage: json["MobilePrevilage"],
    depotId: json["DepotID"],
    depotName: json["DepotName"],
    roundOff: json["RoundOff"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "UserName": userName,
    "Token": token,
    "EmployeeID": employeeId,
    "AccountID": accountId,
    "RateEdit": rateEdit,
    "DateEdit": dateEdit,
    "Receipt": receipt,
    "SalesReport": salesReport,
    "StockVisiblity": stockVisiblity,
    "HidePurchaseRate": hidePurchaseRate,
    "SalesManWiseCustomers": salesManWiseCustomers,
    "ArabicPrint": arabicPrint,
    "ImageSelection": imageSelection,
    "SalesRateLessThanPurchaseRate": salesRateLessThanPurchaseRate,
    "blockNegativeStock": blockNegativeStock,
    "BlockSalesRateLessThanMinimumSalesRate": blockSalesRateLessThanMinimumSalesRate,
    "HideCashReceived": hideCashReceived,
    "HideCardReceived": hideCardReceived,
    "HideRoundoff": hideRoundoff,
    "HideTotalStock": hideTotalStock,
    "CashAccountID": cashAccountId,
    "CashAccountName": cashAccountName,
    "BankAccountID": bankAccountId,
    "BankAccountName": bankAccountName,
    "MobilePrevilage": mobilePrevilage,
    "DepotID": depotId,
    "DepotName": depotName,
    "RoundOff": roundOff,
  };
}
