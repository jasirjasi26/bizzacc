// @dart=2.9
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:optimist_erp_app/screens/setleAfterOrder.dart';
import '../../app_config.dart';
import 'package:optimist_erp_app/models/ledger.dart';

import '../../models/bill_balance.dart';


class BillBalance extends StatefulWidget {
  @override
  SalesLedgerState createState() => SalesLedgerState();
}

class SalesLedgerState extends State<BillBalance> {
  Future<Billbalance> ledger;
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
      ledger=fetchInvoiceDatas();
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
      ledger=fetchInvoiceDatas();
    });
  }

  Future<Billbalance> fetchInvoiceDatas() async {
    Map data = {
      'from_Date': from,
      'to_Date': to,
      'Account_id':302632,
    };
    //encode Map to JSON
    var body = json.encode(data);
    String url = AppConfig.DOMAIN_PATH + "billbalancereport";
    final response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    // print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return billbalanceFromJson(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    // TODO: implement initState
    ledger=fetchInvoiceDatas();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff20474f),
        centerTitle: false,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        automaticallyImplyLeading: true,
        title: Text(
          'Bill Balance Reports',
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
        toolbarHeight: 80,
      ),
      body: Column(
        children: [searchRow(), salesOrder()],
      ),
    );
  }

  searchRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      color: Color(0xff20474f),
      child: Column(
        children: [
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
    return Column(
      children: [
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xff454d60),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Voucher No',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Date',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Amount',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Balance',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Due',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<Billbalance>(
              future: ledger,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.length+1,
                      itemBuilder: (context, index) {
                        if(index<snapshot.data.data.length){
                          return Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: index.floor().isEven
                                  ? Color(0x66d6d6d6)
                                  : Color(0x66f3ceef),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data.data[index].voucherNo ?? "--",
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
                                    snapshot.data.data[index].voucherDate
                                        .toString(),
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data.data[index].amount
                                        .toString(),
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data.data[index].balance
                                        .toString(),
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data.data[index].overDue
                                        .toString() ??"--",
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
                        }else{
                          return Column(
                            children: [
                              Container(
                                height: 10,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Color(0x66f3ceef),
                                ),),
                              Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: index.floor().isEven
                                      ? Color(0x66d6d6d6)
                                      : Color(0x66f3ceef),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Total Amount "
                                        ,
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data.totalAmount.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: index.floor().isEven
                                      ? Color(0x66d6d6d6)
                                      : Color(0x66f3ceef),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Total Balance "
                                        ,
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data.totalBalance.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }

                      }
                  );
                }else{
                  return Container(height:50,width:50,child: Center(child: CircularProgressIndicator()));
                }
              }),
        ),
      ],
    );
  }
}
