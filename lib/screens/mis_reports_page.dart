import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimist_erp_app/screens/mis_reports/sales_ledger.dart';
import 'package:optimist_erp_app/screens/mis_reports/sales_register.dart';
import 'package:optimist_erp_app/screens/mis_reports/stock_reports.dart';

class MisPage extends StatefulWidget {

  @override
  MisPageState createState() => MisPageState();
}

class MisPageState extends State<MisPage> {


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
       // appBar: buildAppBar(context),
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  backgroundColor: Color(0xff20474f),
                  title: Text(
                    "Mis Reports",
                    style: TextStyle(color: Colors.white),
                  ),
                  bottom: TabBar(
                    indicatorPadding: EdgeInsets.all(5),
                    isScrollable: true,
                    labelPadding: EdgeInsets.all(10),
                    tabs: [
                      Text("Sales Register"),
                      Text("Sales Ledger"),
                      Text("Stock Reports")
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                Tab(child: SalesRegister()),
                Tab(child: SalesLedger()),
                Tab(child: StockReports())
              ],
            ),
          )),
    );
  }


  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff20474f),
      centerTitle: false,
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      automaticallyImplyLeading: true,
      title: Text(
        "Mis Reports",
        style: TextStyle(color: Colors.white),
      ),
      elevation: 0,
      titleSpacing: 0,
      toolbarHeight: 80,
    );
  }
}
