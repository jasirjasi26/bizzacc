import 'package:adobe_xd/page_link.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:optimist_erp_app/screens/home.dart';
import 'package:optimist_erp_app/screens/product.dart';
import 'package:textfield_search/textfield_search.dart';
import '../screens/newOrderPage.dart';

class BottomBar extends StatefulWidget {
  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  List<String> _locations = []; // Option 2
  String _selectedLocation; // Opt
  var _children = [MyHomePage(), ProductPage(), Container(), Container()];
  DatabaseReference reference;
  DatabaseReference types;
  DatabaseReference names;
  String label = "Enter Customer Name";
  List<String> dummyList = [];
  var textEditingController = TextEditingController();

  void onTapped(int i) {
    if (i != 3) {
      setState(() {
        _currentIndex = i;
      });
    }
  }


  Future<void> getSalesTypes() async {
    await names.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        dummyList.add(values["Name"].toString());
      });
    });

    await types.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        _locations.add(values["Name"].toString());
      });
    });
  }

  void addValues() {
    Map<String, String> values = {
      'Address': "address",
      'ArabicName': "...",
      'Balance': "10000",
      'CustomerCode': "...",
      'CustomerId': "...",
      'EmployeeMobile': "...",
      'GSTNO': "...",
      'MobileNo': "...",
      'Name': "...",
      'TRNNO': "...",
      'VATNO': "...",
    };

    Map<String, String> details = {
      'Address': "",
      'CodeBasedBarcode': "Disabled",
      'CompanyName': "",
      'CreateNewCustomer': "Disabled",
      'CurrencyIcon': "U+0024",
      'DecimalPoint': "2",
      'DiasablePrinterButton': "Disabled",
      'FreeIssue': "Disabled",
      'GSTNO': "",
      'ItemWiseDiscount': "Disabled",
      'LastUpdate': "1/27/2022 1:09:11 AM",
      'PhoneNumber': "",
      'PrinterType': "0",
      'SalesReturn': "Disabled",
      'SubEndDate': "00010101",
      'TRNNO': "",
    };
    reference.child("Customers").child("11").set(values);
    reference.child("Details").set(details);
  }

  void initState() {
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    reference = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child("Cybrix Mobile");

    types = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child("CYBRIX")
        .child("SalesTypes");

    names = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child("CYBRIX")
        .child("Customers");


    getSalesTypes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          showBookingDialog(textEditingController);
        },
        child: Container(
          width: 80,
          height: 80,
          child: Stack(
            children: <Widget>[
              Pinned.fromPins(
                Pin(start: 0.0, end: 0.0),
                Pin(start: 0.0, end: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                    gradient: LinearGradient(
                      begin: Alignment(-2.74, -2.92),
                      end: Alignment(0.73, 0.78),
                      colors: [
                        const Color(0xffffffff),
                        const Color(0xff1f3877)
                      ],
                      stops: [0.0, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(6, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
              Pinned.fromPins(
                Pin(size: 18.6, middle: 0.4153),
                Pin(size: 24.2, middle: 0.3096),
                child:
                    // Adobe XD layer: 'surface1' (group)
                    Stack(
                  children: <Widget>[
                    Pinned.fromPins(
                      Pin(start: 0.0, end: 0.0),
                      Pin(start: 0.0, end: 0.0),
                      child: Image.asset(
                        'assets/images/new.png',
                        //color: Colors.blue,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ],
                ),
              ),
              Pinned.fromPins(
                Pin(size: 16.0, middle: 0.6667),
                Pin(size: 16.0, middle: 0.5926),
                child: Stack(
                  children: <Widget>[
                    Pinned.fromPins(
                      Pin(start: 0.0, end: 0.0),
                      Pin(start: 0.0, end: 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.elliptical(9999.0, 9999.0)),
                          color: const Color(0xff1d336c),
                        ),
                      ),
                    ),
                    Pinned.fromPins(
                      Pin(size: 31.0, middle: 0.4571),
                      Pin(size: 78.0, middle: 0.8039),
                      child: Stack(
                        children: <Widget>[
                          Pinned.fromPins(
                            Pin(start: 0.0, end: 0.0),
                            Pin(start: 0.0, end: 0.0),
                            child: Image.asset(
                              'assets/images/add.png',
                              //color: Colors.transparent,
                              fit: BoxFit.cover,
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Pinned.fromPins(
                Pin(size: 31.0, middle: 0.4571),
                Pin(size: 8.0, middle: 0.8039),
                child: Text(
                  'New Order',
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 8,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTapped,
            currentIndex: _currentIndex,
            backgroundColor: Colors.white.withOpacity(0.9),
            fixedColor: Theme.of(context).accentColor,
            unselectedItemColor: Color.fromRGBO(153, 153, 153, 1),
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/images/home_icon.png",
                    color: _currentIndex == 0
                        ? Colors.cyan[800]
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 14,
                        color: _currentIndex == 0
                            ? Colors.cyan[800]
                            : Color.fromRGBO(153, 153, 153, 1),
                      ),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/images/product_icon.png",
                    color: _currentIndex == 1
                        ? Colors.cyan[800]
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Product",
                      style: TextStyle(
                        fontSize: 14,
                        color: _currentIndex == 1
                            ? Colors.cyan[800]
                            : Color.fromRGBO(153, 153, 153, 1),
                      ),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/images/inventory_icon.png",
                    color: _currentIndex == 2
                        ? Colors.cyan[800]
                        : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Inventory",
                      style: TextStyle(
                        fontSize: 14,
                        color: _currentIndex == 2
                            ? Colors.cyan[800]
                            : Color.fromRGBO(153, 153, 153, 1),
                      ),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/images/inventory_icon.png",
                    color: Colors.white,
                    height: 0,
                  ),
                  title: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Text(
                      "",
                      style: TextStyle(
                        fontSize: 0,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void showBookingDialog(TextEditingController textEditingController) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Material(
                type: MaterialType.transparency,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width,
                      //margin: EdgeInsets.only(bottom: 200,),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 30.0, top: 25, bottom: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context,true);
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
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 50.0, right: 50),
                            child: Card(
                              child: TextFieldSearch(
                                  initialList: dummyList,
                                  label: label,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Customer Name',
                                    contentPadding: EdgeInsets.only(
                                        left: 15, top: 15, right: 15),
                                    filled: false,
                                    prefixIcon: Icon(
                                      Icons.person,
                                      size: 25.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  controller: textEditingController),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 50.0, right: 50, bottom: 5),
                            child: Text(
                              " Select Sales Type",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 50.0, right: 50, bottom: 20),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, top: 10),
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButton(
                                    isDense: true,
                                    //itemHeight: 50,
                                    iconSize: 35,
                                    isExpanded: true,
                                    hint: Text('Please choose sales type'),
                                    value: _selectedLocation,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedLocation = newValue;
                                      });
                                    },
                                    items: _locations.map((location) {
                                      return DropdownMenuItem(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0, left: 0),
                                          child: new Text(location),
                                        ),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 50.0, right: 50, bottom: 25),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                      hintText: 'Enter Refer No',
                                      filled: false,
                                      contentPadding: EdgeInsets.only(
                                          left: 15, top: 15, right: 15),
                                      prefixIcon: Icon(
                                        Icons.perm_contact_calendar,
                                        size: 25.0,
                                        color: Colors.white,
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                //addValues();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return NewOrderPage();
                                }));
                              },
                              child: Container(
                                height: 45,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Color(0xfffb4ce5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset(
                                            "assets/images/save.png",
                                            color: Colors.white,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        " Save",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              height: 45,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Color(0xfffaa731),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        child: Image.asset(
                                          "assets/images/addcustomer.png",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "  Add New Customer",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(
                                height: 100,
                                width: 100,
                                child: Image.asset(
                                  "assets/images/scan_blue.png",
                                  //color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Scan",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )),
                ));
          },
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
