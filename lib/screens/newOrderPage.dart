import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimist_erp_app/screens/settlement_page.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:optimist_erp_app/screens/qr_scan.dart';
import 'package:firebase_database/firebase_database.dart';

class NewOrderPage extends StatefulWidget {
  @override
  NewOrderPageState createState() => NewOrderPageState();
}

class NewOrderPageState extends State<NewOrderPage> {
  int _radioValue1 = 0;
  int _radioValue2 = 0;
  List<String> itemList = [];
  String label = "Enter Customer Name";
  var textEditingController = TextEditingController();
  var saleRate = TextEditingController();
  var saleQty = TextEditingController();
  var depoStock = TextEditingController();
  var unitController = TextEditingController();
  double totalAmount = 0;
  List<String> itemname=[];
  List<String> units=[];
  List<String> totalamount=[];
  List<String> quantity=[];
  double totalBill=0;

  DatabaseReference items;
  String unit = "";
  String rate = "";
  String stock = "";

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue2 = value;
    });
  }

  Future<List> fetchData() async {
    List _list = new List();
    String _inputText = textEditingController.text;
    await items.orderByChild("ItemID").once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        List<dynamic> value = snapshot.value;
        for (int i = 0; i < value.length; i++) {
          if (value[i] != null) {
            //itemList.add(value[i]["ItemName"].toString());
            if (value[i]["ItemName"]
                .toString()
                .toLowerCase()
                .contains(_inputText.toLowerCase())) {
              _list.add(value[i]["ItemName"].toString());
              setState(() {
                unit = value[i]["SaleUnit"].toString();
                rate = value[i]["RateAndStock"]["PCS"]["Rate"];
                stock = value[i]["TotalStock"].toString();
                saleRate.text = rate;
                totalAmount = double.parse(rate);
                unitController.text = unit;
                depoStock.text = "10";
              });
            }
          }
        }
      }
    });
    return _list;
  }

  void calculteAmount(String a) {

    setState(() {
      totalAmount=double.parse(saleQty.text)*double.parse(rate);
    });
  }

  void addItem(String name,String unit,String total,String qty){
    setState(() {
      itemname.add(name);
      units.add(unit);
      totalamount.add(total);
      quantity.add(qty);
      totalBill=totalBill+double.parse(total);
    });


  }

  void initState() {
    // TODO: implement initState

    items = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child("CYBRIX")
        .child("Items");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(
                    "Scan",
                    style: TextStyle(fontSize: 10),
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
                  Text(
                    "Add Customer",
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showBookingDialog();
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
                    Text(
                      "Add item",
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            Column(
              children: [
                Text(
                  'Order Date : DD/MM/YYYY',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xff868383),
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Delivery Date : DD/MM/YYYY',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xff868383),
                  ),
                  textAlign: TextAlign.left,
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
                            quantity[i].toString()+"  "+units[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: const Color(0xff5b5b5b),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Pinned.fromPins(
                          Pin(size: 87.0, end: 29.0),
                          Pin(size: 14.0, middle: 0.5625),
                          child: Text(
                            '[45.50]    330.00',
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
                            totalamount[i].toString(),
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
                        // controller: _username,
                        maxLines: 1,
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
                        // controller: _username,
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
                    child: Center(child: Text(totalBill.toString())),
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
                    child: Center(child: Text("0.00")),
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SettlementPage();
                                }));
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
                      Container(
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

  void showBookingDialog() {
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
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Search by   ',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  width: 200,
                                  height: 40,
                                  child: Row(
                                    children: [
                                      Radio(
                                        activeColor: Colors.green,
                                        value: 0,
                                        groupValue: _radioValue2,
                                        onChanged: _handleRadioValueChange1,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _radioValue2 = 0;
                                          });
                                        },
                                        child: Text(
                                          "Name",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Radio(
                                        activeColor: Colors.green,
                                        value: 1,
                                        groupValue: _radioValue2,
                                        onChanged: _handleRadioValueChange1,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _radioValue2 = 1;
                                          });
                                        },
                                        child: Text(
                                          "Code",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                                      return fetchData();
                                    },

                                    minStringLength: 1,
                                    // getSelectedValue: (value) {
                                    //   print(value); // this prints the selected option which could be an object
                                    // },
                                    decoration: InputDecoration(
                                      hintText: 'Enter item name here',
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
                                  "Tax :    0.00",
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
                                  padding: EdgeInsets.all(15),
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
                                  child: Text(
                                    'By Percentage',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 10,
                                      color: const Color(0x8cb0b0b0),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
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
                                  padding: EdgeInsets.all(15),
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
                                  child: Text(
                                    'By Price',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 10,
                                      color: const Color(0x8cb0b0b0),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
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
                                  child: Center(child: Text("0.00")),
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
                                addItem(textEditingController.text, unit, totalAmount.toString(),saleQty.text);
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
      centerTitle: false,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Container(
            height: 18,
            width: 40,
            child: Image.asset(
              'assets/images/print.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Container(
            height: 15,
            width: 25,
            child: Image.asset(
              'assets/images/pdf.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Container(
            height: 15,
            width: 35,
            child: Image.asset(
              'assets/images/calender.png',
              fit: BoxFit.fill,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
      ],
      elevation: 1.0,
      titleSpacing: 0,
      toolbarHeight: 70,
    );
  }
}
