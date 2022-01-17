import 'package:adobe_xd/page_link.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:optimist_erp_app/screens/home.dart';

import '../main_drawer.dart';
import 'newOrderPage.dart';

class BottomBar extends StatefulWidget {
  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  var _children = [
    MyHomePage(),
    MyHomePage(),
    MyHomePage(),
  ];

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
      floatingActionButton: GestureDetector(
        onTap: () {
          showBookingDialog();
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
            ],
          ),
        ),
      ),
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
                              onTap: (){
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
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, right: 50),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 5,
                              child: Container(
                                child: TextFormField(
                                    // controller: _username,
                                    decoration: InputDecoration(
                                  hintText: 'Enter Customer Name',
                                  //filled: true,
                                  filled: false,
                                  prefixIcon: Icon(
                                    Icons.person,
                                    size: 25.0,
                                    color: Colors.grey,
                                  ),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 50.0, right: 50, bottom: 5),
                        child: Text(
                          "Select Sales Type",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, bottom: 20),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 5,
                              child: Container(
                                child: TextFormField(
                                    decoration: InputDecoration(
                                  hintText: '[None]',
                                  filled: false,
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
                      SizedBox(height: 20,),
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

                      SizedBox(height: 20,),
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
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
