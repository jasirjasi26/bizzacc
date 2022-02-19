import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optimist_erp_app/data/customed_details.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/screens/settlement_page.dart';
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

class NewOrderPage extends StatefulWidget {
  NewOrderPage(
      {Key key, this.customerName, this.salesType, this.refNo, this.balance})
      : super(key: key);

  final String customerName;
  final String balance;
  final String salesType;
  final String refNo;

  @override
  NewOrderPageState createState() => NewOrderPageState();
}

class NewOrderPageState extends State<NewOrderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String db = User.database;
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

  takeUnit(String cunit) {
    reference
        .child("Items")
        .child(itemId)
        .child("RateAndStock")
        .child(cunit)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (key.toString() == "Rate") {
          setState(() {
            rate = values.toString();
            saleRate.text = values.toString();
          });
        }
        if (key.toString() == "Stock") {
          int d = int.parse(User.vanNo);
          setState(() {
            stock = values[d].toString();
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
          .child("Bills")
          .child(today)
          .child(User.vanNo)
          .child(User.voucherNumber)
          .child("Items")
          .child(i.toString())
          .set(itemValues);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SettlementPage(
        customerName: Customer.CustomerName,
        date: today,
        values: values,
        itemCount: itemIds.length,
        radioValue: _radioValue1,
      );
    }));
  }

  void addtoOrders() {
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
      'OrderID': User.orderNumber,
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

    reference
        .child("OrderList")
        .child(today)
        .child(User.vanNo)
        .child(User.orderNumber)
        .set(values);

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
          .child("OrderList")
          .child(today)
          .child(User.vanNo)
          .child(User.orderNumber)
          .child("Items")
          .child(i.toString())
          .set(itemValues);
    }

    String lastVoucher = User.orderNumber.replaceAll(User.orderStarting, "");
    reference
      ..child("Vouchers")
          .child(User.vanNo)
          .child("OrderNumber")
          .remove()
          .whenComplete(() => {
                reference
                  ..child("Vouchers")
                      .child(User.vanNo)
                      .child("OrderNumber")
                      .set(lastVoucher.toString())
              });

    FlutterFlexibleToast.showToast(
        message: "Added to Order List",
        toastGravity: ToastGravity.BOTTOM,
        icon: ICON.SUCCESS,
        radius: 50,
        elevation: 10,
        imageSize: 15,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        timeInSeconds: 2);
  }

  void initState() {
    // TODO: implement initState
    reference = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child("CYBRIX");

    items = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child("CYBRIX")
        .child("Items");

    names = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child("CYBRIX")
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
            homeData(),
            SizedBox(
              height: 30,
            )
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Customer Name : ' + Customer.CustomerName,
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 13,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Spacer(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Order Date : ' + today,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: Colors.blueGrey,
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
                          color: Colors.blueGrey,
                          decoration: TextDecoration.underline),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  takeBillPdf();
                },
                child: Center(
                  child: Container(
                      height: 35,
                      width: 30,
                      child: // Adobe XD layer: 'surface1' (group)
                          Stack(
                        children: <Widget>[
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
                            Pin(size: 6.8, middle: 0.3704),
                            child: SvgPicture.string(
                              '<svg viewBox="4.0 11.2 24.8 6.8" ><path transform="translate(0.0, -3.79)" d="M 4 21.8271312713623 L 28.825927734375 21.8271312713623 L 28.825927734375 17.48259353637695 C 28.825927734375 16.11040115356445 27.71552467346191 15 26.34333419799805 15 L 6.482592582702637 15 C 5.110376834869385 15 4 16.11040115356445 4 17.48259353637695 L 4 21.8271312713623 Z" fill="#616161" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 3.1, end: 3.1),
                            Pin(size: 1.9, middle: 0.2),
                            child: SvgPicture.string(
                              '<svg viewBox="7.1 9.3 18.6 1.9" ><path transform="translate(-1.9, -2.66)" d="M 9 12 L 27.61944580078125 12 L 27.61944580078125 13.8619441986084 L 9 13.8619441986084 L 9 12 Z" fill="#424242" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
                            Pin(size: 7.4, middle: 0.7692),
                            child: SvgPicture.string(
                              '<svg viewBox="4.0 17.4 24.8 7.4" ><path transform="translate(0.0, -7.59)" d="M 6.482592582702637 32.44777679443359 L 26.34333419799805 32.44777679443359 C 27.71552467346191 32.44777679443359 28.825927734375 31.33737754821777 28.825927734375 29.96518516540527 L 28.825927734375 25 L 4 25 L 4 29.96518516540527 C 4 31.33737754821777 5.110376834869385 32.44777679443359 6.482592582702637 32.44777679443359" fill="#424242" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 1.2, end: 1.9),
                            Pin(size: 1.2, middle: 0.3611),
                            child: SvgPicture.string(
                              '<svg viewBox="25.7 13.1 1.2 1.2" ><path transform="translate(-13.28, -4.93)" d="M 39 18.62064743041992 C 39 18.96250152587891 39.2787971496582 19.24129676818848 39.62064743041992 19.24129676818848 C 39.96250152587891 19.24129676818848 40.24129867553711 18.96250152587891 40.24129867553711 18.62064743041992 C 40.24129867553711 18.27879524230957 39.96250152587891 18 39.62064743041992 18 C 39.2787971496582 18 39 18.27879524230957 39 18.62064743041992" fill="#00e676" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 3.1, end: 3.1),
                            Pin(size: 1.9, middle: 0.6857),
                            child: SvgPicture.string(
                              '<svg viewBox="7.1 19.9 18.6 1.9" ><path transform="translate(-1.9, -9.1)" d="M 26.68847274780273 30.86194610595703 L 9.930972099304199 30.86194610595703 C 9.417000770568848 30.86194610595703 9 30.44493103027344 9 29.93097305297852 C 9 29.41701507568359 9.417000770568848 29 9.930972099304199 29 L 26.68847274780273 29 C 27.20243072509766 29 27.61944580078125 29.41701507568359 27.61944580078125 29.93097305297852 C 27.61944580078125 30.44493103027344 27.20243072509766 30.86194610595703 26.68847274780273 30.86194610595703" fill="#242424" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 4.3, end: 4.3),
                            Pin(size: 6.2, start: 0.0),
                            child: SvgPicture.string(
                              '<svg viewBox="8.3 5.0 16.1 6.2" ><path transform="translate(-2.66, 0.0)" d="M 11 5 L 27.1368522644043 5 L 27.1368522644043 11.20648193359375 L 11 11.20648193359375 L 11 5 Z" fill="#90caf9" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 4.3, end: 4.3),
                            Pin(size: 6.8, end: 0.0),
                            child: SvgPicture.string(
                              '<svg viewBox="8.3 21.8 16.1 6.8" ><path transform="translate(-2.66, -10.24)" d="M 11 32 L 27.1368522644043 32 L 27.1368522644043 38.82712936401367 L 11 38.82712936401367 L 11 32 Z" fill="#90caf9" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(start: 4.3, end: 4.3),
                            Pin(size: 1.2, middle: 0.6944),
                            child: SvgPicture.string(
                              '<svg viewBox="8.3 20.5 16.1 1.2" ><path transform="translate(-2.66, -9.48)" d="M 11 30 L 27.1368522644043 30 L 27.1368522644043 31.24129676818848 L 11 31.24129676818848 L 11 30 Z" fill="#42a5f5" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 10.6, middle: 0.5217),
                            Pin(size: 1.2, middle: 0.8056),
                            child: SvgPicture.string(
                              '<svg viewBox="11.4 23.0 10.6 1.2" ><path transform="translate(-4.55, -11.0)" d="M 16 34 L 26.55101776123047 34 L 26.55101776123047 35.24129867553711 L 16 35.24129867553711 L 16 34 Z" fill="#1976d2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 8.1, middle: 0.4444),
                            Pin(size: 1.2, end: 1.9),
                            child: SvgPicture.string(
                              '<svg viewBox="11.4 25.5 8.1 1.2" ><path transform="translate(-4.55, -12.52)" d="M 16 38 L 24.06842803955078 38 L 24.06842803955078 39.24129486083984 L 16 39.24129486083984 L 16 38 Z" fill="#1976d2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  takeBillPdf();
                },
                child: Center(
                  child: Container(
                      height: 35,
                      width: 25,
                      child: // Adobe XD layer: 'surface1' (group)
                          Stack(
                        children: <Widget>[
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
                            Pin(start: 0.0, end: 0.0),
                            child: SvgPicture.string(
                              '<svg viewBox="8.0 3.0 16.8 22.0" ><path  d="M 24.76190567016602 25 L 8 25 L 8 3 L 19.5238094329834 3 L 24.76190567016602 8.238094329833984 L 24.76190567016602 25 Z" fill="#ff5722" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 5.0, end: 0.8),
                            Pin(size: 5.0, start: 0.8),
                            child: SvgPicture.string(
                              '<svg viewBox="19.0 3.8 5.0 5.0" ><path transform="translate(-10.0, -0.71)" d="M 33.97619247436523 9.476189613342285 L 29 9.476189613342285 L 29 4.5 L 33.97619247436523 9.476189613342285 Z" fill="#fbe9e7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 3.5, middle: 0.2286),
                            Pin(size: 5.2, middle: 0.6255),
                            child: SvgPicture.string(
                              '<svg viewBox="11.0 13.5 3.5 5.2" ><path transform="translate(-2.76, -9.55)" d="M 14.85250568389893 26.42709541320801 L 14.85250568389893 28.26042938232422 L 13.80080032348633 28.26042938232422 L 13.80080032348633 23.04689979553223 L 15.576828956604 23.04689979553223 C 16.09246635437012 23.04689979553223 16.50370788574219 23.20650482177734 16.81066131591797 23.5277042388916 C 17.11756134033203 23.84691429138184 17.27103805541992 24.26229667663574 17.27103805541992 24.77384757995605 C 17.27103805541992 25.28330612182617 17.11756134033203 25.68637466430664 16.81474685668945 25.98306083679199 C 16.51193237304688 26.27980041503906 16.09246635437012 26.42709541320801 15.55430507659912 26.42709541320801 L 14.85250568389893 26.42709541320801 Z M 14.85250568389893 25.54929542541504 L 15.576828956604 25.54929542541504 C 15.77734279632568 25.54929542541504 15.932861328125 25.48381996154785 16.04129028320312 25.35286712646484 C 16.15181541442871 25.22191429138184 16.20702362060547 25.03161430358887 16.20702362060547 24.77997589111328 C 16.20702362060547 24.52011299133301 16.14977264404297 24.31341934204102 16.03924942016602 24.1579532623291 C 15.92673397064209 24.00447654724121 15.77530002593994 23.92674255371094 15.58704280853271 23.9246997833252 L 14.85250568389893 23.9246997833252 L 14.85250568389893 25.54929542541504 Z" fill="#ffebee" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 3.4, middle: 0.5391),
                            Pin(size: 5.2, middle: 0.6255),
                            child: SvgPicture.string(
                              '<svg viewBox="15.2 13.5 3.4 5.2" ><path transform="translate(-6.56, -9.55)" d="M 21.76560020446777 28.26042938232422 L 21.76560020446777 23.04689979553223 L 23.14264297485352 23.04689979553223 C 23.75240898132324 23.04689979553223 24.23735237121582 23.23924446105957 24.59951400756836 23.62591934204102 C 24.95963287353516 24.01264762878418 25.14584732055664 24.5425853729248 25.15197563171387 25.21578598022461 L 25.15197563171387 26.06084823608398 C 25.15197563171387 26.74630546569824 24.97188949584961 27.28441429138184 24.60972785949707 27.67522811889648 C 24.24756622314453 28.06604194641113 23.7503662109375 28.26042938232422 23.11398887634277 28.26042938232422 L 21.76560020446777 28.26042938232422 Z M 22.81730461120605 23.9246997833252 L 22.81730461120605 27.38671493530273 L 23.1324291229248 27.38671493530273 C 23.48437690734863 27.38671493530273 23.72988510131836 27.29468154907227 23.87314796447754 27.10846710205078 C 24.016357421875 26.92429542541504 24.0920467376709 26.6050853729248 24.10027122497559 26.1508903503418 L 24.10027122497559 25.24648094177246 C 24.10027122497559 24.75949668884277 24.0306568145752 24.41985511779785 23.8956184387207 24.22751426696777 C 23.75853729248047 24.03516960144043 23.52732849121094 23.93491363525391 23.19994735717773 23.9246997833252 L 22.81730461120605 23.9246997833252 Z" fill="#ffebee" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Pinned.fromPins(
                            Pin(size: 2.9, middle: 0.8182),
                            Pin(size: 5.2, middle: 0.6255),
                            child: SvgPicture.string(
                              '<svg viewBox="19.4 13.5 2.9 5.2" ><path transform="translate(-10.32, -9.55)" d="M 32.36255264282227 26.1324520111084 L 30.72564697265625 26.1324520111084 L 30.72564697265625 28.26042938232422 L 29.67189979553223 28.26042938232422 L 29.67189979553223 23.04689979553223 L 32.55898284912109 23.04689979553223 L 32.55898284912109 23.9246997833252 L 30.72564697265625 23.9246997833252 L 30.72564697265625 25.26078033447266 L 32.36255264282227 25.26078033447266 L 32.36255264282227 26.1324520111084 Z" fill="#ffebee" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Color(0xff20474f),
          height: 35,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: Text(
                    'Item',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.13,
                  child: Text(
                    'Qty',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.13,
                  child: Text(
                    'Rate',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.13,
                  child: Text(
                    'Disc',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.13,
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              ],
            ),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              itemCount: itemname.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    height: 30,
                    color: i.floor().isEven ? Colors.blueGrey : Colors.blueGrey[900],
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(width: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.33,
                          child: Text(
                            itemname[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          child: Text(
                            quantity[i].toString() +" "+
                                units[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          child: Text(rateList[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color:Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          child: Text(
                            allDiscounts[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          child: Text(
                            discountedFinalRate[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: GestureDetector(
                            onTap: () {
                              deleteItem(i);
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        )
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
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xff00ecb2),
                          const Color(0xff22bef1)
                        ],
                        stops: [0.0, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x80747474),
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
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xff00ecb2),
                          const Color(0xff22bef1)
                        ],
                        stops: [0.0, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x80747474),
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
                        color: Colors.blueGrey,
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
                      GestureDetector(
                        onTap: () {
                          if (totalBill > 0) {
                            if (from != "Select a date") {
                              addtoOrders();
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
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: const Color(0xff20474f),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x85747474),
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
                      SizedBox(
                        width: 15,
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
                            color: const Color(0xff20474f),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x85747474),
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

  Future<void> showBookingDialog(BuildContext context) {
    var textEditingController = TextEditingController();
    var byPer = TextEditingController();
    var byPri = TextEditingController();

    setState(() {
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
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
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
                                            padding: EdgeInsets.only(
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
                                      color: Colors.blueGrey,
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
                                      color: Colors.blueGrey,
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
                                    gradient: LinearGradient(
                                      begin: Alignment(0.0, -1.0),
                                      end: Alignment(0.0, 1.0),
                                      colors: [
                                        const Color(0xff00ecb2),
                                        const Color(0xff22bef1)
                                      ],
                                      stops: [0.0, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x80747474),
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
                          Row(
                            children: [
                              Spacer(),
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
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: const Color(0xff20474f),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x85747474),
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

                              SizedBox(width: 15,),

                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: const Color(0xff20474f),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x85747474),
                                        offset: Offset(6, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
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
                              Spacer()
                            ],
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
                    height: MediaQuery.of(context).size.height * 0.75,
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
                                          padding:
                                              EdgeInsets.only(top: 10, left: 8),
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
                                    gradient: LinearGradient(
                                      begin: Alignment(0.0, -1.0),
                                      end: Alignment(0.0, 1.0),
                                      colors: [
                                        const Color(0xff00ecb2),
                                        const Color(0xff22bef1)
                                      ],
                                      stops: [0.0, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x80747474),
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
                                  color: const Color(0xff20474f),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x85747474),
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
      backgroundColor: Color(0xff20474f),
      centerTitle: false,
      title: Text("New Order"),
      elevation: 1.0,
      actions: [
        Column(
          children: [
            Spacer(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
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
                GestureDetector(
                  onTap: () {
                    showBookingDialog(_scaffoldKey.currentContext);
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
              ],
            ),
          ],
        ),
        SizedBox(
          width: 10,
        )
      ],
      titleSpacing: 0,
      toolbarHeight: 120,
    );
  }
}
