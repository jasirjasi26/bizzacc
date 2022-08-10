import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/screens/login.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:optimist_erp_app/syncronize.dart';
import '../controller.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainDrawer extends StatefulWidget {
  @override
  MainDrawerState createState() => MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> {
  bool misHeight = false;
  bool reports = false;
  var image;
  late Uint8List bytes;

  Future syncToMysql() async {
    await SyncronizationData().fetchAllInfo().then((userList) async {
      EasyLoading.show(status: 'Dont close app. we are on sync...');
      await SyncronizationData().saveToMysqlWith(userList);
      Controller().delete();
      EasyLoading.showSuccess('Sync Success');
    });
  }

  @override
  void initState() {
    Uint8List bytes1 = base64Decode(User.companylogo);
    // setState(() {
    //   image = bytes;
    // });
    //  final ByteData data = await rootBundle.load('assets/images/logo.jpg');
    setState(() {
      //bytes = data.buffer.asUint8List();
      bytes=bytes1;
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 0),
        child: ListView(
          children: <Widget>[
            bytes != null
                ? Center(child: Container(width: 150, height: 150, child: Image.memory(bytes,fit: BoxFit.fill,)))
                : Container(),
            ListTile(
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                leading: Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "assets/images/van.png",
                          fit: BoxFit.scaleDown,
                          //    color: Colors.white
                        )),
                  ),
                ),
                title: Text('Van number : ' + User.depotId.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                onTap: () {}),
            SizedBox(
              height: 5,
            ),
            ListTile(
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                leading: Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "assets/images/phone.png",
                          fit: BoxFit.scaleDown,
                          //    color: Colors.white
                        )),
                  ),
                ),
                title: Text(User.number.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                onTap: () {

                }),
            SizedBox(
              height: 5,
            ),
            // ListTile(
            //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            //     leading: Container(
            //       height: 35,
            //       width: 35,
            //       child: Center(
            //         child: Container(
            //             height: 20,
            //             width: 20,
            //             child: Image.asset(
            //               "assets/images/customers.png",
            //               fit: BoxFit.scaleDown,
            //               //    color: Colors.white
            //             )),
            //       ),
            //     ),
            //     title: Text('Customers',
            //         style: TextStyle(color: Colors.black, fontSize: 18)),
            //     onTap: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) {
            //         return CustomersList();
            //       }));
            //     }),
            // //  : Container(),
            // // is_logged_in.value == true
            // //     ?
            // SizedBox(
            //   height: 5,
            // ),
            // ListTile(
            //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            //     leading: Container(
            //       height: 35,
            //       width: 35,
            //       child: Center(
            //         child: Container(
            //             height: 20,
            //             width: 20,
            //             child: Image.asset(
            //               "assets/images/product.png",
            //               fit: BoxFit.scaleDown,
            //               //    color: Colors.black
            //             )),
            //       ),
            //     ),
            //     title: Text('Products',
            //         style: TextStyle(color: Colors.black, fontSize: 18)),
            //     onTap: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) {
            //         return AllProductPage(
            //           back: true,
            //         );
            //       }));
            //     }),
            // SizedBox(
            //   height: 5,
            // ),
            // ListTile(
            //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            //     leading: Container(
            //       height: 35,
            //       width: 35,
            //       child: Center(
            //         child: Container(
            //             height: 20,
            //             width: 20,
            //             child: Image.asset("assets/images/orders.png",
            //                 fit: BoxFit.scaleDown, color: Colors.black)),
            //       ),
            //     ),
            //     title: Text('Orders',
            //         style: TextStyle(color: Colors.black, fontSize: 18)),
            //     onTap: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) {
            //         return OrdersPage();
            //       }));
            //     }),
            // SizedBox(
            //   height: 5,
            // ),
            // ListTile(
            //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            //     leading: Container(
            //       height: 35,
            //       width: 35,
            //       child: Center(
            //         child: Container(
            //             height: 20,
            //             width: 20,
            //             child: Image.asset(
            //               "assets/images/misreports.png",
            //               fit: BoxFit.scaleDown,
            //               //    color: Colors.white
            //             )),
            //       ),
            //     ),
            //     title: Text('Mis Reports',
            //         style: TextStyle(color: Colors.black, fontSize: 18)),
            //     onTap: () {
            //       setState(() {
            //         misHeight = !misHeight;
            //       });
            //     }),
            // SizedBox(
            //   height: 5,
            // ),
            //
            // ///3 types
            // ///
            // misHeight
            //     ? ListTile(
            //         trailing: Padding(
            //           padding: const EdgeInsets.only(right: 50.0),
            //           child: Text('Sales Register',
            //               style: TextStyle(color: Colors.black, fontSize: 18)),
            //         ),
            //         onTap: () {
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) {
            //             return SalesRegister();
            //           }));
            //         })
            //     : Container(),
            // misHeight
            //     ? ListTile(
            //         trailing: Padding(
            //           padding: const EdgeInsets.only(right: 50.0),
            //           child: Text('Stock Reports ',
            //               style: TextStyle(color: Colors.black, fontSize: 18)),
            //         ),
            //         onTap: () {
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) {
            //             return StockReports();
            //           }));
            //         })
            //     : Container(),
            // misHeight
            //     ? ListTile(
            //         trailing: Padding(
            //           padding: const EdgeInsets.only(right: 50.0),
            //           child: Text('Sales Ledger  ',
            //               style: TextStyle(color: Colors.black, fontSize: 18)),
            //         ),
            //         onTap: () {
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) {
            //             return SalesLedger();
            //           }));
            //         })
            //     : Container(),
            // SizedBox(
            //   height: 5,
            // ),
            // ListTile(
            //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            //     leading: Container(
            //       height: 35,
            //       width: 35,
            //       child: Center(
            //         child: Container(
            //             height: 20,
            //             width: 20,
            //             child: Image.asset(
            //               "assets/images/reports.png",
            //               fit: BoxFit.scaleDown,
            //               //    color: Colors.white
            //             )),
            //       ),
            //     ),
            //     title: Text('Reports',
            //         style: TextStyle(color: Colors.black, fontSize: 18)),
            //     onTap: () {
            //       setState(() {
            //         reports = !reports;
            //       });
            //     }),
            //
            // ///3 types
            // ///
            // reports
            //     ? ListTile(
            //         trailing: Padding(
            //           padding: const EdgeInsets.only(right: 20.0),
            //           child: Text('Sales Reports           ',
            //               style: TextStyle(color: Colors.black, fontSize: 18)),
            //         ),
            //         onTap: () {
            //           // Navigator.push(context,
            //           //     MaterialPageRoute(builder: (context) {
            //           //       // return DoctorAppoinments();
            //           //     }));
            //         })
            //     : Container(),
            // reports
            //     ? ListTile(
            //         trailing: Padding(
            //           padding: const EdgeInsets.only(right: 20.0),
            //           child: Text('Sales Return Report',
            //               style: TextStyle(color: Colors.black, fontSize: 18)),
            //         ),
            //         onTap: () {
            //           // Navigator.push(context,
            //           //     MaterialPageRoute(builder: (context) {
            //           //       // return DoctorAppoinments();
            //           //     }));
            //         })
            //     : Container(),
            // reports
            //     ? ListTile(
            //         trailing: Padding(
            //           padding: const EdgeInsets.only(right: 20.0),
            //           child: Text('Stock Report            ',
            //               style: TextStyle(color: Colors.black, fontSize: 18)),
            //         ),
            //         onTap: () {
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) {
            //             return StockReports1();
            //           }));
            //         })
            //     : Container(),
            // SizedBox(
            //   height: 5,
            // ),
            // ListTile(
            //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
            //     leading: Container(
            //       height: 35,
            //       width: 35,
            //       child: Center(
            //         child: Container(
            //             height: 20,
            //             width: 20,
            //             child: Image.asset(
            //               "assets/images/wallet.png",
            //               fit: BoxFit.scaleDown,
            //               //    color: Colors.white
            //             )),
            //       ),
            //     ),
            //     title: Text('Wallet',
            //         style: TextStyle(color: Colors.black, fontSize: 18)),
            //     onTap: () {}),

            SizedBox(
              height: 5,
            ),

            ListTile(
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                leading: Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Icon(
                          Icons.sync,
                          color: Colors.black,
                        )),
                  ),
                ),
                title: Text('Sync Data',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                onTap: () async {
                  await SyncronizationData.isInternet().then((connection) {
                    if (connection) {
                      syncToMysql();
                      print("Internet connection available");
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("No Internet")));
                    }
                  });
                }),

            SizedBox(
              height: 5,
            ),
            ListTile(
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                leading: Container(
                  height: 35,
                  width: 35,
                  child: Center(
                    child: Container(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "assets/images/logout.png",
                          fit: BoxFit.scaleDown,
                          //    color: Colors.white
                        )),
                  ),
                ),
                title: Text('Logout',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                onTap: () async {
                  await APICacheManager()
                      .emptyCache()
                      .whenComplete(() => {User().clear()});

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Login();
                  }));
                }),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
