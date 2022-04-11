// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);
// @dart=2.9
import 'dart:convert';

List<Company> companyFromJson(String str) => List<Company>.from(json.decode(str).map((x) => Company.fromJson(x)));

String companyToJson(List<Company> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Company {
  Company({
    this.companyName,
    this.address1,
    this.address2,
    this.address3,
    this.city,
    this.state,
    this.fkCountry,
    this.country,
    this.postalCode,
    this.telephone,
    this.mobile,
    this.fax,
    this.email,
    this.webSite,
    this.currencyCode,
    this.currencyName,
    this.currencyChange,
    this.currencySymbol,
    this.noofDecimals,
    this.tax1Number,
    this.tax2Number,
    this.tax3Number,
    this.gstNumber,
    this.vatNumber,
    this.accountNumber,
    this.noofDecimalinQty,
    this.companyLogo,
  });

  String companyName;
  String address1;
  String address2;
  String address3;
  String city;
  String state;
  int fkCountry;
  String country;
  String postalCode;
  String telephone;
  String mobile;
  String fax;
  String email;
  String webSite;
  String currencyCode;
  String currencyName;
  String currencyChange;
  String currencySymbol;
  int noofDecimals;
  String tax1Number;
  String tax2Number;
  String tax3Number;
  String gstNumber;
  String vatNumber;
  String accountNumber;
  int noofDecimalinQty;
  String companyLogo;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    companyName: json["CompanyName"],
    address1: json["Address1"],
    address2: json["Address2"],
    address3: json["Address3"],
    city: json["City"],
    state: json["State"],
    fkCountry: json["FK_Country"],
    country: json["Country"],
    postalCode: json["PostalCode"],
    telephone: json["Telephone"],
    mobile: json["Mobile"],
    fax: json["Fax"],
    email: json["Email"],
    webSite: json["WebSite"],
    currencyCode: json["CurrencyCode"],
    currencyName: json["CurrencyName"],
    currencyChange: json["CurrencyChange"],
    currencySymbol: json["CurrencySymbol"],
    noofDecimals: json["NoofDecimals"],
    tax1Number: json["Tax1Number"],
    tax2Number: json["Tax2Number"],
    tax3Number: json["Tax3Number"],
    gstNumber: json["GSTNumber"],
    vatNumber: json["VATNumber"],
    accountNumber: json["AccountNumber"],
    noofDecimalinQty: json["NoofDecimalinQty"],
    companyLogo: json["CompanyLogo"],
  );

  Map<String, dynamic> toJson() => {
    "CompanyName": companyName,
    "Address1": address1,
    "Address2": address2,
    "Address3": address3,
    "City": city,
    "State": state,
    "FK_Country": fkCountry,
    "Country": country,
    "PostalCode": postalCode,
    "Telephone": telephone,
    "Mobile": mobile,
    "Fax": fax,
    "Email": email,
    "WebSite": webSite,
    "CurrencyCode": currencyCode,
    "CurrencyName": currencyName,
    "CurrencyChange": currencyChange,
    "CurrencySymbol": currencySymbol,
    "NoofDecimals": noofDecimals,
    "Tax1Number": tax1Number,
    "Tax2Number": tax2Number,
    "Tax3Number": tax3Number,
    "GSTNumber": gstNumber,
    "VATNumber": vatNumber,
    "AccountNumber": accountNumber,
    "NoofDecimalinQty": noofDecimalinQty,
    "CompanyLogo": companyLogo,
  };
}
