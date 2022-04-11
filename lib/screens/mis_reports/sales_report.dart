// @dart=2.9
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../../app_config.dart';
import '../../models/productwicereport.dart';

class SalesReport extends StatefulWidget {


  @override
  StockReportsState1 createState() => StockReportsState1();
}

class StockReportsState1 extends State<SalesReport> {
  var name = TextEditingController();
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
  Future<Salesinvoicedetail> salesDetails;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now())
      setState(() {
        from = picked.year.toString() +
            "-" +
            picked.month.toString() +
            "-" +
            picked.day.toString();
      });

    setState(() {
      salesDetails=fetchData();
    });
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now())
      setState(() {
        to = picked.year.toString() +
            "-" +
            picked.month.toString() +
            "-" +
            picked.day.toString();
      });

    setState(() {
      salesDetails=fetchData();
    });
  }


  Future<Salesinvoicedetail> fetchData() async {

    Map data = {
      'from_Date': from,
      'to_Date': to,
      //'Account_id':302632
      'product':name.text
    };
      //encode Map to JSON
      var body = json.encode(data);
      String url = AppConfig.DOMAIN_PATH + "salesinvoice/showdetail";
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
        print(response.body);
        return salesinvoicedetailFromJson(response.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
  }



  void initState() {
    salesDetails=fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  buildAppBar(context) ,
      body: Column(
        children: [searchRow(), salesOrder()],
      ),
    );
  }

  searchRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xff20474f),
      height: 120,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                      onChanged: (data) {
                        setState(() {
                          salesDetails = fetchData();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter product name here',
                        //filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 5, top: 15, right: 15),
                        filled: false,
                        isDense: false,
                        prefixIcon: Icon(
                          Icons.settings_input_composite_outlined,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      )),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
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
    return Container(
      width: 600,
      height: MediaQuery.of(context).size.height*0.75,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: 600,
            height: MediaQuery.of(context).size.height*0.8,
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
                        width: 170,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Product',
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
                          'Qty',
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
                          'Rate',
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
                          'Tax',
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
                          'Net Amount',
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
                  child: FutureBuilder<Salesinvoicedetail>(
                      future: fetchData(),
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
                                              snapshot.data.data[index].voucherNo.toString(),
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
                                            width: 170,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                snapshot.data.data[index].product,
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
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data.data[index].qty
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data.data[index].rate
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data.data[index].vat
                                                  .toString(),
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data.data[index].netAmount
                                                  .toString(),
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
                        ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
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
        'Sales Reports',
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
