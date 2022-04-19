// @dart=2.9
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../app_config.dart';
import 'package:optimist_erp_app/models/ledger.dart';

import '../../app_config.dart';

class SalesLedger extends StatefulWidget {
  @override
  SalesLedgerState createState() => SalesLedgerState();
}

class SalesLedgerState extends State<SalesLedger> {
  Future<Ledger> ledger;
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
  bool isloading=false;

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

  Future<Ledger> fetchInvoiceDatas() async {
    setState(() {
      isloading=true;
    });
    Map data = {
      'from_Date': from,
      'to_Date': to,
      'Account_id':name.text,
    };
    //encode Map to JSON
    var body = json.encode(data);
    String url = AppConfig.DOMAIN_PATH + "ledgerreport";
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
      setState(() {
        isloading=false;
      });
      return ledgerFromJson(response.body);
    } else {
      setState(() {
        isloading=false;
      });
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
          'Ledger Reports',
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
      body: Stack(
        children: [
          Column(
            children: [searchRow(), salesOrder()],
          ),
          isloading ? Center(child: Container(width: 50,height:50,child: CircularProgressIndicator())):Container()
        ],
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
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
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
                      decoration: InputDecoration(
                        hintText: 'Enter Customer Id',
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
              GestureDetector(
                onTap: (){
                  setState(() {
                    ledger=fetchInvoiceDatas();
                  });
                },
                child: Card(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Icon(Icons.search,color: Colors.blueGrey,),
                  ),
                ),
              )
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
                width: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Particulars',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Debit',
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
                  'Credit',
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

            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<Ledger>(
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
                                    snapshot.data.data[index].particulars,
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    snapshot.data.data[index].debit
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
                                    snapshot.data.data[index].credit
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

                              ],
                            ),
                          );
                        }else{
                          return Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
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
                                      child: Text("Total Debit "
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
                                        snapshot.data.totalDebit.toString(),
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
                                      child: Text("Total Credit "
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
                        snapshot.data.totalCredit.toString(),
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
