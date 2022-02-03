import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/screens/orders.dart';
import '../ui_elements/main_drawer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DatabaseReference reference;
  String today=DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();


  Future<void> getBill() async {
    reference..child("Bills").child(today).child(User.vanNo).once().then((DataSnapshot snapshot) {
      List<dynamic> value = snapshot.value;
      for (int i = 0; i < value.length; i++) {
        if (value[i] != null) {
          setState(() {
            // item.add(value[i]['ItemName'].toString());
            // totalDisc=totalDisc+double.parse(value[i]['DiscAmount'].toString());
          });
        }}
    });
  }


  void initState() {
    // TODO: implement initState
    reference = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child("CYBRIX");

    getBill();
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
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            homeBox(),
            SizedBox(
              height: 20,
            ),
            diffBox(),
            SizedBox(
              height: 20,
            ),
            overViewBox()
          ],
        ),
      ),
    );
  }

  homeBox() {
    return Column(
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.37,
                    width: MediaQuery.of(context).size.width * 0.37,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -2.47),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xffeeedf3),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(9999.0, 9999.0)),
                                  color: const Color(0xffffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x29000000),
                                      offset: Offset(6, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                        "assets/images/sale.png",
                                        fit: BoxFit.scaleDown,
                                        //    color: Colors.white
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '24500',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 22,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Total Sales',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 15,
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Tap to view',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 10,
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.37,
                    width: MediaQuery.of(context).size.width * 0.37,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -2.47),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xfff3ceef),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(9999.0, 9999.0)),
                                  color: const Color(0xffffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x29000000),
                                      offset: Offset(6, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                        "assets/images/pending.png",
                                        fit: BoxFit.scaleDown,
                                        //    color: Colors.white
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '24',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 22,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Pending Orders',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 15,
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Tap to view',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 10,
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.37,
                    width: MediaQuery.of(context).size.width * 0.37,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -2.47),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xffddebf0),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(9999.0, 9999.0)),
                                  color: const Color(0xffffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x29000000),
                                      offset: Offset(6, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                        "assets/images/in_stock.png",
                                        fit: BoxFit.scaleDown,
                                        //    color: Colors.white
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '1012',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 22,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Available Stock',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 15,
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Tap to view',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 10,
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.37,
                    width: MediaQuery.of(context).size.width * 0.37,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -2.47),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xfffae7cb),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(9999.0, 9999.0)),
                                  color: const Color(0xffffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x29000000),
                                      offset: Offset(6, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      child: Image.asset(
                                        "assets/images/order_now.png",
                                        fit: BoxFit.scaleDown,
                                        //    color: Colors.white
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '144',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 22,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Todays Order',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 15,
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Tap to view',
                                style: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  fontSize: 10,
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  diffBox() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                  width: 80,
                  height: 25,
                  decoration: BoxDecoration(
                    //color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                      child: Text(
                    "Day",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w900),
                  ))),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                  width: 80,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                      child: Text(
                    "Week",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900),
                  ))),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                  width: 80,
                  height: 25,
                  decoration: BoxDecoration(
                    // color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                      child: Text(
                    "Month",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w900),
                  ))),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                  width: 80,
                  height: 25,
                  decoration: BoxDecoration(
                    // color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                      child: Text(
                    "Year",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w900),
                  ))),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/chart.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(6, 3),
                blurRadius: 6,
              ),
            ],
          ),
        )
      ],
    );
  }

  overViewBox() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 30,height: 50,),
            Text(
              'Overview',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 22,
                color: const Color(0xff5b5b5b),
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrdersPage();
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(6, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0xffcfbfff),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(6, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/order_list.png',
                            color: Colors.black,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      " Order List",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5),
                  child: Row(
                    children: [
                      Text(
                        "Tap to view",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Spacer(),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.green,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 3, bottom: 3),
                            child: Center(
                              child: Text(
                                "256",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(6, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xcfa8ebab),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(6, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/sales_return.png',
                          color: Colors.black,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    " Sales Return",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5),
                child: Row(
                  children: [
                    Text(
                      "Tap to view",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Spacer(),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.green,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 3, bottom: 3),
                          child: Center(
                            child: Text(
                              "256",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(6, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xfff5ddbb),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(6, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/reciept_portal.png',
                          color: Colors.black,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    " Reciept Portal",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5),
                child: Row(
                  children: [
                    Text(
                      "Tap to view",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Spacer(),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.green,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 3, bottom: 3),
                          child: Center(
                            child: Text(
                              "256",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Container(
            height: 20,
            width: 40,
            child: Image.asset(
              'assets/images/person.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        Center(
            child: Text(
          User.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        )),
        SizedBox(
          width: 15,
        ),
      ],
      leading: Container(
        child: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Builder(
            builder: (context) => Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              child: Container(
                child: Image.asset(
                  'assets/images/homebox.png',
                  height: 30,
                  width: 30,
                  //color: MyTheme.dark_grey,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
      elevation: 1.0,
      titleSpacing: 0,
      toolbarHeight: 70,
    );
  }
}
