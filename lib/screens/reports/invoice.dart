// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:optimist_erp_app/screens/setleAfterOrder.dart';
import '../../app_config.dart';
import '../../models/all_invoice.dart';
import '../../models/all_orders.dart';
import '../setleAfterOrder.dart';

class InvoicePage extends StatefulWidget {
  @override
  StockReportsState1 createState() => StockReportsState1();
}

class StockReportsState1 extends State<InvoicePage> {
  var name = TextEditingController();
  Future<AllOrder> fetchOrders;
  Future<AllInvoice> fetchInvoice;
  String today = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString();

  DateTime selectedDate = DateTime.now();
  String from = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString();

  String to = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        from = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
    fetchOrders = fetchDatas();
     fetchInvoice = fetchInvoiceDatas();
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        to = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });

    fetchOrders = fetchDatas();
    fetchInvoice = fetchInvoiceDatas();
  }

  Future<AllOrder> fetchDatas() async {

    Map data = {'from_Date': from, 'to_Date': to, "billed": "0"};
    //encode Map to JSON
    var body = json.encode(data);
    String url = AppConfig.DOMAIN_PATH + "salesorder/showall";
    final response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // APICacheDBModel cacheDBModel =
      //     new APICacheDBModel(key: "orderlist", syncData: response.body);
      // await APICacheManager().addCacheData(cacheDBModel);
      print(response.body);
      return allOrderFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<AllInvoice> fetchInvoiceDatas() async {
    Map data = {
      'from_Date': from,
      'to_Date': to,
    };
    //encode Map to JSON
    var body = json.encode(data);
    String url = AppConfig.DOMAIN_PATH + "salesinvoice/showall";
    final response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // APICacheDBModel cacheDBModel =
      //     new APICacheDBModel(key: "invoicelist", syncData: response.body);
      // await APICacheManager().addCacheData(cacheDBModel);

      return allInvoiceFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  deleteOrder(String id) async {
    print(id);
    Map data = {
      'Order_id': id,
    };
    //encode Map to JSON
    var body = json.encode(data);
    String url = AppConfig.DOMAIN_PATH + "salesorder/delete";
    final response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      EasyLoading.showSuccess('Successfully Deleted');
      setState(() {
        fetchOrders=fetchDatas();
      });

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete');
    }
  }

  getSingleOrder(String id) async {
    Map data = {
      'Order_id': id,
    };
    //encode Map to JSON
    var body = json.encode(data);
    String url = AppConfig.DOMAIN_PATH + "salesorder/show";
    final response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      EasyLoading.showSuccess(data.toString());
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) {
      //       return EditOrderPage(
      //         orderId: id,
      //         customerName: data["CustomerName"].toString(),
      //         salesType: data["SalesTypeID"].toString(),
      //       );
      //     }));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete');
    }
  }

  void initState() {
    // TODO: implement initState

    fetchOrders = fetchDatas();
    fetchInvoice = fetchInvoiceDatas();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ListView(
        children: [searchRow(), salesOrder()],
      ),
    );
  }

  searchRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      color: Color(0xff20474f),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.93,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(6, 3),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: TextFormField(
                      controller: name,
                      // onChanged: getCustomerId,
                      decoration: InputDecoration(
                        hintText: 'Enter customer name here',
                        //filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 5, top: 15, right: 15),
                        filled: false,
                        isDense: false,
                        prefixIcon: Icon(
                          Icons.person,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      )),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '  From : ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 13,
                    color: Color(0xffb0b0b0),
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Text(
                    from,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 13,
                        color: Colors.white,
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'To',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 13,
                    color: Color(0xffb0b0b0),
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _selectToDate(context);
                  },
                  child: Text(
                    to,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 13,
                        color: Colors.white,
                        decoration: TextDecoration.underline),
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

  salesOrder() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: 600,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Container(
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xff454d60),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'VoucherNo',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: const Color(0xffffffff),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xffffffff),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Customer Name',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: const Color(0xffffffff),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Amount',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: const Color(0xffffffff),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<AllInvoice>(
                    future: fetchInvoiceDatas(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.data.length,
                              // ignore: missing_return
                              itemBuilder: (context, index) {
                                if (snapshot.data.data[index].customerName
                                    .toLowerCase()
                                    .contains(name.text.toLowerCase())) {
                                  return Container(
                                    height: 28,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: index.floor().isEven
                                          ? Color(0x66d6d6d6)
                                          : Color(0x66f3ceef),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            snapshot.data.data[index].voucherNo,
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(
                                            snapshot.data.data[index].invoiceDate
                                                .toString(),
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Container(
                                          width: 180,
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              snapshot.data.data[index].customerName,
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            snapshot.data.data[index].grandTotal
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                              fontFamily: 'Arial',
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),

                                      ],
                                    ),
                                  );
                                }
                              }),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ],
          ),
        ));
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
        'Invoice List',
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.left,
      ),
      elevation: 0,
      titleSpacing: 0,
      //toolbarHeight: 0,
    );
  }
}
