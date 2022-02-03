import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:optimist_erp_app/data/customed_details.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/screens/settlement_page.dart';
import 'package:optimist_erp_app/screens/van_page.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:optimist_erp_app/screens/qr_scan.dart';
import 'package:firebase_database/firebase_database.dart';

class NewOrderPage extends StatefulWidget {
  NewOrderPage({Key key, this.customerName, this.salesType, this.refNo,this.balance})
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

  int _radioValue1 = 0;

  List<String> itemList = [];
  String label = "Enter Customer Name";
  var saleRate = TextEditingController();
  var saleQty = TextEditingController();
  var depoStock = TextEditingController();
  var unitController = TextEditingController();
  var byPercentage = TextEditingController();
  var byPrice = TextEditingController();

  double totalAmount = 0;
  List<String> itemname = [];
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
  double discountedBill=0;

  DatabaseReference reference;
  DatabaseReference names;
  DatabaseReference items;
  String unit = "";
  String rate = "";
  String stock = "";
  String code;
  String totalStock = "";
  String itemId = "";
  String customerId = "";
  double tax = 0;
  double vat = 0;
  double cess = 0;
  double gst = 0;
  int dicPer=0;
  int dicPri=0;


  DateTime selectedDate = DateTime.now();
  String from = "Select a date";
  String today=DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();

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

  Future<List> fetchData(String input) async {
    List _list = new List();

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
                  saleQty.text = "1";
                  code =value[i]["Code"].toString();

                  if (value[i]["AdditionalTaxInclusive"].toString() !=
                      "Disabled") {
                    tax = tax + double.parse(value[i]["AdditionalTax"].toString());

                  }
                  if (value[i]["GSTInclusive"].toString() != "Disabled") {
                    tax = tax + double.parse(value[i]["GST"].toString());
                    gst=double.parse(value[i]["GST"].toString());
                  }
                  if (value[i]["VATInclusive"].toString() != "Disabled") {
                    tax = tax + double.parse(value[i]["VAT"].toString());
                    vat=double.parse(value[i]["VAT"].toString());
                  }

                  saleRate.text = rate;
                  totalAmount = double.parse(rate);
                  unitController.text = unit;
                  depoStock.text = totalStock;
                });
              }
            } finally {
              if (value[i]["ItemID"].toString().contains(input)) {
                _list.add(value[i]["ItemName"].toString() +
                    "  [" +
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
                  saleQty.text = "1";
                  code =value[i]["Code"].toString();
                  if (value[i]["AdditionalTaxInclusive"].toString() !=
                      "Disabled") {
                    tax = tax + double.parse(value[i]["AdditionalTax"].toString());
                  }
                  if (value[i]["GSTInclusive"].toString() != "Disabled") {
                    tax = tax + double.parse(value[i]["GST"].toString());
                    gst=double.parse(value[i]["GST"].toString());
                  }
                  if (value[i]["VATInclusive"].toString() != "Disabled") {
                    tax = tax + double.parse(value[i]["VAT"].toString());
                    vat=double.parse(value[i]["VAT"].toString());
                  }
                  totalAmount = double.parse(rate);
                  unitController.text = unit;
                  depoStock.text = totalStock;
                });
              }
            }
          }
        }
      }
    });
    return _list;
  }

  void addItem(String name, String unit, String discountedAmount, int qty, String id,String tax,String vat,String gst,String rate,String code, String total) {

    double discount=double.parse(total)-double.parse(discountedAmount);

    setState(() {
      itemname.add(name);
      itemIds.add(id);
      units.add(unit);
      totalamount.add(total);
      allDiscounts.add(discount.toString());
      discountAmount.add(discount);
      discountedFinalRate.add(discountedAmount);
      quantity.add(qty);
      totalBill = totalBill + double.parse(total)-double.parse(tax);
      taxTotal.add(tax);
      vatTotal.add(vat);
      gstTotal.add(gst);
      rateList.add(rate);
      codeList.add(code);
      discountedBill=totalBill;
    });
  }




  void discounts(String a){
    setState(() {
      discountedBill=totalBill;
    });
    if(byPercentage.text.isNotEmpty){
      setState(() {
        discountedBill=totalBill-totalBill/100*double.parse(byPercentage.text);
      });
    }
    if(byPrice.text.isNotEmpty){
      setState(() {
        discountedBill=totalBill-double.parse(byPrice.text);
      });
    }

  }



  Future<void> getCustomerId() async {
    await names.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (widget.customerName == values["Name"]) {
          customerId = values["CustomerID"];
          setState(() {
            Customer.balance=values["Balance"].toString();
          });
        }
      });
    });

    await reference.child("VANLIST").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (User.vanNo.toString() == key.toString()) {
            User.voucherNumber=User.voucherStarting+(int.parse(values.toString())+1).toString();
        }
      });
    });
  }



  void addtoInvoiceValues() {
     double disc=discountAmount.reduce((a, b) => a + b);

    Map<String, dynamic> values = {
      'Amount': discountedBill-disc,
      'ArabicName': "",
      'Balance': Customer.balance,
      'BillAmount': totalBill.toString(),
      'CardReceived': 0,
      'CashReceived': 0,
      'CustomerID': customerId,
      'CustomerName': widget.customerName,
      'DeliveryDate': from,
      'OldBalance': Customer.balance,
      'OrderID': User.voucherNumber,
      'Qty': quantity.reduce((a, b) => a + b),
      'RefNo': "",
      'RoundOff': "",
      'SalesType': widget.salesType,
      'SettledBy': User.number,
      'TaxAmount': tax,
      'TotalCESS': 0,
      'TotalGST': 0,
      'TotalReceived': 0,
      'TotalVAT': 0,
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
        'DiscPercentage': "",
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
      return SettlementPage(customerName: widget.customerName,date: today,values: values,itemCount: itemname.length.toString(),radioValue: _radioValue1,);
    }));
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
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          homeData()
        ],
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
                        begin: Alignment(0.0, -2.15),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xffffffff),
                          const Color(0xff22bef1)
                        ],
                        stops: [0.0, 1.0],
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/addprson.png',
                        fit: BoxFit.scaleDown,
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "Add Customer",
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
                  onTap:_selectDate,
                  child: Text(
                    'Delivery Date : ' + from,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: Colors.blueAccent,
                        decoration: TextDecoration.underline
                    ),
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
                          Pin(size: 17.0, start: 13.0),
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
                          Pin(size: 47.0, start: 12.0),
                          Pin(size: 14.0, middle: 0.565),
                          child: Text(
                            quantity[i].toString() + "  " + units[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: const Color(0xff5b5b5b),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(size: 70.0, end: 29.0),
                          Pin(size: 14.0, middle: 0.5625),
                          child: Text(
                            '['+allDiscounts[i].toString()+']   ' + totalamount[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: const Color(0xff182d66),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(size: 37.0, end: 29.0),
                          Pin(size: 14.0, end: 13.0),
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
                  SizedBox(
                    width: 20,
                  ),
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
                        controller: byPercentage,
                        maxLines: 1,
                        onChanged: discounts,
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
                      onChanged: discounts,
                        controller: byPrice,
                        maxLines: 1,
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
                    child: Center(child: Text(discountedBill.toString())),
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
                      _radioValue1 == 0
                          ? GestureDetector(
                              onTap: () {
                                // addtoOrders();

                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) {
                                //   return SettlementPage();
                                // }));
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
                            )
                          : Container(),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (totalBill > 0) {
                            if(from!="Select a date"){
                              addtoInvoiceValues();
                            }else{
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

  Future<void> showBookingDialog(BuildContext context) {
    var textEditingController = TextEditingController();
    var byPer = TextEditingController();
    var byPri = TextEditingController();
    double lastSaleRate=0;

    void calculteAmount(String a) {
      if (tax > 0) {
        setState(() {
          totalAmount = double.parse(saleQty.text) * double.parse(rate) + tax;

        });
      } else {
        setState(() {
          totalAmount = double.parse(saleQty.text) * double.parse(rate);
        });
      }
    }

    void discount(String a){
      setState(() {
        lastSaleRate=totalAmount;
      });

      if(byPer.text.isNotEmpty){
        setState(() {
          lastSaleRate=totalAmount-totalAmount/100*double.parse(byPer.text);
        });
      }
      if(byPri.text.isNotEmpty){
        setState(() {
          lastSaleRate=totalAmount-double.parse(byPri.text);
        });
      }

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
                                      controller: depoStock,
                                      decoration: InputDecoration(
                                        hintText: '',
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
                                  child: TextFormField(
                                      controller: unitController,
                                      decoration: InputDecoration(
                                        hintText: '',
                                        //filled: true,
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
                                  "Total Stock  " + stock,
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
                                      onChanged: discount,
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
                                      onChanged: discount,
                                      controller: byPri,
                                      maxLines: 1,
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
                                      child: Text(totalAmount.toString())),
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
                                  'Last Sales Rate   ',
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
                                  child: Center(child: Text(lastSaleRate.toString())),
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
                                if(byPri.text.isEmpty&&byPer.text.isEmpty){
                                  addItem(
                                      textEditingController.text,
                                      unit,
                                      totalAmount.toString(),
                                      int.parse(saleQty.text),
                                      itemId,tax.toString(),vat.toString(),gst.toString(),rate,code,totalAmount.toString());
                                }else{
                                  addItem(
                                      textEditingController.text,
                                      unit,
                                      lastSaleRate.toString(),
                                      int.parse(saleQty.text),
                                      itemId,tax.toString(),vat.toString(),gst.toString(),rate,code,totalAmount.toString());
                                }

                                Navigator.pop(context);
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[900],
      centerTitle: true,
      title: Text("New Order"),
      elevation: 1.0,
      titleSpacing: 0,
      toolbarHeight: 70,
    );
  }
}
