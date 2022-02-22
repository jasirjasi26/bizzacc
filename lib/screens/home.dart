import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/screens/mis_reports_page.dart';
import 'package:optimist_erp_app/screens/returns/sales_returns.dart';
import '../ui_elements/main_drawer.dart';
import 'dart:ui';
import 'package:adobe_xd/pinned.dart';
import 'all_products.dart';
import 'customers.dart';
import 'mis_reports/stock_reports.dart';
import 'orders.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DatabaseReference reference;
  String today = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString();
  int todaysPending = 0;
  int todaysOrders = 0;
  double totalSales = 0;
  double totalStocks = 0;
  DatabaseReference names;
  String label = "Enter Customer Name";
  List<String> _locations = []; // Option 2
  String _selectedLocation; //
  DatabaseReference types; // Opt

  Future<void> getSalesTypes() async {
    await types.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        _locations.add(values["Name"].toString());
      });
    });
  }

  Future<void> getOrders() async {
    setState(() {
      totalSales = 0;
      todaysPending = 0;
      totalStocks = 0;
      todaysOrders = 0;
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

    await reference.child("Stocks").once().then((DataSnapshot snapshot) {
      List<dynamic> values = snapshot.value;
      if (snapshot.value != null) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            setState(() {
              totalStocks =
                  totalStocks + double.parse(values[i]['Stock']['All']);
            });
          }
        }
      }
    });

    await reference
        .child("OrderList")
        .child(today)
        .child(User.vanNo)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        if (values.length > 0) {
          setState(() {
            todaysPending = values.length;
          });
        }
      }
    });

    await reference
        .child("Bills")
        .child(today)
        .child(User.vanNo)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (values != null) {
        if (values.length > 0) {
          setState(() {
            todaysOrders = values.length + todaysPending;
          });
        }
      } else {
        setState(() {
          todaysOrders = todaysPending;
        });
      }
    });

    await reference
        .child("SalesReport")
        .child(today)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          totalSales = totalSales + double.parse(values["GrandAmount"]);
        });
      });
    });

    print(User.orderNumber);
    print(User.voucherNumber);
  }

  void initState() {
    // TODO: implement initState
    reference = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child(User.database);

    types = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child(User.database)
        .child("SalesTypes");

    names = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child(User.database)
        .child("Customers");
    getOrders();
    getSalesTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(),
      appBar: buildAppBar(context),
      body: WillPopScope(
        onWillPop: () async {
          // You can do some work here.
          // Returning true allows the pop to happen, returning false prevents it.
          return false;
        },
        child: RefreshIndicator(
          onRefresh: getOrders,
          child: Stack(
            children: [
              ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                        height: 30,
                      ),
                      Text(
                        'Overview',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 24,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  homeRow(),
                  SizedBox(
                    height: 10,
                  ),
                  overViewBox()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  homeRow() {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: 140,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(start: 0.0, end: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color(0xffffffff),
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
                  Pin(size: 69.0, start: 14.0),
                  Pin(size: 70.0, start: 14.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        begin: Alignment(-1.28, -1.48),
                        end: Alignment(0.78, 1.0),
                        colors: [
                          const Color(0xffffffff),
                          const Color(0xff845cfd)
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
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'assets/images/in_stock.png',
                        color: Colors.white,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 78.0, end: 0.0),
                  Pin(size: 17.0, middle: 0.2718),
                  child: Text(
                    'Total Sales',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: const Color(0xff2a7980),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 42.0, end: 10.0),
                  Pin(size: 17.0, middle: 0.4951),
                  child: Text(
                    '24500',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: const Color(0xff5421ee),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 63.0, end: 0.0),
                  Pin(size: 9.0, end: 5.0),
                  child: Text(
                    'Tap to view',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff747474),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),

          ///
          Container(
            margin: EdgeInsets.all(10),
            height: 140,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(start: 0.0, end: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color(0xffffffff),
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
                  Pin(size: 69.0, start: 14.0),
                  Pin(size: 70.0, start: 14.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        begin: Alignment(-1.28, -1.48),
                        end: Alignment(0.78, 1.0),
                        colors: [
                          const Color(0xffffffff),
                          const Color(0xfffa4de7)
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
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'assets/images/order_list.png',
                        color: Colors.black,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 100.0, end: 0.0),
                  Pin(size: 17.0, middle: 0.2718),
                  child: Text(
                    'Pending Orders',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: const Color(0xff2a7980),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 32.0, end: 0.0),
                  Pin(size: 17.0, middle: 0.4951),
                  child: Text(
                    '24',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: const Color(0xff5421ee),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 63.0, end: 0.0),
                  Pin(size: 9.0, end: 5.0),
                  child: Text(
                    'Tap to view',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff747474),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.all(10),
            height: 140,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(start: 0.0, end: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color(0xffffffff),
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
                  Pin(size: 69.0, start: 14.0),
                  Pin(size: 70.0, start: 14.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        begin: Alignment(-1.28, -1.48),
                        end: Alignment(0.78, 1.0),
                        colors: [
                          const Color(0xffffffff),
                          const Color(0xff22bef1)
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
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'assets/images/order_list.png',
                        color: Colors.black,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 100.0, end: 0.0),
                  Pin(size: 17.0, middle: 0.2718),
                  child: Text(
                    'Available Stock',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: const Color(0xff2a7980),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 32.0, end: 0.0),
                  Pin(size: 17.0, middle: 0.4951),
                  child: Text(
                    '24',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: const Color(0xff5421ee),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 63.0, end: 0.0),
                  Pin(size: 9.0, end: 5.0),
                  child: Text(
                    'Tap to view',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff747474),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),

          ///
          ///
          ///
          Container(
            margin: EdgeInsets.all(10),
            height: 140,
            width: MediaQuery.of(context).size.width * 0.75,
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(start: 0.0, end: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: const Color(0xffffffff),
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
                  Pin(size: 69.0, start: 14.0),
                  Pin(size: 70.0, start: 14.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      gradient: LinearGradient(
                        begin: Alignment(-1.28, -1.48),
                        end: Alignment(0.78, 1.0),
                        colors: [
                          const Color(0xffffffff),
                          const Color(0xfff9a936)
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
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'assets/images/in_stock.png',
                        color: Colors.white,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 78.0, end: 0.0),
                  Pin(size: 17.0, middle: 0.2718),
                  child: Text(
                    'Todays Order',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: const Color(0xff2a7980),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 42.0, end: 10.0),
                  Pin(size: 17.0, middle: 0.4951),
                  child: Text(
                    '2',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: const Color(0xff5421ee),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 63.0, end: 0.0),
                  Pin(size: 9.0, end: 5.0),
                  child: Text(
                    'Tap to view',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff747474),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  overViewBox() {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CustomersList();
                }));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    height: MediaQuery.of(context).size.width / 3 - 10,
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Stack(
                                children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(start: 0.0, end: 0.0),
                                    child: SvgPicture.string(
                                      '<svg viewBox="0.0 1.0 30.9 29.7" ><path transform="translate(0.0, 0.0)" d="M 20.85044479370117 0.9843750596046448 C 18.71354484558105 0.9843750596046448 16.84546279907227 2.088226795196533 16.01992797851562 4.182702541351318 C 17.75589561462402 5.612052917480469 18.95410537719727 7.829175472259521 18.95410537719727 10.83410739898682 C 18.95410537719727 14.04189777374268 17.43985748291016 16.97136306762695 15.86897373199463 18.86299324035645 C 18.37383842468262 19.81110382080078 22.29392433166504 21.71215438842773 23.41665649414062 24.62278175354004 C 27.36041259765625 24.40577125549316 30.88415336608887 23.60861396789551 30.88415336608887 21.35373115539551 L 30.88415336608887 20.6083812713623 C 30.88415336608887 18.54212760925293 27.27539443969727 16.51379203796387 24.08181953430176 15.44286823272705 C 23.94028472900391 15.39577102661133 23.02514457702637 15.17404937744141 23.60069847106934 13.40028476715088 C 25.10081672668457 11.8341703414917 26.12911224365234 9.300973892211914 26.12911224365234 6.819682121276855 C 26.12911224365234 3.003380298614502 23.75636291503906 0.9843750596046448 20.85044479370117 0.9843750596046448 Z M 10.66581916809082 4.663870334625244 C 7.571268081665039 4.663870334625244 4.905993938446045 6.7772216796875 4.905993938446045 10.83410739898682 C 4.905993938446045 13.48518085479736 6.165515422821045 16.19763565063477 7.769392013549805 17.85812568664551 C 8.392082214355469 19.52332496643066 7.255207538604736 20.70740699768066 7.024067401885986 20.79701232910156 C 3.792716979980469 21.98109245300293 0 24.12270355224609 0 26.25972557067871 L 0 27.07571983337402 C 0 29.99105834960938 5.556978702545166 30.64208984375 10.70355701446533 30.64208984375 C 15.85955429077148 30.64208984375 21.36936187744141 29.99105834960938 21.36936187744141 27.07571983337402 L 21.36936187744141 26.25972557067871 C 21.36936187744141 24.0566463470459 17.55784225463867 21.93858337402344 14.16138553619385 20.79701232910156 C 14.00101280212402 20.74520492553711 13.0292329788208 19.70736885070801 13.6424674987793 17.82044792175293 L 13.60466957092285 17.82044792175293 C 15.19439220428467 16.15524673461914 16.57664489746094 13.47576141357422 16.57664489746094 10.83410739898682 C 16.57664489746094 6.7772216796875 13.75562286376953 4.663870334625244 10.66581916809082 4.663870334625244 Z" fill="#b500a1" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Text(
                          'Customers',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AllProductPage(
                    back: true,
                  );
                }));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    height: MediaQuery.of(context).size.width / 3 - 10,
                    child: Column(
                      children: [
                        // Adobe XD layer: 'surface1' (group
                        Container(
                          height: 70,
                          width: 70,
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SvgPicture.string(
                                '<svg viewBox="2.0 2.0 30.0 29.0" ><path  d="M 8 2 L 8 19.40000152587891 L 12.5 19.40000152587891 L 12.5 6.349999904632568 L 30.5 6.349999904632568 L 26 2 L 8 2 Z M 6.5 3.450000286102295 L 2 7.800000667572021 L 2 25.20000076293945 L 20 25.20000076293945 L 20 20.85000038146973 L 6.5 20.85000038146973 L 6.5 3.450000286102295 Z M 14 7.800000667572021 L 14 12.15000057220459 L 27.5 12.15000057220459 L 27.5 29.55000114440918 L 32 25.20000076293945 L 32 7.800000667572021 L 14 7.800000667572021 Z M 21.5 13.60000038146973 L 21.5 26.65000152587891 L 3.5 26.65000152587891 L 8 31.00000190734863 L 26 31.00000190734863 L 26 13.60000038146973 L 21.5 13.60000038146973 Z" fill="#22adda" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                allowDrawingOutsideViewBox: true,
                                fit: BoxFit.fill,
                              )),
                        ),
                        Text(
                          'Products',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return StockReports();
                    }));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    height: MediaQuery.of(context).size.width / 3 - 10,
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: // Adobe XD layer: 'surface1' (group)
                                  Stack(
                                children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(start: 0.0, end: 0.0),
                                    child: SvgPicture.string(
                                      '<svg viewBox="3.9 3.9 27.7 27.7" ><path transform="translate(0.0, 0.0)" d="M 29.09345054626465 3.949219703674316 C 27.70490074157715 3.949219703674316 26.5799674987793 5.074037075042725 26.5799674987793 6.462651252746582 C 26.5799674987793 6.602003574371338 26.59500312805176 6.746337413787842 26.61985015869141 6.890671253204346 L 22.4141902923584 10.38956928253174 C 22.14050674438477 10.29002094268799 21.84681701660156 10.23527050018311 21.54816055297852 10.23527050018311 C 21.06042289733887 10.23527050018311 20.5776538848877 10.37960529327393 20.16457939147949 10.65335273742676 L 16.51635360717773 8.821785926818848 C 16.4317512512207 7.497884750366211 15.33675956726074 6.462651252746582 14.00796699523926 6.462651252746582 C 12.61431980133057 6.462651252746582 11.48950290679932 7.587469100952148 11.48950290679932 8.976070404052734 C 11.48950290679932 9.030819892883301 11.49447154998779 9.085570335388184 11.49447154998779 9.14031982421875 L 7.572536468505859 11.75326061248779 C 7.229119300842285 11.58406925201416 6.850854873657227 11.48950290679932 6.462651252746582 11.48950290679932 C 5.074037075042725 11.48950290679932 3.949219703674316 12.61431980133057 3.949219703674316 14.00796699523926 C 3.949219703674316 15.39651870727539 5.074037075042725 16.52132225036621 6.462651252746582 16.52132225036621 C 7.851253509521484 16.52132225036621 8.976070404052734 15.39651870727539 8.976070404052734 14.00796699523926 C 8.976070404052734 13.95318031311035 8.971101760864258 13.89839172363281 8.966119766235352 13.84870052337646 L 12.89309978485107 11.22571849822998 C 13.24144840240479 11.39991760253906 13.61973857879639 11.48950290679932 14.00796699523926 11.48950290679932 C 14.49570465087891 11.48950290679932 14.97847557067871 11.34516906738281 15.39154815673828 11.07142066955566 L 19.03977394104004 12.90303802490234 C 19.12437629699707 14.22686386108398 20.2193660736084 15.2620964050293 21.54816055297852 15.2620964050293 C 22.94180679321289 15.2620964050293 24.06661415100098 14.13729190826416 24.06661415100098 12.74874114990234 C 24.06661415100098 12.6043815612793 24.05170631408691 12.46499156951904 24.0267333984375 12.320631980896 L 28.2274227142334 8.816803932189941 C 28.50620269775391 8.921321868896484 28.79976272583008 8.976070404052734 29.09345054626465 8.976070404052734 C 30.48200035095215 8.976070404052734 31.60693168640137 7.851253509521484 31.60693168640137 6.462651252746582 C 31.60693168640137 5.074037075042725 30.48200035095215 3.949219703674316 29.09345054626465 3.949219703674316 Z M 27.83919334411621 14.00796699523926 C 27.14237022399902 14.00796699523926 26.5799674987793 14.57036972045898 26.5799674987793 15.2620964050293 L 26.5799674987793 31.60693168640137 L 31.60693168640137 31.60693168640137 L 31.60693168640137 15.2620964050293 C 31.60693168640137 14.57036972045898 31.04440498352051 14.00796699523926 30.35267639160156 14.00796699523926 L 27.83919334411621 14.00796699523926 Z M 12.74874114990234 16.52132225036621 C 12.05688667297363 16.52132225036621 11.48950290679932 17.08372497558594 11.48950290679932 17.77557945251465 L 11.48950290679932 31.60693168640137 L 16.52132225036621 31.60693168640137 L 16.52132225036621 17.77557945251465 C 16.52132225036621 17.08372497558594 15.95395088195801 16.52132225036621 15.2620964050293 16.52132225036621 L 12.74874114990234 16.52132225036621 Z M 20.29390335083008 19.03480529785156 C 19.60217666625977 19.03480529785156 19.03480529785156 19.60217666625977 19.03480529785156 20.29390335083008 L 19.03480529785156 31.60693168640137 L 24.06661415100098 31.60693168640137 L 24.06661415100098 20.29390335083008 C 24.06661415100098 19.60217666625977 23.49924087524414 19.03480529785156 22.80738639831543 19.03480529785156 L 20.29390335083008 19.03480529785156 Z M 5.203438282012939 21.54816055297852 C 4.511634826660156 21.54816055297852 3.949219703674316 22.11553382873535 3.949219703674316 22.80738639831543 L 3.949219703674316 31.60693168640137 L 8.976070404052734 31.60693168640137 L 8.976070404052734 22.80738639831543 C 8.976070404052734 22.11553382873535 8.413667678833008 21.54816055297852 7.716870307922363 21.54816055297852 L 5.203438282012939 21.54816055297852 Z" fill="#845cfd" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Text(
                          'Stock',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return OrdersPage();
                }));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    height: MediaQuery.of(context).size.width / 3 - 10,
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 60,
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: // Adobe XD layer: 'surface1' (group)
                                  Stack(
                                children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(start: 0.0, end: 0.0),
                                    child: SvgPicture.string(
                                      '<svg viewBox="4.9 2.0 22.0 28.6" ><path  d="M 26.61136817932129 9.443850517272949 L 19.46242713928223 2.294841766357422 C 19.25344276428223 2.09021520614624 18.97479629516602 1.972659945487976 18.68299865722656 1.972659945487976 L 7.132285118103027 1.972659945487976 C 5.917566776275635 1.972659945487976 4.933589935302734 2.956625938415527 4.933589935302734 4.175702095031738 L 4.933589935302734 28.37006378173828 C 4.933589935302734 29.58908462524414 5.917566776275635 30.57303810119629 7.132285118103027 30.57303810119629 L 24.73485374450684 30.57303810119629 C 25.94964027404785 30.57303810119629 26.93359375 29.58908462524414 26.93359375 28.37006378173828 L 26.93359375 10.22318935394287 C 26.93359375 9.93148136138916 26.81600761413574 9.652834892272949 26.61136817932129 9.443850517272949 Z M 19.23159599304199 22.87115287780762 L 10.43250179290771 22.87115287780762 C 9.827315330505371 22.87115287780762 9.3353271484375 22.37917518615723 9.3353271484375 21.77395629882812 C 9.3353271484375 21.16439056396484 9.827315330505371 20.67241287231445 10.43250179290771 20.67241287231445 L 19.23159599304199 20.67241287231445 C 19.84116172790527 20.67241287231445 20.33313941955566 21.16439056396484 20.33313941955566 21.77395629882812 C 20.33313941955566 22.37917518615723 19.84116172790527 22.87115287780762 19.23159599304199 22.87115287780762 Z M 21.43468284606934 18.47367286682129 L 10.43250179290771 18.47367286682129 C 9.827315330505371 18.47367286682129 9.3353271484375 17.97735023498535 9.3353271484375 17.37224197387695 C 9.3353271484375 16.76702308654785 9.827315330505371 16.27069854736328 10.43250179290771 16.27069854736328 L 21.43468284606934 16.27069854736328 C 22.03990173339844 16.27069854736328 22.53187942504883 16.76702308654785 22.53187942504883 17.37224197387695 C 22.53187942504883 17.97735023498535 22.03990173339844 18.47367286682129 21.43468284606934 18.47367286682129 Z M 19.23159599304199 10.77177715301514 C 18.62648773193359 10.77177715301514 18.1343994140625 10.27978897094727 18.1343994140625 9.674602508544922 L 18.1343994140625 4.06685209274292 L 24.83940124511719 10.77177715301514 L 19.23159599304199 10.77177715301514 Z" fill="#f9a936" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Text(
                          'Orders',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MisPage();
                }));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    height: MediaQuery.of(context).size.width / 3 - 10,
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 60,
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: // Adobe XD layer: 'surface1' (group)
                                  Stack(
                                children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(start: 0.0, end: 0.0),
                                    child: SvgPicture.string(
                                      '<svg viewBox="6.9 2.0 22.0 30.0" ><path  d="M 21.24303817749023 1.984380006790161 L 6.945310115814209 1.984380006790161 L 6.945310115814209 31.9843807220459 L 28.94530868530273 31.9843807220459 L 28.94530868530273 10.20216274261475 L 21.24303817749023 1.984380006790161 Z M 16.72173690795898 27.42095565795898 C 13.68268871307373 27.42095565795898 11.22353649139404 24.79383087158203 11.22353649139404 21.55037689208984 C 11.22353649139404 18.30692291259766 13.68268871307373 15.67980003356934 16.72173690795898 15.67980003356934 L 16.72173690795898 21.55037689208984 L 22.22233581542969 21.55037689208984 C 22.22233581542969 24.79383087158203 19.76078033447266 27.42095565795898 16.72173690795898 27.42095565795898 Z M 19.16647338867188 18.94120216369629 L 19.16647338867188 13.07069110870361 C 22.20552062988281 13.07069110870361 24.66701507568359 15.69781303405762 24.66701507568359 18.94120216369629 L 19.16647338867188 18.94120216369629 Z M 20.99996948242188 10.46407985687256 L 20.99996948242188 3.548320055007935 L 27.47993087768555 10.46407985687256 L 20.99996948242188 10.46407985687256 Z" fill="#b500a1" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Text(
                          'MIS Reports',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3 - 10,
                  height: MediaQuery.of(context).size.width / 3 - 10,
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: // Adobe XD layer: 'surface1' (group)
                                // Adobe XD layer: 'surface1' (group)
                                Stack(
                              children: <Widget>[
                                Pinned.fromPins(
                                  Pin(start: 0.0, end: 0.0),
                                  Pin(start: 0.0, end: 0.0),
                                  child: SvgPicture.string(
                                    '<svg viewBox="6.9 2.0 23.0 29.3" ><path transform="translate(0.0, 0.0)" d="M 6.945309638977051 1.984379887580872 L 6.945309638977051 30.03549003601074 L 18.304931640625 30.03549003601074 L 18.19552230834961 30.47728538513184 C 18.0882682800293 30.7822437286377 18.24812698364258 31.149658203125 18.5699462890625 31.21211242675781 C 18.67510223388672 31.27210807800293 18.78235816955566 31.27210807800293 18.83706092834473 31.21211242675781 L 22.04028701782227 30.23477935791016 C 22.14754295349121 30.23477935791016 22.20224761962891 30.17478370666504 22.30740356445312 30.05227279663086 L 29.14502906799316 22.24350357055664 L 29.30488777160645 22.12585067749023 C 30.15878677368164 21.14857482910156 30.15878677368164 19.56132698059082 29.30488777160645 18.58645248413086 C 28.87791442871094 18.03659057617188 28.29323387145996 17.85648155212402 27.75900650024414 17.85648155212402 C 27.22477531433105 17.85648155212402 26.74099540710449 18.09898376464844 26.31407356262207 18.52639389038086 L 26.20891761779785 18.58645248413086 L 26.17526626586914 18.62247276306152 L 26.17526626586914 9.665912628173828 L 19.44489669799805 1.984379887580872 L 6.945309638977051 1.984379887580872 Z M 19.23033142089844 3.446722030639648 L 24.89224433898926 9.913212776184082 L 19.23033142089844 9.913212776184082 L 19.23033142089844 3.446722030639648 Z M 22.43565940856934 14.79010391235352 C 23.02669334411621 14.79010391235352 23.50411796569824 15.33516979217529 23.50411796569824 16.00994110107422 C 23.50411796569824 16.68465232849121 23.02669334411621 17.22978019714355 22.43565940856934 17.22978019714355 C 22.38100624084473 17.22978019714355 22.32840156555176 17.22012901306152 22.27585029602051 17.21053886413574 L 19.15462684631348 21.66721153259277 C 19.20297813415527 21.80410766601562 19.23033142089844 21.95053291320801 19.23033142089844 22.10906600952148 C 19.23033142089844 22.78377723693848 18.75290679931641 23.32884407043457 18.1618709564209 23.32884407043457 C 17.57089233398438 23.32884407043457 17.09346580505371 22.78377723693848 17.09346580505371 22.10906600952148 C 17.09346580505371 21.97456741333008 17.11656379699707 21.8497200012207 17.15231513977051 21.72966575622559 L 14.10684967041016 17.8156623840332 C 14.03534603118896 17.83244514465332 13.96174240112305 17.83963775634766 13.88808536529541 17.83963775634766 C 13.79348373413086 17.83963775634766 13.70302677154541 17.82045555114746 13.61467170715332 17.79402542114258 L 11.71336841583252 19.96715927124023 C 11.73652076721191 20.06797218322754 11.75121974945068 20.16884613037109 11.75121974945068 20.27931022644043 C 11.75121974945068 20.95408248901367 11.27379417419434 21.49914932250977 10.68486022949219 21.49914932250977 C 10.09387969970703 21.49914932250977 9.616454124450684 20.95408248901367 9.616454124450684 20.27931022644043 C 9.616454124450684 19.60453987121582 10.09387969970703 19.05947303771973 10.68486022949219 19.05947303771973 C 10.77951526641846 19.05947303771973 10.86997127532959 19.07871437072754 10.95827484130859 19.1050853729248 L 12.85963153839111 16.9320125579834 C 12.8364782333374 16.83113861083984 12.81967926025391 16.73032569885254 12.81967926025391 16.61985969543457 C 12.81967926025391 15.94508838653564 13.29920482635498 15.40002155303955 13.88808536529541 15.40002155303955 C 14.4791202545166 15.40002155303955 14.95654582977295 15.94508838653564 14.95654582977295 16.61985969543457 C 14.95654582977295 16.75429916381836 14.93344688415527 16.87914657592773 14.89979457855225 16.9992618560791 L 17.94526290893555 20.91320419311523 C 18.01676559448242 20.89642333984375 18.0882682800293 20.88923072814941 18.1618709564209 20.88923072814941 C 18.21657562255859 20.88923072814941 18.26918029785156 20.89881896972656 18.32173156738281 20.90840911865234 L 21.44295501708984 16.45173645019531 C 21.39670372009277 16.31490135192871 21.36725044250488 16.16841506958008 21.36725044250488 16.00994110107422 C 21.36725044250488 15.33516979217529 21.84467506408691 14.79010391235352 22.43565940856934 14.79010391235352 Z M 27.75900650024414 19.07631683349609 C 28.0261173248291 19.07631683349609 28.34368515014648 19.19876670837402 28.5602970123291 19.44127082824707 C 28.98516845703125 19.92873954772949 28.98516845703125 20.66110992431641 28.61079978942871 21.14857482910156 L 27.06071472167969 19.38127708435059 C 27.27522468566895 19.19876670837402 27.49188995361328 19.07631683349609 27.75900650024414 19.07631683349609 Z M 26.25936889648438 20.23369979858398 L 27.862060546875 22.06339454650879 L 22.04028701782227 28.70998382568359 L 20.43759918212891 26.94268226623535 L 26.25936889648438 20.23369979858398 Z M 19.90336799621582 28.10012626647949 L 21.02443313598633 29.38235664367676 L 19.47854804992676 29.86742782592773 L 19.90336799621582 28.10012626647949 Z" fill="#2a7980" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Text(
                        'Reports',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
        //     Card(
        //       child: Padding(
        //         padding: const EdgeInsets.all(1.0),
        //         child: Container(
        //           width: MediaQuery.of(context).size.width / 3 - 10,
        //           height: MediaQuery.of(context).size.width / 3 - 10,
        //           child: Column(
        //             children: [
        //               // Adobe XD layer: 'surface1' (group
        //               Container(
        //                 height: 70,
        //                 width: 70,
        //                 child: Padding(
        //                     padding: const EdgeInsets.all(15.0),
        //                     child: // Adobe XD layer: 'surface1' (group)
        //                         // Adobe XD layer: 'surface1' (group)
        //                         Stack(
        //                       children: <Widget>[
        //                         Pinned.fromPins(
        //                           Pin(start: 0.0, end: 0.0),
        //                           Pin(start: 0.0, end: 0.0),
        //                           child: SvgPicture.string(
        //                             '<svg viewBox="3.0 3.0 28.8 28.8" ><path transform="translate(0.0, 0.0)" d="M 18.55934715270996 2.960939645767212 L 18.55934715270996 16.16064071655273 L 31.75897216796875 16.16064071655273 C 31.75897216796875 8.869691848754883 25.85030555725098 2.960939645767212 18.55934715270996 2.960939645767212 Z M 16.16064071655273 5.359583854675293 C 8.869691848754883 5.359583854675293 2.960939645767212 11.27310276031494 2.960939645767212 18.55934715270996 C 2.960939645767212 25.85030555725098 8.869691848754883 31.75897216796875 16.16064071655273 31.75897216796875 C 23.44685745239258 31.75897216796875 29.36038970947266 25.85030555725098 29.36038970947266 18.55934715270996 L 16.16064071655273 18.55934715270996 L 16.16064071655273 5.359583854675293 Z" fill="#12b3e3" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
        //                             allowDrawingOutsideViewBox: true,
        //                             fit: BoxFit.fill,
        //                           ),
        //                         ),
        //                       ],
        //                     )),
        //               ),
        //               Text(
        //                 'Order List',
        //                 style: TextStyle(
        //                   fontFamily: 'Arial',
        //                   fontSize: 14,
        //                   color: const Color(0xff000000),
        //                   fontWeight: FontWeight.w700,
        //                 ),
        //                 textAlign: TextAlign.left,
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ReturnsPage();
                }));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 10,
                    height: MediaQuery.of(context).size.width / 3 - 10,
                    child: Column(
                      children: [
                        // Adobe XD layer: 'surface1' (group
                        Container(
                          height: 70,
                          width: 60,
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: // Adobe XD layer: 'surface1' (group)
                                  // Adobe XD layer: 'surface1' (group)
                                  Stack(
                                children: <Widget>[
                                  Pinned.fromPins(
                                    Pin(start: 0.0, end: 0.0),
                                    Pin(start: 0.0, end: 0.0),
                                    child: SvgPicture.string(
                                      '<svg viewBox="6.0 2.0 22.2 26.8" ><path transform="translate(0.0, 0.0)" d="M 5.953129768371582 1.984380125999451 L 5.953129768371582 28.80494689941406 L 28.11071586608887 28.80494689941406 L 28.11071586608887 1.984380125999451 L 5.953129768371582 1.984380125999451 Z M 18.19712257385254 23.55883026123047 L 10.03519344329834 23.55883026123047 L 10.03519344329834 22.39250755310059 L 18.19712257385254 22.39250755310059 L 18.19712257385254 23.55883026123047 Z M 18.19712257385254 20.05991363525391 L 10.03519344329834 20.05991363525391 L 10.03519344329834 18.89358711242676 L 18.19712257385254 18.89358711242676 L 18.19712257385254 20.05991363525391 Z M 18.19712257385254 16.56099510192871 L 10.03519344329834 16.56099510192871 L 10.03519344329834 15.39466857910156 L 18.19712257385254 15.39466857910156 L 18.19712257385254 16.56099510192871 Z M 24.02863502502441 23.55883026123047 L 21.11287689208984 23.55883026123047 L 21.11287689208984 22.39250755310059 L 24.02863502502441 22.39250755310059 L 24.02863502502441 23.55883026123047 Z M 24.02863502502441 20.05991363525391 L 21.11287689208984 20.05991363525391 L 21.11287689208984 18.89358711242676 L 24.02863502502441 18.89358711242676 L 24.02863502502441 20.05991363525391 Z M 24.02863502502441 16.56099510192871 L 21.11287689208984 16.56099510192871 L 21.11287689208984 15.39466857910156 L 24.02863502502441 15.39466857910156 L 24.02863502502441 16.56099510192871 Z M 24.02863502502441 8.399065017700195 L 10.03519344329834 8.399065017700195 L 10.03519344329834 7.232799053192139 L 24.02863502502441 7.232799053192139 L 24.02863502502441 8.399065017700195 Z" fill="#845cfd" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        Text(
                          'Sales Return',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3 - 10,
                  height: MediaQuery.of(context).size.width / 3 - 10,
                  child: Column(
                    children: [
                      // Adobe XD layer: 'surface1' (group
                      Container(
                        height: 70,
                        width: 70,
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: // Adobe XD layer: 'surface1' (group)
                                // Adobe XD layer: 'surface1' (group)
                                SvgPicture.string(
                              '<svg viewBox="2.0 3.0 29.3 26.4" ><path transform="translate(0.0, 0.0)" d="M 6.398577690124512 2.999999761581421 L 6.398577690124512 17.66192436218262 L 4.932384967803955 17.66192436218262 C 3.317285776138306 17.66192436218262 2 18.97915267944336 2 20.59431076049805 L 2 29.39146614074707 L 31.3238525390625 29.39146614074707 L 31.3238525390625 20.59431076049805 C 31.3238525390625 18.97915267944336 30.00662612915039 17.66192436218262 28.3914680480957 17.66192436218262 L 26.9252758026123 17.66192436218262 L 26.9252758026123 2.999999761581421 L 23.99288940429688 2.999999761581421 C 23.99288940429688 3.807549715042114 23.33427619934082 4.466192245483398 22.52669715881348 4.466192245483398 C 21.71911811828613 4.466192245483398 21.06050491333008 3.807549715042114 21.06050491333008 2.999999761581421 L 18.12811851501465 2.999999761581421 C 18.12811851501465 3.807549715042114 17.46950531005859 4.466192245483398 16.66192626953125 4.466192245483398 C 15.85434627532959 4.466192245483398 15.19573307037354 3.807549715042114 15.19573307037354 2.999999761581421 L 12.26334762573242 2.999999761581421 C 12.26334762573242 3.807549715042114 11.60470581054688 4.466192245483398 10.79715538024902 4.466192245483398 C 9.989605903625488 4.466192245483398 9.330963134765625 3.807549715042114 9.330963134765625 2.999999761581421 L 6.398577690124512 2.999999761581421 Z M 9.330963134765625 7.398577690124512 L 23.99288940429688 7.398577690124512 L 23.99288940429688 20.59431076049805 L 9.330963134765625 20.59431076049805 L 9.330963134765625 7.398577690124512 Z M 12.26334762573242 10.33096313476562 L 12.26334762573242 13.26334857940674 L 21.06050491333008 13.26334857940674 L 21.06050491333008 10.33096313476562 L 12.26334762573242 10.33096313476562 Z M 12.26334762573242 14.72954082489014 L 12.26334762573242 17.66192436218262 L 18.12811851501465 17.66192436218262 L 18.12811851501465 14.72954082489014 L 12.26334762573242 14.72954082489014 Z M 6.398577690124512 23.52669525146484 L 9.330963134765625 23.52669525146484 L 9.330963134765625 26.45908164978027 L 6.398577690124512 26.45908164978027 L 6.398577690124512 23.52669525146484 Z M 12.26334762573242 23.52669525146484 L 15.19573307037354 23.52669525146484 L 15.19573307037354 26.45908164978027 L 12.26334762573242 26.45908164978027 L 12.26334762573242 23.52669525146484 Z M 18.12811851501465 23.52669525146484 L 21.06050491333008 23.52669525146484 L 21.06050491333008 26.45908164978027 L 18.12811851501465 26.45908164978027 L 18.12811851501465 23.52669525146484 Z M 23.99288940429688 23.52669525146484 L 26.9252758026123 23.52669525146484 L 26.9252758026123 26.45908164978027 L 23.99288940429688 26.45908164978027 L 23.99288940429688 23.52669525146484 Z" fill="#f9a936" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                              allowDrawingOutsideViewBox: true,
                              fit: BoxFit.fill,
                            )),
                      ),
                      Text(
                        'Receipts',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff20474f),
      centerTitle: false,
      actions: [
        Column(
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  child: Container(
                    height: 25,
                    width: 30,
                    child: Image.asset(
                      'assets/images/bell.png',
                      fit: BoxFit.scaleDown,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Container(
                          height: 45,
                          width: 45,
                          child: Center(
                            child: Image.asset(
                              'assets/images/person.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        "Sameer",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w900),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ],
        ),
      ],
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: Container(
            height: 25,
            width: 25,
            child: Center(
              child: Container(
                height: 25,
                width: 25,
                child: Image.asset(
                  'assets/images/drawer.png',
                  fit: BoxFit.fill,
                ),
              ),
            )),
      ),
      elevation: 1.0,
      titleSpacing: 0,
      toolbarHeight: 80,
    );
  }
}
