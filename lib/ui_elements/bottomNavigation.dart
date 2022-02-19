import 'package:adobe_xd/page_link.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/screens/home.dart';
import 'package:optimist_erp_app/screens/all_products.dart';
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
  var _children = [MyHomePage(), Container()];
  String label = "Enter Customer Name";

  void onTapped(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  void initState() {
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _children[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
          onTap: () {
            showBookingDialog();
          },
          child: Card(
            elevation: 10,
            color: const Color(0xff20474f),
            child: Container(
                width: 90,
                height: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: const Color(0xff20474f),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/add.png',
                    //color: Colors.transparent,
                    fit: BoxFit.cover,
                    height: 20,
                    width: 20,
                  ),
                )),
          )),
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
                    "assets/images/home.png",
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
                    "assets/images/inventory.png",
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
            ],
          ),
        ),
      ),
    );
  }

  void showBookingDialog() {
    var textEditingController = TextEditingController();
    Future<List> getNames(String input) async {
      List _list = new List();
      //
      // await names.once().then((DataSnapshot snapshot) {
      //   Map<dynamic, dynamic> values = snapshot.value;
      //   values.forEach((key, values) {
      //     if(values['Name'].toString().toLowerCase().contains(input.toLowerCase())){
      //       _list.add(values['Name'].toString());
      //     }
      //     if(values['CustomerCode'].toString().toLowerCase().contains(input.toLowerCase())){
      //       _list.add(values['CustomerCode'].toString());
      //     }
      //   });
      // });

      return _list;
    }

    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
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
                      height: MediaQuery.of(context).size.height * 0.65,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        //borderRadius: BorderRadius.circular(40),
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
                                    Navigator.pop(context, true);
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
                          Center(
                            child: Container(
                              height: 45,
                              width: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xff20474f),
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
                                          fontSize: 16,
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
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 50.0, right: 50),
                            child: Card(
                              elevation: 5,
                              child: TextFieldSearch(
                                  // future: getNames,
                                  // initialList: dummyList,
                                  label: label,
                                  minStringLength: 0,
                                  future: () {
                                    return getNames(textEditingController.text);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter Customer Name / Code',
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
                                    hint: Text('Choose sales type'),
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
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    // if (textEditingController.text.isNotEmpty &&
                                    //     _selectedLocation.isNotEmpty) {
                                    //   Navigator.push(context,
                                    //       MaterialPageRoute(builder: (context) {
                                    //     return NewOrderPage(
                                    //       customerName:
                                    //           textEditingController.text,
                                    //       refNo: "0",
                                    //       salesType: _selectedLocation,
                                    //     );
                                    //   }));
                                    // }
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return NewOrderPage(
                                            customerName:
                                            textEditingController.text,
                                            refNo: "0",
                                            salesType: _selectedLocation,
                                          );
                                        }));
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment(0.0, -1.0),
                                        end: Alignment(0.0, 1.0),
                                        colors: [
                                          const Color(0xff00ecb2),
                                          const Color(0xff12b3e3)
                                        ],
                                        stops: [0.0, 1.0],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xffcdcdcd),
                                          offset: Offset(6, 3),
                                          blurRadius: 6,
                                        ),
                                      ],
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
                                width: 15,
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 45,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment(0.0, -1.0),
                                        end: Alignment(0.0, 1.0),
                                        colors: [
                                          const Color(0xff00ecb2),
                                          const Color(0xff12b3e3)
                                        ],
                                        stops: [0.0, 1.0],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xffcdcdcd),
                                          offset: Offset(6, 3),
                                          blurRadius: 6,
                                        ),
                                      ],
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
                                            "Cancel",
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
                              Spacer(),
                            ],
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
