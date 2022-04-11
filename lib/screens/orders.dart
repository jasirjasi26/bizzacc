// // @dart=2.9
// import 'dart:convert';
//
// import 'package:api_cache_manager/models/cache_db_model.dart';
// import 'package:api_cache_manager/utils/cache_manager.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:intl/intl.dart';
// import 'package:optimist_erp_app/data/user_data.dart';
// import 'package:optimist_erp_app/screens/setleAfterOrder.dart';
// import 'package:optimist_erp_app/screens/van_page.dart';
// import 'package:http/http.dart' as http;
// import '../app_config.dart';
// import '../models/all_invoice.dart';
// import '../models/all_orders.dart';
// import '../models/products.dart';
//
// class OrdersPage extends StatefulWidget {
//   @override
//   OrdersPageState createState() => OrdersPageState();
// }
//
// class OrdersPageState extends State<OrdersPage> {
//   bool select = true;
//   var name = TextEditingController();
//   Future<List<AllOrder>> fetchOrders;
//   Future<List<AllInvoice>> fetchInvoice;
//   String today = DateTime.now().year.toString() +
//       "-" +
//       DateTime.now().month.toString() +
//       "-" +
//       DateTime.now().day.toString();
//
//   DateTime selectedDate = DateTime.now();
//   String from = DateTime.now().year.toString() +
//       "-" +
//       DateTime.now().month.toString() +
//       "-" +
//       DateTime.now().day.toString();
//
//   String to = DateTime.now().year.toString() +
//       "-" +
//       DateTime.now().month.toString() +
//       "-" +
//       DateTime.now().day.toString();
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//         from = selectedDate.year.toString() +
//             "-" +
//             selectedDate.month.toString() +
//             "-" +
//             selectedDate.day.toString();
//       });
//     fetchOrders = fetchDatas();
//     fetchInvoice = fetchInvoiceDatas();
//   }
//
//   Future<void> _selectToDate(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//         to = selectedDate.year.toString() +
//             "-" +
//             selectedDate.month.toString() +
//             "-" +
//             selectedDate.day.toString();
//       });
//
//     fetchOrders = fetchDatas();
//     fetchInvoice = fetchInvoiceDatas();
//   }
//
//   Future<List<AllOrder>> fetchDatas() async {
//     // var isCacheExist = await APICacheManager().isAPICacheKeyExist("orderlist");
//     //
//     // if (!isCacheExist) {
//     //   print("Data not exists");
//
//     Map data = {'from_Date': from, 'to_Date': to, "billed": "0"};
//     //encode Map to JSON
//     var body = json.encode(data);
//     String url = AppConfig.DOMAIN_PATH + "salesorder/showall";
//     final response = await http.post(
//       url,
//       body: body,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       APICacheDBModel cacheDBModel =
//           new APICacheDBModel(key: "orderlist", syncData: response.body);
//       await APICacheManager().addCacheData(cacheDBModel);
//
//       return allOrderFromJson(response.body);
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load album');
//     }
//     // } else {
//     //   print("Data exists");
//     //   var cacheData = await APICacheManager().getCacheData("orderlist");
//     //   print(allOrderFromJson(cacheData.syncData));
//     //   return allOrderFromJson(cacheData.syncData);
//     // }
//   }
//
//   Future<List<AllInvoice>> fetchInvoiceDatas() async {
//     Map data = {
//       'from_Date': from,
//       'to_Date': to,
//     };
//     //encode Map to JSON
//     var body = json.encode(data);
//     String url = AppConfig.DOMAIN_PATH + "salesinvoice/showall";
//     final response = await http.post(
//       url,
//       body: body,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       APICacheDBModel cacheDBModel =
//           new APICacheDBModel(key: "invoicelist", syncData: response.body);
//       await APICacheManager().addCacheData(cacheDBModel);
//
//       return allInvoiceFromJson(response.body);
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load album');
//     }
//     // } else {
//     //   print("Data exists");
//     //   var cacheData = await APICacheManager().getCacheData("orderlist");
//     //   print(allOrderFromJson(cacheData.syncData));
//     //   return allInvoiceFromJson(cacheData.syncData);
//     // }
//   }
//
//   deleteOrder(String id) async {
//     print(id);
//     Map data = {
//       'Order_id': id,
//     };
//     //encode Map to JSON
//     var body = json.encode(data);
//     String url = AppConfig.DOMAIN_PATH + "salesorder/delete";
//     final response = await http.post(
//       url,
//       body: body,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       EasyLoading.showSuccess('Successfully Deleted');
//       Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (BuildContext context) => super.widget));
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to delete');
//     }
//   }
//
//   getSingleOrder(String id) async {
//     Map data = {
//       'Order_id': id,
//     };
//     //encode Map to JSON
//     var body = json.encode(data);
//     String url = AppConfig.DOMAIN_PATH + "salesorder/show";
//     final response = await http.post(
//       url,
//       body: body,
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       //print(response.body);
//       Map<String, dynamic> data = jsonDecode(response.body);
//       // EasyLoading.showSuccess(data.toString());
//       Navigator.push(context, MaterialPageRoute(builder: (context) {
//         return SettlementPage2(
//           //customerName: widget.customerName,
//           date: today,
//           values: data,
//         );
//       }));
//       // Navigator.pushReplacement(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (BuildContext context) => super.widget));
//
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to delete');
//     }
//   }
//
//   void initState() {
//     // TODO: implement initState
//
//     fetchOrders = fetchDatas();
//     fetchInvoice = fetchInvoiceDatas();
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: buildAppBar(context),
//       body: ListView(
//         children: [
//           searchRow(),
//           salesOrder()
//         ],
//       ),
//     );
//   }
//
//   searchRow() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 100,
//       color: Color(0xff20474f),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.93,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5.0),
//                     color: const Color(0xffffffff),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0x29000000),
//                         offset: Offset(6, 3),
//                         blurRadius: 12,
//                       ),
//                     ],
//                   ),
//                   child: TextFormField(
//                       controller: name,
//                       // onChanged: getCustomerId,
//                       decoration: InputDecoration(
//                         hintText: 'Enter customer name here',
//                         //filled: true,
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.only(
//                             left: 15, bottom: 5, top: 15, right: 15),
//                         filled: false,
//                         isDense: false,
//                         prefixIcon: Icon(
//                           Icons.person,
//                           size: 25.0,
//                           color: Colors.grey,
//                         ),
//                       )),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Text(
//                   '  From : ',
//                   style: TextStyle(
//                     fontFamily: 'Arial',
//                     fontSize: 13,
//                     color: Color(0xffb0b0b0),
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _selectDate(context);
//                   },
//                   child: Text(
//                     from,
//                     style: TextStyle(
//                         fontFamily: 'Arial',
//                         fontSize: 13,
//                         color: Colors.white,
//                         decoration: TextDecoration.underline),
//                     textAlign: TextAlign.left,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Text(
//                   'To',
//                   style: TextStyle(
//                     fontFamily: 'Arial',
//                     fontSize: 13,
//                     color: Color(0xffb0b0b0),
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _selectToDate(context);
//                   },
//                   child: Text(
//                     to,
//                     style: TextStyle(
//                         fontFamily: 'Arial',
//                         fontSize: 13,
//                         color: Colors.white,
//                         decoration: TextDecoration.underline),
//                     textAlign: TextAlign.left,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   salesOrder() {
//     return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Container(
//           width: 600,
//           height: MediaQuery.of(context).size.height,
//           child: ListView(
//             children: [
//               Container(
//                 height: 35,
//                 decoration: BoxDecoration(
//                   color: const Color(0xff454d60),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         '   V No ',
//                         style: TextStyle(
//                           fontFamily: 'Arial',
//                           fontSize: 12,
//                           color: const Color(0xffffffff),
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         '  Date ',
//                         style: TextStyle(
//                           fontFamily: 'Arial',
//                           fontSize: 12,
//                           color: const Color(0xffffffff),
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                     Container(
//                       width: 200,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(
//                           child: Text(
//                             '  Name ',
//                             style: TextStyle(
//                               fontFamily: 'Arial',
//                               fontSize: 12,
//                               color: const Color(0xffffffff),
//                             ),
//                             textAlign: TextAlign.left,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         ' Amt  ',
//                         style: TextStyle(
//                           fontFamily: 'Arial',
//                           fontSize: 12,
//                           color: const Color(0xffffffff),
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         ' Status  ',
//                         style: TextStyle(
//                           fontFamily: 'Arial',
//                           fontSize: 12,
//                           color: const Color(0xffffffff),
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         ' Actions   ',
//                         style: TextStyle(
//                           fontFamily: 'Arial',
//                           fontSize: 12,
//                           color: const Color(0xffffffff),
//                         ),
//                         textAlign: TextAlign.left,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 15,
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.8,
//                 width: MediaQuery.of(context).size.width,
//                 child: FutureBuilder<List<AllOrder>>(
//                     future: fetchOrders,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         return Container(
//                           height: MediaQuery.of(context).size.height,
//                           width: MediaQuery.of(context).size.width,
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: snapshot.data.length,
//                               // ignore: missing_return
//                               itemBuilder: (context, index) {
//                                 if (snapshot.data[index].customerName
//                                     .toLowerCase()
//                                     .contains("")) {
//                                   return Container(
//                                     height: 28,
//                                     width: MediaQuery.of(context).size.width,
//                                     decoration: BoxDecoration(
//                                       color: index.floor().isEven
//                                           ? Color(0x66d6d6d6)
//                                           : Color(0x66f3ceef),
//                                     ),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.center,
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             snapshot.data[index].voucherNo,
//                                             style: TextStyle(
//                                               fontFamily: 'Arial',
//                                               fontSize: 12,
//                                               color: Colors.black,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets.all(0.0),
//                                           child: Text(
//                                             snapshot.data[index].orderDate
//                                                 .toString(),
//                                             style: TextStyle(
//                                               fontFamily: 'Arial',
//                                               fontSize: 12,
//                                               color: Colors.black,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                         ),
//                                         Container(
//                                           width: 180,
//                                           child: Padding(
//                                             padding:
//                                             const EdgeInsets.all(3.0),
//                                             child: Text(
//                                               snapshot
//                                                   .data[index].customerName,
//                                               style: TextStyle(
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 12,
//                                                 color: Colors.black,
//                                               ),
//                                               textAlign: TextAlign.left,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets.all(3.0),
//                                           child: Text(
//                                             snapshot.data[index].grandTotal
//                                                 .toStringAsFixed(2),
//                                             style: TextStyle(
//                                               fontFamily: 'Arial',
//                                               fontSize: 12,
//                                               color: Colors.black,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             "Pending",
//                                             style: TextStyle(
//                                               fontFamily: 'Arial',
//                                               fontSize: 12,
//                                               color: Colors.black,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets.all(8.0),
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               // Navigator.push(context,
//                                               //     MaterialPageRoute(builder: (context) {
//                                               //       return Settlement2(
//                                               //         customerName: names[index],
//                                               //         date: dates[index],
//                                               //         //values: values,
//                                               //         radioValue: 0,
//                                               //       );
//                                               //     }));
//                                               getSingleOrder(snapshot
//                                                   .data[index].orderId
//                                                   .toString());
//                                             },
//                                             child: Text(
//                                               "Change",
//                                               style: TextStyle(
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 12,
//                                                 color: Colors.blue,
//                                               ),
//                                               textAlign: TextAlign.left,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding:
//                                           const EdgeInsets.all(8.0),
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               deleteOrder(snapshot
//                                                   .data[index].orderId
//                                                   .toString());
//                                             },
//                                             child: Text(
//                                               "Delete",
//                                               style: TextStyle(
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 12,
//                                                 color: Colors.red,
//                                               ),
//                                               textAlign: TextAlign.left,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }
//                               }),
//                         );
//                       } else {
//                         return Center(child: CircularProgressIndicator());
//                       }
//                     }),
//               ),
//             ],
//           ),
//         ));
//   }
//
//   salesInvoice() {
//     return Column(
//       children: [
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Column(
//             children: [
//               Container(
//                   height: 25,
//                   width: 600,
//                   decoration: BoxDecoration(
//                     color: const Color(0xff454d60),
//                   ),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Container(
//                       width: 600,
//                       height: MediaQuery.of(context).size.height,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               '   V No ',
//                               style: TextStyle(
//                                 fontFamily: 'Arial',
//                                 fontSize: 12,
//                                 color: const Color(0xffffffff),
//                               ),
//                               textAlign: TextAlign.left,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               '  Date ',
//                               style: TextStyle(
//                                 fontFamily: 'Arial',
//                                 fontSize: 12,
//                                 color: const Color(0xffffffff),
//                               ),
//                               textAlign: TextAlign.left,
//                             ),
//                           ),
//                           Container(
//                             width: 200,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Center(
//                                 child: Text(
//                                   '  Name ',
//                                   style: TextStyle(
//                                     fontFamily: 'Arial',
//                                     fontSize: 12,
//                                     color: const Color(0xffffffff),
//                                   ),
//                                   textAlign: TextAlign.left,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Center(
//                               child: Text(
//                                 ' Code  ',
//                                 style: TextStyle(
//                                   fontFamily: 'Arial',
//                                   fontSize: 12,
//                                   color: const Color(0xffffffff),
//                                 ),
//                                 textAlign: TextAlign.left,
//                               ),
//                             ),
//                           ),
//                           SizedBox(),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               'Bill Amount  ',
//                               style: TextStyle(
//                                 fontFamily: 'Arial',
//                                 fontSize: 12,
//                                 color: const Color(0xffffffff),
//                               ),
//                               textAlign: TextAlign.left,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               '   ',
//                               style: TextStyle(
//                                 fontFamily: 'Arial',
//                                 fontSize: 12,
//                                 color: const Color(0xffffffff),
//                               ),
//                               textAlign: TextAlign.left,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )),
//               Container(
//                   width: 600,
//                   height: MediaQuery.of(context).size.height,
//                   child: FutureBuilder<List<AllInvoice>>(
//                       future: fetchInvoice,
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           return ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: snapshot.data.length,
//                               itemBuilder: (context, index) {
//                                 if (snapshot.data[index].customerName
//                                     .toLowerCase()
//                                     .contains(name.text)) {
//                                   return Container(
//                                     height: 30,
//                                     width: MediaQuery.of(context).size.width,
//                                     decoration: BoxDecoration(
//                                       color: index.floor().isEven
//                                           ? Color(0x66d6d6d6)
//                                           : Color(0x66f3ceef),
//                                     ),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             snapshot.data[index].voucherNo,
//                                             style: TextStyle(
//                                               fontFamily: 'Arial',
//                                               fontSize: 12,
//                                               color: Colors.black,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(0.0),
//                                           child: Text(
//                                             snapshot.data[index].invoiceDate
//                                                 .toString(),
//                                             style: TextStyle(
//                                               fontFamily: 'Arial',
//                                               fontSize: 12,
//                                               color: Colors.black,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                         ),
//                                         Container(
//                                           width: 180,
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(3.0),
//                                             child: Text(
//                                               snapshot.data[index].customerName,
//                                               style: TextStyle(
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 12,
//                                                 color: Colors.black,
//                                               ),
//                                               textAlign: TextAlign.left,
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           width: 180,
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(3.0),
//                                             child: Text(
//                                               snapshot.data[index].invoiceId ??
//                                                   "",
//                                               style: TextStyle(
//                                                 fontFamily: 'Arial',
//                                                 fontSize: 12,
//                                                 color: Colors.black,
//                                               ),
//                                               textAlign: TextAlign.left,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(3.0),
//                                           child: Text(
//                                             snapshot.data[index].grandTotal
//                                                 .toStringAsFixed(2),
//                                             style: TextStyle(
//                                               fontFamily: 'Arial',
//                                               fontSize: 12,
//                                               color: Colors.black,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(3.0),
//                                           child: Text(
//                                             "            ",
//                                             style: TextStyle(
//                                               fontFamily: 'Arial',
//                                               fontSize: 12,
//                                               color: Colors.black,
//                                             ),
//                                             textAlign: TextAlign.left,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 } else {
//                                   return Container();
//                                 }
//                               });
//                         } else {
//                           return Center(child: CircularProgressIndicator());
//                         }
//                       })),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Color(0xff20474f),
//       centerTitle: false,
//       iconTheme: IconThemeData(
//         color: Colors.white, //change your color here
//       ),
//       automaticallyImplyLeading: true,
//       title: Text(
//         "Order List",
//         style: TextStyle(color: Colors.white),
//       ),
//       elevation: 0,
//       titleSpacing: 0,
//       toolbarHeight: 80,
//     );
//   }
// }
