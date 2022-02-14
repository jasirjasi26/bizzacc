import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:optimist_erp_app/data/customed_details.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/screens/returns/sales_settlement.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:optimist_erp_app/screens/qr_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class SalesReturn extends StatefulWidget {
  SalesReturn(
      {Key key, this.customerName, this.salesType, this.refNo, this.balance})
      : super(key: key);

  final String customerName;
  final String balance;
  final String salesType;
  final String refNo;

  @override
  SalesReturnState createState() => SalesReturnState();
}

class SalesReturnState extends State<SalesReturn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _screenshotController = ScreenshotController();
  final pdf = pw.Document();
  int _radioValue1 = 0;
  List<String> itemList = [];
  List<String> unitlist = [""];
  String _selectedUnit = "";
  String label = "Enter Customer Name";
  var saleRate = TextEditingController();
  var saleQty = TextEditingController();
  var depoStock = TextEditingController();
  var unitController = TextEditingController();
  var byPercentage = TextEditingController();
  var byPrice = TextEditingController();

  double totalAmount = 0;
  List<String> itemname = [];
  List<String> percentages = [];
  List<String> itemIds = [];
  List<String> units = [];
  List<String> totalamount = [];
  List<double> discountAmount = [];
  List<String> discountedFinalRate = [];
  List<int> quantity = [];
  List<String> discount = [];
  List<String> taxTotal = [];
  List<String> vatTotal = [];
  List<String> gstTotal = [];
  List<String> rateList = [];
  List<String> codeList = [];
  List<String> allDiscounts = [];
  double totalBill = 0;
  double discountedBill = 0;
  double disc = 0;

  DatabaseReference reference;
  DatabaseReference names;
  DatabaseReference items;
  String unit = "";
  String rate = "";
  String stock = "";
  String code;
  String totalStock = "";
  double lastSaleRate = 0;
  String itemId = "";
  String customerId = "";
  double tax = 0;
  double vat = 0;
  double cess = 0;
  double gst = 0;
  int dicPer = 0;
  int dicPri = 0;

  DateTime selectedDate = DateTime.now();
  String from = "Select a date";
  String today = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString();

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        from = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue1 = value;
    });
  }


  takeUnit(String cunit){
    reference
        .child("Items")
        .child(itemId)
        .child("RateAndStock").child(cunit)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if(key.toString()=="Rate"){
          setState(() {
            rate=values.toString();
            saleRate.text=values.toString();
          });
        }
        if(key.toString()=="Stock"){
          int d=int.parse(User.vanNo);
          setState(() {
            stock=values[d].toString();
          });
        }
      });
    });
  }

  Future<List> fetchData(String input) async {
    List _list = new List();
    unitlist.clear();

    await items.once().then((DataSnapshot snapshot) async {
      if (snapshot.value != null) {
        List<dynamic> value = snapshot.value;
        for (int i = 0; i < value.length; i++) {
          if (value[i] != null) {
            try {
              var value = double.parse(input);
            } on FormatException {
              if (value[i]["ItemName"]
                  .toString()
                  .toLowerCase()
                  .contains(input.toLowerCase())) {
                _list.add(value[i]["ItemName"].toString());
                setState(() {
                  itemId = value[i]["ItemID"].toString();
                  unit = value[i]["SaleUnit"].toString();
                  rate = value[i]["RateAndStock"][unit]["Rate"];
                  totalStock = value[i]["TotalStock"].toString();

                  stock = value[i]["RateAndStock"][unit]["Stock"]
                  [int.parse(User.vanNo)]
                      .toString();

                  code = value[i]["Code"].toString();
                  if (value[i]["VATInclusive"].toString() == "Disabled") {
                    //tax = tax + double.parse(value[i]["VAT"].toString());
                    vat = double.parse(value[i]["VAT"].toString());
                  }
                  saleRate.text = rate;
                  if (saleQty.text.toString() == "0") {
                    totalAmount = double.parse(rate) * 1;
                    lastSaleRate = totalAmount;
                  } else {
                    totalAmount =
                        double.parse(rate) * double.parse(saleQty.text);
                    lastSaleRate = totalAmount;
                  }
                  unitController.text = unit;
                  depoStock.text = totalStock;
                });
                items
                    .child(itemId)
                    .child("RateAndStock")
                    .once()
                    .then((DataSnapshot snapshot) {
                  Map<dynamic, dynamic> values = snapshot.value;
                  values.forEach((key, values) {
                    setState(() {
                      unitlist.add(key.toString());
                    });

                  });
                });
              }
            } finally {
              if (value[i]["ItemID"].toString().contains(input)) {
                _list.add(value[i]["ItemName"].toString() +
                    " [ID : " +
                    value[i]["ItemID"].toString() +
                    "]");
                setState(() {
                  itemId = value[i]["ItemID"].toString();
                  unit = value[i]["SaleUnit"].toString();
                  totalStock = value[i]["TotalStock"].toString();
                  rate = value[i]["RateAndStock"][unit]["Rate"];
                  stock = value[i]["RateAndStock"][unit]["Stock"]
                  [int.parse(User.vanNo)]
                      .toString();



                  saleRate.text = rate;
                  code = value[i]["Code"].toString();

                  if (value[i]["VATInclusive"].toString() == "Disabled") {
                    // tax = tax + double.parse(value[i]["VAT"].toString());
                    vat = double.parse(value[i]["VAT"].toString());
                  }
                  if (saleQty.text.toString() == "0") {
                    totalAmount = double.parse(rate) * 1;
                  } else {
                    totalAmount =
                        double.parse(rate) * double.parse(saleQty.text);
                  }

                  unitController.text = unit;
                  depoStock.text = totalStock;
                });
                items
                    .child(itemId)
                    .child("RateAndStock")
                    .once()
                    .then((DataSnapshot snapshot) {
                  Map<dynamic, dynamic> values = snapshot.value;
                  values.forEach((key, values) {
                    setState(() {
                      unitlist.add(key.toString());
                    });

                  });
                });
              }
            }
          }
        }
      }
    });
    return _list;
  }

  Future<List> fetchData2(String input, int edititem) async {
    List _list = new List();
    unitlist.clear();

    await items.once().then((DataSnapshot snapshot) async {
      if (snapshot.value != null) {
        List<dynamic> value = snapshot.value;
        for (int i = 0; i < value.length; i++) {
          if (value[i] != null) {
            if (value[i]["ItemName"]
                .toString()
                .toLowerCase()
                .contains(input.toLowerCase()) &&
                value[i]["ItemID"].toString() == itemIds[edititem]) {
              _list.add(value[i]["ItemName"].toString());
              setState(() {
                itemId = value[i]["ItemID"].toString();
                unit = value[i]["SaleUnit"].toString();
                rate = value[i]["RateAndStock"][unit]["Rate"];
                totalStock = value[i]["TotalStock"].toString();
                stock = value[i]["RateAndStock"][unit]["Stock"]
                [int.parse(User.vanNo)]
                    .toString();

                code = value[i]["Code"].toString();
                if (value[i]["VATInclusive"].toString() == "Disabled") {
                  // tax = tax + double.parse(value[i]["VAT"].toString());
                  vat = double.parse(value[i]["VAT"].toString());
                }

                saleRate.text = rate;
                if (saleQty.text.toString() == "0") {
                  totalAmount = double.parse(rate) * 1;
                  lastSaleRate = totalAmount;
                } else {
                  totalAmount = double.parse(rate) * double.parse(saleQty.text);
                  lastSaleRate = totalAmount;
                }
                unitController.text = unit;
                depoStock.text = totalStock;
                items
                    .child(itemId)
                    .child("RateAndStock")
                    .once()
                    .then((DataSnapshot snapshot) {
                  Map<dynamic, dynamic> values = snapshot.value;
                  values.forEach((key, values) {
                    setState(() {
                      unitlist.add(key.toString());
                    });

                  });
                });
              });
            }

            if (value[i]["ItemID"].toString().contains(input)) {
              _list.add(value[i]["ItemName"].toString() +
                  " [ID : " +
                  value[i]["ItemID"].toString() +
                  "]");
              setState(() {
                itemId = value[i]["ItemID"].toString();
                unit = value[i]["SaleUnit"].toString();
                totalStock = value[i]["TotalStock"].toString();
                rate = value[i]["RateAndStock"][unit]["Rate"];
                stock = value[i]["RateAndStock"][unit]["Stock"]
                [int.parse(User.vanNo)]
                    .toString();
                saleRate.text = rate;
                code = value[i]["Code"].toString();
                if (value[i]["VATInclusive"].toString() == "Disabled") {
                  // tax = tax + double.parse(value[i]["VAT"].toString());
                  vat = double.parse(value[i]["VAT"].toString());
                }

                if (saleQty.text.toString() == "0") {
                  totalAmount = double.parse(rate) * 1;
                } else {
                  totalAmount = double.parse(rate) * double.parse(saleQty.text);
                }

                unitController.text = unit;
                depoStock.text = totalStock;

                items
                    .child(itemId)
                    .child("RateAndStock")
                    .once()
                    .then((DataSnapshot snapshot) {
                  Map<dynamic, dynamic> values = snapshot.value;
                  values.forEach((key, values) {
                    setState(() {
                      unitlist.add(key.toString());
                    });

                  });
                });
              });
            }
          }
        }
      }
    });
    return _list;
  }

  void addItem(
      String name,
      String unit,
      String discountedAmount,
      int qty,
      String id,
      String tax,
      String vat,
      String gst,
      String rate,
      String code,
      String total,
      String percentage) {
    double discount = double.parse(total) - double.parse(discountedAmount);

    setState(() {
      percentages.add(percentage);
      itemname.add(name.replaceAll("[ID : " + id + "]", ""));
      itemIds.add(id);
      units.add(unit);
      totalamount.add(total);
      allDiscounts.add(discount.toStringAsFixed(2));
      discountAmount.add(double.parse(discount.toStringAsFixed(2)));
      discountedFinalRate.add(discountedAmount);
      quantity.add(qty);
      totalBill = totalBill + double.parse(total);
      taxTotal.add(tax);
      vatTotal.add(vat);
      gstTotal.add(gst);
      rateList.add(rate);
      codeList.add(code);
      discountedBill = totalBill;
      disc = discountAmount.reduce((a, b) => a + b);
    });
  }

  void deleteItem(int index) {
    print(index);
    setState(() {
      itemname.removeAt(index);
      itemIds.removeAt(index);
      units.removeAt(index);
      percentages.removeAt(index);
      totalBill = totalBill - double.parse(totalamount[index]);
      totalamount.removeAt(index);
      allDiscounts.removeAt(index);
      discountAmount.removeAt(index);
      discountedFinalRate.removeAt(index);
      quantity.removeAt(index);
      taxTotal.removeAt(index);
      vatTotal.removeAt(index);
      gstTotal.removeAt(index);
      rateList.removeAt(index);
      codeList.removeAt(index);
      if (totalamount.length > 0) {
        double val = 0;
        for (int i = 0; i < totalamount.length; i++) {
          val = val + double.parse(totalamount[i]);
        }
        //String val = totalamount.reduce((a, b) => a + b);
        discountedBill = val;
        disc = discountAmount.reduce((a, b) => a + b);
      } else {
        String val = "0";
        totalBill = 0;
        discountedBill = double.parse(val);
        disc = 0;
      }
    });
    print(itemname);
  }

  void editItem(int index, int quantity) {
    String tempName;
    setState(() {
      tempName = itemname[index];
    });
    showBookingDialog2(_scaffoldKey.currentContext, tempName, index, quantity);
  }

  void discountPrice(String a) {
    setState(() {
      discountedBill = totalBill;
    });

    setState(() {
      discountedBill = totalBill - double.parse(byPrice.text);
      double a = (totalBill - discountedBill) / (totalBill) * 100;
      double b = (a);
      byPercentage.text = b.toStringAsFixed(2);
    });
  }

  void discountPer(String a) {
    setState(() {
      discountedBill = totalBill;
    });
    setState(() {
      discountedBill =
          totalBill - totalBill / 100 * double.parse(byPercentage.text);
      double d = totalBill - discountedBill;
      byPrice.text = d.toStringAsFixed(2);
    });
  }

  Future<void> getCustomerId() async {
    await names.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (widget.customerName == values["Name"]) {
          setState(() {
            customerId = values["CustomerID"];
            Customer.balance = values["Balance"].toString();
            Customer.CustomerName = values["Name"].toString();
          });
        } else {
          if (widget.customerName == values["CustomerCode"]) {
            setState(() {
              customerId = values["CustomerID"];
              Customer.balance = values["Balance"].toString();
              Customer.CustomerName = values["Name"].toString();
            });
          }
        }
      });
    });

    await reference
        .child("Vouchers")
        .child(User.vanNo)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          if (key.toString() == "VoucherNumber") {
            User.voucherNumber = User.voucherStarting +
                (int.parse(values.toString()) + 1).toString();
          }
          if (key.toString() == "OrderNumber") {
            User.orderNumber = User.orderStarting +
                (int.parse(values.toString()) + 1).toString();
          }
        });
      });
    });

    print(User.orderNumber);
    print(User.voucherNumber);
  }

  void addtoInvoiceValues() {
    double d = (totalBill - discountedBill) + disc;
    Map<String, dynamic> values = {
      'Amount': discountedBill - disc,
      'ArabicName': "",
      'Balance': Customer.balance,
      'BillAmount': totalBill.toString(),
      'TotalDiscount': d.toStringAsFixed(2),
      'CardReceived': 0,
      'CashReceived': 0,
      'CustomerID': customerId,
      'CustomerName': Customer.CustomerName,
      'DeliveryDate': from,
      'OldBalance': Customer.balance,
      'OrderID': "",
      'Qty': quantity.reduce((a, b) => a + b),
      'RefNo': "",
      'RoundOff': "",
      'SalesType': widget.salesType,
      'SettledBy': User.number,
      'TaxAmount': taxTotal.reduce((a, b) => a + b),
      'TotalCESS': 0,
      'TotalGST': 0,
      'TotalReceived': 0,
      'TotalVAT': taxTotal.reduce((a, b) => a + b),
      'UpdatedBy': User.number,
      'UpdatedTime': DateTime.now().toString(),
      'VoucherDate': today,
    };

    for (int i = 0; i < itemname.length; i++) {
      Map<String, dynamic> itemValues = {
        'ArabicName': "",
        'CESSAmount': "0",
        'Code': codeList[i],
        'DiscAmount': discountAmount[i],
        'DiscPercentage': percentages[i],
        'GSTAmount': gstTotal[i],
        'InclusiveRate': "",
        'ItemID': itemIds[i],
        'ItemName': itemname[i],
        'Qty': quantity[i],
        'Rate': rateList[i],
        'TaxAmount': taxTotal[i],
        'Total': totalamount[i],
        'Unit': units[i],
        'UpdatedBy': User.number,
        'UpdatedTime': DateTime.now().toString(),
        'VATAmount': vatTotal[i],
      };

      ///then add item details
      reference
          .child("Returns")
          .child(today)
          .child(User.vanNo)
          .child(User.voucherNumber)
          .child("Items")
          .child(i.toString())
          .set(itemValues);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SalesSettlementPage(
        customerName: Customer.CustomerName,
        date: today,
        values: values,
        itemCount: itemIds.length,
        radioValue: _radioValue1,
      );
    }));
  }

  void initState() {
    // TODO: implement initState

    reference = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child(User.database);

    items = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child(User.database)
        .child("Items");

    names = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child(User.database)
        .child("Customers");
    getCustomerId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Screenshot(
        controller: _screenshotController,
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            homeData()
          ],
        ),
      ),
    );
  }

  homeData() {
    return Column(
      children: [
        Row(
          children: [
            Spacer(),
            Text(
              'Customer Name :  ' + Customer.CustomerName,
              style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 13,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Spacer(),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -2.03),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xfffafafa),
                          const Color(0xff845cfd)
                        ],
                        stops: [0.0, 1.0],
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/scanimage.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "Scan",
                      style: TextStyle(fontSize: 10),
                    ),
                  )
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     children: [
            //       Container(
            //         height: 50,
            //         width: 50,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(8.0),
            //           gradient: LinearGradient(
            //             begin: Alignment(0.0, -2.15),
            //             end: Alignment(0.0, 1.0),
            //             colors: [
            //               const Color(0xffffffff),
            //               const Color(0xff22bef1)
            //             ],
            //             stops: [0.0, 1.0],
            //           ),
            //         ),
            //         child: Center(
            //           child: Image.asset(
            //             'assets/images/addprson.png',
            //             fit: BoxFit.scaleDown,
            //             height: 25,
            //             width: 25,
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(2.0),
            //         child: Text(
            //           "Add Customer",
            //           style: TextStyle(fontSize: 10),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                showBookingDialog(_scaffoldKey.currentContext, "", 0, 0);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -1.62),
                          end: Alignment(0.0, 1.0),
                          colors: [
                            const Color(0xffffffff),
                            const Color(0xff388e3c)
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/additem.png',
                          fit: BoxFit.scaleDown,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Add item",
                        style: TextStyle(fontSize: 10),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Order Date : ' + today,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: _selectDate,
                  child: Text(
                    'Delivery Date : ' + from,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              itemCount: itemname.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        Pinned.fromPins(
                          Pin(start: 0.0, end: 0.0),
                          Pin(start: 0.0, end: 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: const Color(0xffffffff),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(6, 3),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(size: 146.0, start: 12.0),
                          Pin(size: 35.0, start: 13.0),
                          child: Text(
                            itemname[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 15,
                              color: const Color(0xff182d66),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(size: 147.0, start: 12.0),
                          Pin(size: 14.0, middle: 0.565),
                          child: Text(
                            quantity[i].toString() +
                                "  " +
                                units[i].toString() +
                                ",  Rate : " +
                                rateList[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: const Color(0xff5b5b5b),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Pinned.fromPins(Pin(size: 50.0, end: 40.0),
                            Pin(size: 14.0, middle: 0.1625),
                            child: GestureDetector(
                              onTap: () {
                                editItem(i, quantity[i]);
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.green,
                                size: 18,
                              ),
                            )),
                        Pinned.fromPins(Pin(size: 50.0, end: 10.0),
                            Pin(size: 14.0, middle: 0.1625),
                            child: GestureDetector(
                              onTap: () {
                                deleteItem(i);
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 18,
                              ),
                            )),
                        Pinned.fromPins(
                          Pin(size: 120.0, end: 20.0),
                          Pin(size: 25.0, middle: 0.5625),
                          child: Text(
                            "Discount " +
                                '[' +
                                allDiscounts[i].toString() +
                                ']   ' +
                                totalamount[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: const Color(0xff182d66),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(size: 60.0, end: 18.0),
                          Pin(size: 25.0, end: 13.0),
                          child: Text(
                            discountedFinalRate[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: const Color(0xff182d66),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),

        ///after container
        ///
        ///sss
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Discount',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/percentage.png',
                      fit: BoxFit.scaleDown,
                      height: 25,
                      width: 25,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 30,
                    padding: EdgeInsets.only(bottom: 7, left: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xffffffff),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(6, 3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: TextFormField(
                        controller: byPercentage,
                        maxLines: 1,
                        onChanged: discountPer,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'By Percentage',
                          hintStyle: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 10,
                            color: const Color(0x8cb0b0b0),
                          ),
                          //filled: true,
                          border: InputBorder.none,
                          filled: false,
                          isDense: false,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/dollar.png',
                      fit: BoxFit.scaleDown,
                      height: 25,
                      width: 25,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 30,
                    padding: EdgeInsets.only(bottom: 7, left: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xffffffff),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(6, 3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: TextFormField(
                        onChanged: discountPrice,
                        controller: byPrice,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'By Price',
                          hintStyle: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 10,
                            color: const Color(0x8cb0b0b0),
                          ),
                          //filled: true,
                          border: InputBorder.none,
                          filled: false,
                          isDense: false,
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    'Bill Amount   ',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -4.12),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xffffffff),
                          const Color(0xfffaa731)
                        ],
                        stops: [0.0, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xfffae7cb),
                          offset: Offset(6, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child:
                    Center(child: Text((discountedBill - disc).toString())),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    'Balance Amount   ',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -4.12),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xffffffff),
                          const Color(0xfffb4ce5)
                        ],
                        stops: [0.0, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xfffae7cb),
                          offset: Offset(6, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(child: Text(Customer.balance)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    'Confirmed   ',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    child: Row(
                      children: [
                        Radio(
                          activeColor: Colors.green,
                          value: 0,
                          groupValue: _radioValue1,
                          onChanged: _handleRadioValueChange,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _radioValue1 = 0;
                            });
                          },
                          child: Text(
                            "Yes",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                //height: 1.6,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Radio(
                          activeColor: Colors.green,
                          value: 1,
                          groupValue: _radioValue1,
                          onChanged: _handleRadioValueChange,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _radioValue1 = 1;
                            });
                          },
                          child: Text(
                            "No",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                //height: 1.6,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return QRViewExample();
                          }));
                    },
                    child: Center(
                      child: Image.asset(
                        'assets/images/approvalscan.png',
                        fit: BoxFit.scaleDown,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  Text(
                    "\nScan to Approve",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (totalBill > 0) {
                            if (from != "Select a date") {
                              addtoInvoiceValues();
                            } else {
                              FlutterFlexibleToast.showToast(
                                  message: "Please select date...",
                                  // toastLength: Toast.LENGTH_LONG,
                                  toastGravity: ToastGravity.BOTTOM,
                                  icon: ICON.ERROR,
                                  radius: 50,
                                  elevation: 10,
                                  imageSize: 15,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.black,
                                  timeInSeconds: 2);
                            }
                          } else {
                            FlutterFlexibleToast.showToast(
                                message: "Please add items",
                                // toastLength: Toast.LENGTH_LONG,
                                toastGravity: ToastGravity.BOTTOM,
                                icon: ICON.ERROR,
                                radius: 50,
                                elevation: 10,
                                imageSize: 20,
                                textColor: Colors.white,
                                backgroundColor: Colors.black,
                                timeInSeconds: 2);
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                              begin: Alignment(0.01, -0.72),
                              end: Alignment(0.0, 1.0),
                              colors: [
                                const Color(0xff385194),
                                const Color(0xff182d66)
                              ],
                              stops: [0.0, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x80182d66),
                                offset: Offset(6, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Generate Invoice',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 18,
                                color: const Color(0xfff7fdfd),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Future<void> showBookingDialog(
      BuildContext context, String tempName, int indexToDelete, int quantity) {
    var textEditingController = TextEditingController();
    var byPer = TextEditingController();
    var byPri = TextEditingController();

    setState(() {
      textEditingController.text = tempName;
      saleQty.text = "1";
    });

    if (textEditingController.text != "") {
      fetchData(textEditingController.text);
      saleQty.text = quantity.toString();
    }
    void calculteAmount(String a) {
      if (vat > 0) {
        setState(() {
          totalAmount = double.parse(saleQty.text) * double.parse(rate);
          double t = totalAmount * (vat / 100);
          tax = double.parse(t.toStringAsFixed(2));
          totalAmount = totalAmount + tax;
          lastSaleRate = totalAmount;
        });
      } else {
        setState(() {
          totalAmount = double.parse(saleQty.text) * double.parse(rate);
          lastSaleRate = totalAmount;
        });
      }
    }

    void disPri(String a) {
      setState(() {
        lastSaleRate = totalAmount;
      });
      setState(() {
        lastSaleRate = totalAmount - double.parse(byPri.text);
        double a = (totalAmount - lastSaleRate) / (totalAmount) * 100;
        byPer.text = a.toStringAsFixed(2);
      });
    }

    void disPer(String a) {
      setState(() {
        lastSaleRate = totalAmount;
      });
      setState(() {
        lastSaleRate =
            totalAmount - totalAmount / 100 * double.parse(byPer.text);
        double val = totalAmount - lastSaleRate;
        byPri.text = val.toStringAsFixed(2);
      });
    }

    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (context, setState) {
          return Material(
              type: MaterialType.transparency,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 30.0, top: 25, bottom: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    child: Image.asset(
                                      "assets/images/closebutton.png",
                                      color: Color.fromRGBO(153, 153, 153, 1),
                                      height: 20,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 50, bottom: 5),
                            child: Text(
                              "Add Item",
                              style:
                              TextStyle(color: Colors.black, fontSize: 22),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset("assets/images/item.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.8,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextFieldSearch(
                                    initialList: itemList,
                                    label: "",
                                    minStringLength: 0,
                                    future: () {
                                      return fetchData(
                                          textEditingController.text);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter Item Name or Id',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15, top: 5, right: 15),
                                      filled: false,
                                      isDense: false,
                                    ),
                                    controller: textEditingController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/weels.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: const Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x29000000),
                                          offset: Offset(6, 3),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18.0, left: 10),
                                      child: Text(stock),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/bucket.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: const Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x29000000),
                                          offset: Offset(6, 3),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: DropdownButton(
                                      isDense: true,
                                      iconSize: 35,
                                      isExpanded: true,
                                      hint: Text(unit),
                                      // value: unit==null ? "": unit,
                                      onChanged: (newValue) {
                                        setState(() {
                                          unit = newValue;
                                          takeUnit(unit);
                                        });
                                      },
                                      items: unitlist.map((location) {
                                        return DropdownMenuItem(
                                          child: Padding(
                                            padding:  EdgeInsets.only(
                                                top: 10, left: 8),
                                            child: new Text(location),
                                          ),
                                          value: location,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 50, bottom: 15, top: 20),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/stocks.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Total Stock  " + depoStock.text,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/dollar.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.35,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                      controller: saleRate,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Rate',
                                        //filled: true,
                                        hintStyle:
                                        TextStyle(color: Color(0xffb0b0b0)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            top: 15,
                                            right: 15),
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                // Adobe XD layer: 'surface1' (group)
                                GestureDetector(
                                    onTap: () {
                                      if (saleQty.text != "0") {
                                        setState(() {
                                          byPri.text = "";
                                          byPer.text = "";
                                          int a = int.parse(saleQty.text) - 1;
                                          saleQty.text = a.toString();
                                          calculteAmount("0");
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                    )),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.2,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                      controller: saleQty,
                                      onChanged: calculteAmount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Qty',
                                        //filled: true,
                                        hintStyle:
                                        TextStyle(color: Color(0xffb0b0b0)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            top: 15,
                                            right: 15),
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        byPri.text = "";
                                        byPer.text = "";
                                        int a = int.parse(saleQty.text) + 1;
                                        saleQty.text = a.toString();
                                        calculteAmount("0");
                                      });
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.green,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 50, bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/percentage.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Tax :  " +
                                      tax.toString() +
                                      "  (" +
                                      vat.toString() +
                                      "%)",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Discount',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 15,
                                    color: const Color(0xff5b5b5b),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Center(
                                  child: Image.asset(
                                    'assets/images/percentage.png',
                                    fit: BoxFit.scaleDown,
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 100,
                                  height: 30,
                                  padding: EdgeInsets.only(bottom: 7, left: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                      controller: byPer,
                                      maxLines: 1,
                                      onChanged: disPer,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'By Percentage',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 10,
                                          color: const Color(0x8cb0b0b0),
                                        ),
                                        //filled: true,
                                        border: InputBorder.none,
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Center(
                                  child: Image.asset(
                                    'assets/images/dollar.png',
                                    fit: BoxFit.scaleDown,
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 100,
                                  height: 30,
                                  padding: EdgeInsets.only(bottom: 5, left: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                      onChanged: disPri,
                                      controller: byPri,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'By Price',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 10,
                                          color: const Color(0x8cb0b0b0),
                                        ),
                                        //filled: true,
                                        border: InputBorder.none,
                                        filled: false,
                                        isDense: false,
                                      )),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Spacer(),
                                Text(
                                  'Total Amount   ',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 14,
                                    color: const Color(0xff5b5b5b),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  width: 150,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    gradient: LinearGradient(
                                      begin: Alignment(0.0, -4.12),
                                      end: Alignment(0.0, 1.0),
                                      colors: [
                                        const Color(0xffffffff),
                                        const Color(0xfffaa731)
                                      ],
                                      stops: [0.0, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xfffae7cb),
                                        offset: Offset(6, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: Text(lastSaleRate.toString())),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                if (textEditingController.text.isNotEmpty &&
                                    saleQty.text != "0" &&
                                    lastSaleRate > 0) {
                                  if (byPri.text.isEmpty &&
                                      byPer.text.isEmpty) {
                                    addItem(
                                        textEditingController.text,
                                        unit,
                                        totalAmount.toString(),
                                        int.parse(saleQty.text),
                                        itemId,
                                        tax.toString(),
                                        vat.toString(),
                                        gst.toString(),
                                        rate,
                                        code,
                                        totalAmount.toString(),
                                        "0");
                                  } else {
                                    addItem(
                                        textEditingController.text,
                                        unit,
                                        lastSaleRate.toString(),
                                        int.parse(saleQty.text),
                                        itemId,
                                        tax.toString(),
                                        vat.toString(),
                                        gst.toString(),
                                        rate,
                                        code,
                                        totalAmount.toString(),
                                        byPer.text);
                                  }

                                  if (tempName != "") {
                                    deleteItem(indexToDelete);
                                  }

                                  setState(() {
                                    unit = "";
                                    textEditingController.text = "";
                                    rate = "";
                                    saleQty.text = "";
                                    saleRate.text = "";
                                    unitController.text = "";
                                    totalAmount = 0.0;
                                    tax = 0;
                                    vat = 0;
                                    depoStock.text = "";
                                    lastSaleRate = 0;
                                  });

                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  gradient: LinearGradient(
                                    begin: Alignment(0.01, -0.72),
                                    end: Alignment(0.0, 1.0),
                                    colors: [
                                      const Color(0xff385194),
                                      const Color(0xff182d66)
                                    ],
                                    stops: [0.0, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x80182d66),
                                      offset: Offset(6, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 18,
                                      color: const Color(0xfff7fdfd),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )),
              ));
        });
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<void> showBookingDialog2(
      BuildContext context, String tempName, int indexToDelete, int quantity) {
    var textEditingController = TextEditingController();
    var byPer = TextEditingController();
    var byPri = TextEditingController();

    setState(() {
      textEditingController.text = tempName;
      saleQty.text = "1";
    });

    if (textEditingController.text != "") {
      fetchData2(textEditingController.text, indexToDelete);
      saleQty.text = quantity.toString();
    }
    void calculteAmount(String a) {
      if (vat > 0) {
        setState(() {
          totalAmount = double.parse(saleQty.text) * double.parse(rate);
          double t = totalAmount * (vat / 100);
          tax = double.parse(t.toStringAsFixed(2));
          totalAmount = totalAmount + tax;
          lastSaleRate = totalAmount;
        });
      } else {
        setState(() {
          totalAmount = double.parse(saleQty.text) * double.parse(rate);
          lastSaleRate = totalAmount;
        });
      }
    }

    void disPri(String a) {
      setState(() {
        lastSaleRate = totalAmount;
      });
      setState(() {
        lastSaleRate = totalAmount - double.parse(byPri.text);
        double a = (totalAmount - lastSaleRate) / (totalAmount) * 100;
        byPer.text = a.toStringAsFixed(2);
      });
    }

    void disPer(String a) {
      setState(() {
        lastSaleRate = totalAmount;
      });
      setState(() {
        lastSaleRate =
            totalAmount - totalAmount / 100 * double.parse(byPer.text);
        double val = totalAmount - lastSaleRate;
        byPri.text = val.toStringAsFixed(2);
      });
    }

    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (context, setState) {
          return Material(
              type: MaterialType.transparency,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.85,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 30.0, top: 25, bottom: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    child: Image.asset(
                                      "assets/images/closebutton.png",
                                      color: Color.fromRGBO(153, 153, 153, 1),
                                      height: 20,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 50, bottom: 5),
                            child: Text(
                              "Add Item",
                              style:
                              TextStyle(color: Colors.black, fontSize: 22),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset("assets/images/item.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.8,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextFieldSearch(
                                    initialList: itemList,
                                    label: "",
                                    minStringLength: 0,
                                    future: () {
                                      return fetchData(
                                          textEditingController.text);
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter Item Name or Id',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15, top: 5, right: 15),
                                      filled: false,
                                      isDense: false,
                                    ),
                                    controller: textEditingController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/weels.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: const Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x29000000),
                                          offset: Offset(6, 3),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18.0, left: 10),
                                      child: Text(stock),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/bucket.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.35,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: DropdownButton(
                                    isDense: true,
                                    iconSize: 35,
                                    isExpanded: true,
                                    hint: Text(unit),
                                    // value: unit==null ? "": unit,
                                    onChanged: (newValue) {
                                      setState(() {
                                        unit = newValue;
                                        takeUnit(unit);
                                      });
                                    },
                                    items: unitlist.map((location) {
                                      return DropdownMenuItem(
                                        child: Padding(
                                          padding:  EdgeInsets.only(
                                              top: 10, left: 8),
                                          child: new Text(location),
                                        ),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 50, bottom: 15, top: 20),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/stocks.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Total Stock  " + depoStock.text,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/dollar.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.35,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                      controller: saleRate,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Rate',
                                        //filled: true,
                                        hintStyle:
                                        TextStyle(color: Color(0xffb0b0b0)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            top: 15,
                                            right: 15),
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                // Adobe XD layer: 'surface1' (group)
                                GestureDetector(
                                    onTap: () {
                                      if (saleQty.text != "0") {
                                        setState(() {
                                          byPri.text = "";
                                          byPer.text = "";
                                          int a = int.parse(saleQty.text) - 1;
                                          saleQty.text = a.toString();
                                          calculteAmount("0");
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.red,
                                    )),
                                Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.2,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                      controller: saleQty,
                                      onChanged: calculteAmount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Qty',
                                        //filled: true,
                                        hintStyle:
                                        TextStyle(color: Color(0xffb0b0b0)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            top: 15,
                                            right: 15),
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        byPri.text = "";
                                        byPer.text = "";
                                        int a = int.parse(saleQty.text) + 1;
                                        saleQty.text = a.toString();
                                        calculteAmount("0");
                                      });
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.green,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 50, bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/percentage.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Tax :  " + tax.toString(),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Discount',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 15,
                                    color: const Color(0xff5b5b5b),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Center(
                                  child: Image.asset(
                                    'assets/images/percentage.png',
                                    fit: BoxFit.scaleDown,
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 100,
                                  height: 30,
                                  padding: EdgeInsets.only(bottom: 7, left: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                      controller: byPer,
                                      maxLines: 1,
                                      onChanged: disPer,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'By Percentage',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 10,
                                          color: const Color(0x8cb0b0b0),
                                        ),
                                        //filled: true,
                                        border: InputBorder.none,
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Center(
                                  child: Image.asset(
                                    'assets/images/dollar.png',
                                    fit: BoxFit.scaleDown,
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 100,
                                  height: 30,
                                  padding: EdgeInsets.only(bottom: 5, left: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: const Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x29000000),
                                        offset: Offset(6, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                      onChanged: disPri,
                                      controller: byPri,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'By Price',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 10,
                                          color: const Color(0x8cb0b0b0),
                                        ),
                                        //filled: true,
                                        border: InputBorder.none,
                                        filled: false,
                                        isDense: false,
                                      )),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Spacer(),
                                Text(
                                  'Total Amount   ',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 14,
                                    color: const Color(0xff5b5b5b),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  width: 150,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    gradient: LinearGradient(
                                      begin: Alignment(0.0, -4.12),
                                      end: Alignment(0.0, 1.0),
                                      colors: [
                                        const Color(0xffffffff),
                                        const Color(0xfffaa731)
                                      ],
                                      stops: [0.0, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xfffae7cb),
                                        offset: Offset(6, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: Text(lastSaleRate.toString())),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                if (textEditingController.text.isNotEmpty &&
                                    saleQty.text != "0" &&
                                    lastSaleRate > 0) {
                                  if (byPri.text.isEmpty &&
                                      byPer.text.isEmpty) {
                                    addItem(
                                        textEditingController.text,
                                        unit,
                                        totalAmount.toString(),
                                        int.parse(saleQty.text),
                                        itemId,
                                        tax.toString(),
                                        vat.toString(),
                                        gst.toString(),
                                        rate,
                                        code,
                                        totalAmount.toString(),
                                        "0");
                                  } else {
                                    addItem(
                                        textEditingController.text,
                                        unit,
                                        lastSaleRate.toString(),
                                        int.parse(saleQty.text),
                                        itemId,
                                        tax.toString(),
                                        vat.toString(),
                                        gst.toString(),
                                        rate,
                                        code,
                                        totalAmount.toString(),
                                        byPer.text);
                                  }

                                  if (tempName != "") {
                                    deleteItem(indexToDelete);
                                  }

                                  setState(() {
                                    unit = "";
                                    textEditingController.text = "";
                                    rate = "";
                                    saleQty.text = "";
                                    saleRate.text = "";
                                    unitController.text = "";
                                    totalAmount = 0.0;
                                    depoStock.text = "";
                                    lastSaleRate = 0;
                                    unitlist.clear();
                                    unitlist.add("");
                                  });

                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  gradient: LinearGradient(
                                    begin: Alignment(0.01, -0.72),
                                    end: Alignment(0.0, 1.0),
                                    colors: [
                                      const Color(0xff385194),
                                      const Color(0xff182d66)
                                    ],
                                    stops: [0.0, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x80182d66),
                                      offset: Offset(6, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 18,
                                      color: const Color(0xfff7fdfd),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )),
              ));
        });
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  takeBillPdf() async {
    final imageFile = await _screenshotController.capture();

    final image = pw.MemoryImage(
      File(imageFile.path).readAsBytesSync(),
    );

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          ); // Center
        }));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/" + "Sample.pdf");
    await file.writeAsBytes(await pdf.save());
    Share.shareFiles([file.path], text: "Shared from Cybrix");
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[900],
      centerTitle: false,
      title: Text("Sales Returns"),
      elevation: 1.0,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: GestureDetector(
            onTap: () {
              takeBillPdf();
            },
            child: Container(
              height: 18,
              width: 40,
              child: Image.asset(
                'assets/images/print.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: GestureDetector(
            onTap: () {
              takeBillPdf();
            },
            child: Container(
              height: 15,
              width: 25,
              child: Image.asset(
                'assets/images/pdf.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
      ],
      titleSpacing: 0,
      toolbarHeight: 70,
    );
  }
}