// // @dart=2.9
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
// import 'package:optimist_erp_app/data/user_data.dart';
// import 'package:optimist_erp_app/screens/receipt_portal_bill.dart';
// import 'package:textfield_search/textfield_search.dart';
// import 'dart:async';
//
// class RecieptPortal extends StatefulWidget {
//
//   @override
//   SettlementPageState2 createState() => SettlementPageState2();
// }
//
// class SettlementPageState2 extends State<RecieptPortal> {
//   var voucherNo = TextEditingController();
//   var billAmount = TextEditingController();
//   var oldBalance = TextEditingController();
//   var paidCash = TextEditingController();
//   var paidCard = TextEditingController();
//   var subTotal = TextEditingController();
//   double finalBalance = 0;
//   DatabaseReference reference;
//   var textEditingController= TextEditingController();
//   String label = "Enter Customer Name";
//   double totalRecieved=0;
//   String customerId;
//   String from = DateTime.now().year.toString() +
//       "-" +
//       DateTime.now().month.toString() +
//       "-" +
//       DateTime.now().day.toString();
//
//   static const duration = const Duration(seconds: 1);
//   Timer timer;
//
//   payOn(String a) {
//     setState(() {
//       finalBalance = double.parse(oldBalance.text) + double.parse(billAmount.text);
//       totalRecieved=(double.parse(paidCard.text) + double.parse(paidCash.text));
//       finalBalance = finalBalance - (double.parse(paidCard.text) + double.parse(paidCash.text));
//     });
//   }
//
//   addValues() async {
//
//     Map<String, dynamic> values = {
//       'Balance': finalBalance,
//       'CustomerName':textEditingController.text,
//       'CustomerID': customerId,
//       'CardReceived': paidCard.text,
//       'CashReceived': paidCash.text,
//       'OrderID': voucherNo.text,
//       'TotalReceived': totalRecieved,
//       'UpdatedTime': DateTime.now().toString(),
//     };
//
//     reference.child("ReceiptPortal")
//         .child(from)
//         .child(User.vanNo)
//         .child(voucherNo.text).set(values);
//
//     ///Update Customer Balance
//     ///
//     Map<String, dynamic> updateBalance = {
//       'Balance': finalBalance,
//     };
//     reference
//         .child("Customers")
//         .child(customerId)
//         .update(updateBalance);
//
//     ///updating the voucher number
//     String lastVoucher = voucherNo.text.replaceAll(User.voucherStarting, "");
//     reference
//       ..child("Vouchers")
//           .child(User.vanNo)
//           .child("VoucherNumber")
//           .remove()
//           .whenComplete(() => {
//         reference
//           ..child("Vouchers")
//               .child(User.vanNo)
//               .child("VoucherNumber")
//               .set(lastVoucher.toString())
//       });
//
//
//     FlutterFlexibleToast.showToast(
//         message: "Added to Receipt Portal",
//         toastGravity: ToastGravity.BOTTOM,
//         icon: ICON.SUCCESS,
//         radius: 50,
//         elevation: 10,
//         imageSize: 20,
//         textColor: Colors.white,
//         backgroundColor: Colors.black,
//         timeInSeconds: 2);
//     //
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ReceiptBill(
//         customerName: textEditingController.text,
//         voucherNumber: voucherNo.text,
//         date: from,
//         billAmount: finalBalance.toString(),
//         back: true,
//       );
//     }));
//   }
//
//
//   Future<void> getBalance() async {
//     await reference.child("Customers").once().then((DataSnapshot snapshot) {
//       Map<dynamic, dynamic> values = snapshot.value;
//       values.forEach((key, values) {
//         if ( values['Name'].toString() == textEditingController.text) {
//           setState(() {
//             oldBalance.text = values["Balance"].toString();
//             customerId= values["CustomerID"].toString();
//           });
//         }
//         else if(values['CustomerCode'].toString() == textEditingController.text){
//           setState(() {
//             oldBalance.text = values["Balance"].toString();
//             customerId= values["CustomerID"].toString();
//           });
//         }
//       });
//     });
//     setState(() {
//       finalBalance = double.parse(oldBalance.text) -
//           (double.parse(paidCard.text) + double.parse(paidCash.text));
//       totalRecieved=(double.parse(paidCard.text) + double.parse(paidCash.text));
//     });
//   }
//
//
//   Future<void> getOldBalance(String a) async {
//     await reference
//         .child("Vouchers")
//         .child(User.vanNo)
//         .once()
//         .then((DataSnapshot snapshot) {
//       Map<dynamic, dynamic> values = snapshot.value;
//       values.forEach((key, values) {
//         setState(() {
//           if (key.toString() == "VoucherNumber") {
//             voucherNo.text = User.voucherStarting +
//                 (int.parse(values.toString()) + 1).toString();
//           }
//         });
//       });
//     });
//
//   }
//
//
//   Future<List> getNames(String input) async {
//     List _list = new List();
//
//     await reference.child("Customers").once().then((DataSnapshot snapshot) {
//       Map<dynamic, dynamic> values = snapshot.value;
//       values.forEach((key, values) {
//         if(values['Name'].toString().toLowerCase().contains(input.toLowerCase())){
//           _list.add(values['Name'].toString());
//         }
//         if(values['CustomerCode'].toString().toLowerCase().contains(input.toLowerCase())){
//           _list.add(values['CustomerCode'].toString());
//         }
//       });
//     });
//
//     return _list;
//   }
//
//
//   void initState() {
//     // TODO: implement initState
//     reference = FirebaseDatabase.instance
//         .reference()
//         .child("Companies")
//         .child(User.database);
//     timer = Timer.periodic(duration, (Timer t) {
//       getBalance();
//     });
//     getOldBalance("");
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: buildAppBar(context),
//       body: WillPopScope(
//         onWillPop: () async {
//           timer.cancel();
//           return true;
//         },
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 25,
//                   ),
//                   Container(
//                       height: 25,
//                       width: 25,
//                       child: Image.asset("assets/images/voucher.png",
//                           fit: BoxFit.scaleDown, color: Colors.black)),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width * 0.8,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.0),
//                       color: const Color(0xffffffff),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0x29000000),
//                           offset: Offset(6, 3),
//                           blurRadius: 12,
//                         ),
//                       ],
//                     ),
//                     child: TextFormField(
//                         controller: voucherNo,
//                         decoration: InputDecoration(
//                           hintText: 'Voucher Number',
//                           //filled: true,
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.only(
//                               left: 15, bottom: 15, top: 15, right: 15),
//                           filled: false,
//                           isDense: false,
//                         )),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding:
//               const EdgeInsets.all(5),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 25,
//                   ),
//                   Icon(Icons.person,),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width *  0.8,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.0),
//                       color: const Color(0xffffffff),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0x29000000),
//                           offset: Offset(6, 3),
//                           blurRadius: 12,
//                         ),
//                       ],
//                     ),
//                     child: TextFieldSearch(
//                       // future: getNames,
//                       // initialList: dummyList,
//                         label: label,
//                         minStringLength: 0,
//                         // getSelectedValue: () {
//                         //   return got(textEditingController.text);
//                         // },
//                         future: () {
//                           return getNames(textEditingController.text);
//                         },
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'Enter Customer Name / Code',
//                           contentPadding: EdgeInsets.only(
//                               left: 15, top: 1, right: 15),
//                           filled: false,
//                           isDense: false,
//                         ),
//                         controller: textEditingController),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 25,
//                   ),
//                   Container(
//                       height: 25,
//                       width: 25,
//                       child: Image.asset("assets/images/balance.png",
//                           fit: BoxFit.scaleDown, color: Colors.black)),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                           width: MediaQuery.of(context).size.width * 0.8,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16.0),
//                             color: const Color(0xffffffff),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color(0x29000000),
//                                 offset: Offset(6, 3),
//                                 blurRadius: 12,
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 15, bottom: 15, top: 15, right: 15),
//                             child: Text(oldBalance.text),
//                           )),
//                       Text(
//                         "Old Balance",
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       )
//                     ],
//                   ),
//
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 25,
//                       ),
//                       Container(
//                           height: 25,
//                           width: 25,
//                           child: Image.asset("assets/images/balance.png",
//                               fit: BoxFit.scaleDown, color: Colors.black)),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       Container(
//                           width: MediaQuery.of(context).size.width * 0.8,
//                           height: 50,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16.0),
//                             color: const Color(0xffffffff),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color(0x29000000),
//                                 offset: Offset(6, 3),
//                                 blurRadius: 12,
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 15, bottom: 15, top: 15, right: 15),
//                             child: Text(finalBalance.toString()),
//                           )),
//                     ],
//                   ),
//                   Text(
//                     "Current Balance",
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 25,
//                   ),
//                   Container(
//                       height: 30,
//                       width: 30,
//                       child: Image.asset(
//                         "assets/images/cashrecived.png",
//                         fit: BoxFit.fill,
//                         //    color: Colors.black
//                       )),
//                   Text(
//                     "    Cash Received",
//                     style: TextStyle(fontSize: 18),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 30,
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.45 - 10,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16.0),
//                           color: const Color(0xffffffff),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0x29000000),
//                               offset: Offset(6, 3),
//                               blurRadius: 12,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                   height: 25,
//                                   width: 25,
//                                   child: Image.asset(
//                                     "assets/images/money.png",
//                                     fit: BoxFit.scaleDown,
//                                     //    color: Colors.black
//                                   )),
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.3,
//                               child: TextFormField(
//                                   controller: paidCash,
//                                   onChanged: payOn,
//                                   decoration: InputDecoration(
//                                     hintText: '',
//                                     //filled: true,
//                                     border: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 15,
//                                         top: 15,
//                                         right: 15),
//                                     filled: false,
//                                     isDense: false,
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         "Paid via cash",
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.45 - 10,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16.0),
//                           color: const Color(0xffffffff),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0x29000000),
//                               offset: Offset(6, 3),
//                               blurRadius: 12,
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                   height: 25,
//                                   width: 25,
//                                   child: Image.asset(
//                                     "assets/images/card.png",
//                                     fit: BoxFit.scaleDown,
//                                     //    color: Colors.black
//                                   )),
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.3,
//                               child: TextFormField(
//                                   controller: paidCard,
//                                   onChanged: payOn,
//                                   decoration: InputDecoration(
//                                     hintText: '',
//                                     border: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(
//                                         left: 15,
//                                         bottom: 15,
//                                         top: 15,
//                                         right: 15),
//                                     filled: false,
//                                     isDense: false,
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         "Paid via card",
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Padding(
//               padding:  EdgeInsets.only(left:25,right: 20),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16.0),
//                   color: const Color(0xffffffff),
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0x29000000),
//                       offset: Offset(6, 3),
//                       blurRadius: 12,
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                           height: 25,
//                           width: 25,
//                           child: Image.asset(
//                             "assets/images/balance.png",
//                             fit: BoxFit.scaleDown,
//                             //    color: Colors.black
//                           )),
//                     ),
//                     Container(
//                         width: MediaQuery.of(context).size.width * 0.1,
//                         child: Text(
//                           "Total : ",
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         )
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       child: Text(
//                         totalRecieved.toString(),
//                         style: TextStyle(fontSize: 14, color: Colors.grey),
//                       )
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 40,
//             ),
//             Center(
//               child: GestureDetector(
//                 onTap: () {
//                   if(voucherNo.text.isNotEmpty){
//                     if(paidCard.text.isNotEmpty||paidCash.text.isNotEmpty){
//                       addValues();
//                     }
//
//                   }
//
//                 },
//                 child: Container(
//                   height: 50,
//                   width: 100,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.0),
//                     gradient: LinearGradient(
//                       begin: Alignment(0.01, -0.72),
//                       end: Alignment(0.0, 1.0),
//                       colors: [
//                         const Color(0xff385194),
//                         const Color(0xff182d66)
//                       ],
//                       stops: [0.0, 1.0],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0x80182d66),
//                         offset: Offset(6, 3),
//                         blurRadius: 6,
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Text(
//                       'Save',
//                       style: TextStyle(
//                         fontFamily: 'Arial',
//                         fontSize: 18,
//                         color: const Color(0xfff7fdfd),
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   AppBar buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       centerTitle: true,
//       automaticallyImplyLeading: false,
//       title: Text(
//         "Receipt Portal",
//         style: TextStyle(color: Colors.black),
//       ),
//       iconTheme: IconThemeData(
//         color: Colors.black, //change your color here
//       ),
//       elevation: 0,
//       titleSpacing: 0,
//       toolbarHeight: 80,
//     );
//   }
// }
