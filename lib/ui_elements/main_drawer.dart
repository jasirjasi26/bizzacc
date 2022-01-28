import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:optimist_erp_app/screens/mis_reports/sales_register.dart';

import 'package:optimist_erp_app/screens/mis_reports/sales_ledger.dart';
import 'package:optimist_erp_app/screens/mis_reports/stock_reports.dart';
import 'package:optimist_erp_app/screens/orders.dart';
import 'package:optimist_erp_app/screens/product.dart';
import 'package:optimist_erp_app/screens/van_page.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  MainDrawerState createState() => MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 50),
        child: ListView(
            children: <Widget>[
              ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Container(
                    height: 35,
                    width: 35,
                    child: Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/images/van.png",
                              fit: BoxFit.scaleDown,
                          //    color: Colors.white
                          )),
                    ),
                  ),
                  title: Text('Van number 3',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                           return VanPage();
                        }));
                  }),
              ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Container(
                    height: 35,
                    width: 35,
                    child: Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/images/phone.png",
                              fit: BoxFit.scaleDown,
                          //    color: Colors.white
                          )),
                    ),
                  ),
                  title: Text('+919999999222',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //      // return DoctorAppoinments();
                    //     }));
                  }),
              Divider(height: 30,color: Colors.white,thickness: 0.2,),

              ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Container(
                    height: 35,
                    width: 35,

                    child: Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/images/customers.png",
                              fit: BoxFit.scaleDown,
                          //    color: Colors.white
                          )),
                    ),
                  ),
                  title: Text('Customers',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //      // return DoctorPrescription();
                    //     }));
                  }),
              //  : Container(),
              // is_logged_in.value == true
              //     ?

              ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Container(
                    height: 35,
                    width: 35,
                    child: Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/images/product.png",
                              fit: BoxFit.scaleDown,
                          //    color: Colors.black
                          )),
                    ),
                  ),
                  title: Text('Products',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onTap: () {

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                           return ProductPage(title: "title",);
                        }));
                  }),

              ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Container(
                    height: 35,
                    width: 35,
                    child: Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/images/stock.png",
                              fit: BoxFit.scaleDown,
                          //    color: Colors.black
                          )),
                    ),
                  ),
                  title: Text('Stock',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //      // return ConsultationList();
                    //     }));

                  }),

              Divider(height: 30,color: Colors.white,thickness: 0.2,),
              ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Container(
                    height: 35,
                    width: 35,
                    child: Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/images/orders.png",
                              fit: BoxFit.scaleDown,
                              color: Colors.black)),
                    ),
                  ),
                  title: Text('Orders',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return OrdersPage();
                        }));
                  }),

              ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Container(
                    height: 35,
                    width: 35,
                    child: Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/images/misreports.png",
                              fit: BoxFit.scaleDown,
                          //    color: Colors.white
                          )),
                    ),
                  ),
                  title: Text('Mis Reports',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //      // return DoctorLeaves();
                    //     }));

                  }),

              ///3 types
              ///
              ListTile(
                  trailing: Padding(
                    padding: const EdgeInsets.only(right:50.0),
                    child: Text('Sales Register',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return SalesRegister();
                        }));
                  }),
              ListTile(
                  trailing: Padding(
                    padding: const EdgeInsets.only(right:50.0),
                    child: Text('Stock Reports ',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return StockReports();
                        }));
                  }),
              ListTile(
                  trailing: Padding(
                    padding: const EdgeInsets.only(right:50.0),
                    child: Text('Sales Ledger  ',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return SalesLedger();
                        }));
                  }),

              ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading: Container(
                    height: 35,
                    width: 35,
                    child: Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/images/reports.png",
                              fit: BoxFit.scaleDown,
                          //    color: Colors.white
                          )),
                    ),
                  ),
                  title: Text('Reports',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //       //return BannerRequest();
                    //     }));

                  }),

              ///3 types
              ///
              ListTile(
                  trailing: Padding(
                    padding: const EdgeInsets.only(right:20.0),
                    child: Text('Sales Reports           ',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //       // return DoctorAppoinments();
                    //     }));
                  }),
              ListTile(
                  trailing: Padding(
                    padding: const EdgeInsets.only(right:20.0),
                    child: Text('Sales Return Report',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //       // return DoctorAppoinments();
                    //     }));
                  }),
              ListTile(
                  trailing: Padding(
                    padding: const EdgeInsets.only(right:20.0),
                    child: Text('Stock Report            ',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  onTap: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //       // return DoctorAppoinments();
                    //     }));
                  }),


              ListTile(
                  visualDensity:
                  VisualDensity(horizontal: -4, vertical: -4),
                  leading:Container(
                    height: 35,
                    width: 35,
                    child: Center(
                      child: Container(
                          height: 20,
                          width: 20,
                          child: Image.asset("assets/images/wallet.png",
                              fit: BoxFit.scaleDown,
                          //    color: Colors.white
                          )),
                    ),
                  ),
                  title: Text('Wallet',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  onTap: () {

                  }),

              SizedBox(height: 30,)
            ],
          ),
        ),
    );
  }
}
