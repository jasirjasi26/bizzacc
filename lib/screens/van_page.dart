import 'dart:io';

import 'package:adobe_xd/pinned.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:optimist_erp_app/data/customed_details.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/ui_elements/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:optimist_erp_app/ui_elements/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class VanPage extends StatefulWidget {
  VanPage(
      {Key key,
      this.customerName,
      this.date,
      this.voucherNumber,this.billAmount})
      : super(key: key);

  final String date;
  final String customerName;
  final String voucherNumber;
  final String billAmount;


  @override
  VanPageState createState() => VanPageState();
}

class VanPageState extends State<VanPage> {

  DatabaseReference reference;
  List<String> total = [];
  List<String> item = [];
  List<String> rate = [];
  List<String> qty = [];
  List<String> tax = [];
  List<dynamic> disc = [];
  String cash="";
  String card="";
  String roundOff="";
  String balance="";
  String totaltax="";
  var totalDisc=0.0;
  String bill="";
  String generatedPdfFilePath;

  Future<void> generateExampleDocument() async {
    final htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
        <style>
        table, th, td {
          border: 1px solid black;
          border-collapse: collapse;
        }
        th, td, p {
          padding: 5px;
          text-align: left;
        }
        </style>
      </head>
      <body>
        <h2>PDF Generated with flutter_html_to_pdf plugin</h2>
        
        <table style="width:100%">
          <caption>Sample HTML Table</caption>
          <tr>
            <th>Month</th>
            <th>Savings</th>
          </tr>
          <tr>
            <td>January</td>
            <td>100</td>
          </tr>
          <tr>
            <td>February</td>
            <td>50</td>
          </tr>
        </table>
        
        <p>Image loaded from web</p>
        <img src="https://i.imgur.com/wxaJsXF.png" alt="web-img">
      </body>
    </html>
    """;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final targetFileName = "example-pdf";

    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(htmlContent, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;
  }



  Future<void> getBill() async {
    reference..child("Bills").child(widget.date).child(User.vanNo).child(widget.voucherNumber).child("Items").once().then((DataSnapshot snapshot) {
      List<dynamic> value = snapshot.value;
      for (int i = 0; i < value.length; i++) {
        if (value[i] != null) {
          setState(() {
            item.add(value[i]['ItemName'].toString());
            qty.add(value[i]['Qty'].toString());
            tax.add(value[i]['TaxAmount'].toString());
            total.add(value[i]['Total'].toString());
            rate.add(value[i]['Rate'].toString());
            totalDisc=totalDisc+double.parse(value[i]['DiscAmount'].toString());
          });
          }}
    });

    reference.child("Bills")..child(widget.date).child(User.vanNo).child(widget.voucherNumber).once().then((DataSnapshot snapshot) async {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, value) {
        setState(() {
          cash=values['CashReceived'].toString();
          card=values['CardReceived'].toString();
          roundOff=values['RoundOff'].toString();
          balance=values['Balance'].toString();
          totaltax=values['TaxAmount'].toString();
          bill=values['Amount'].toString();
        });
      });
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
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: WillPopScope(
        onWillPop: () async {
          // You can do some work here.
          // Returning true allows the pop to happen, returning false prevents it.
          return false;
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: Container(
                      height: 50,
                      width: 120,
                      child: Image.asset(
                        'assets/images/cybrix logo.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => super.widget));
                      },
                      child: Icon(Icons.refresh,size: 30,))
                ],
              ),
            ),
            homeData()
          ],
        ),
      ),
    );
  }

  homeData() {
    return Column(
      children: [
        Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Pinned.fromPins(
                Pin(start: 0.0, end: 0.0),
                Pin(start: 0.0, end: 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
              Pinned.fromPins(
                Pin(size: 113.0, end: 0.0),
                Pin(size: 17.0, start: 39.0),
                child: Text(
                  'Voucher Number',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 15,
                    color: const Color(0xff5b5b5b),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Pinned.fromPins(
                Pin(size: 53.0, end: 12.0),
                Pin(size: 17.0, start: 60.0),
                child: Text(
                  widget.voucherNumber,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 15,
                    color: const Color(0xff5b5b5b),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
          child: Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(size: 250.0, start: 3.5),
                  Pin(size: 14.0, start: 0.0),
                  child: Text(
                    'Party Name : ' + widget.customerName,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 32.0, start: 3.5),
                  Pin(size: 14.0, middle: 0.1957),
                  child: Text(
                    'Date :',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 53.0, end: 0),
                  Pin(size: 11.0, middle: 0.2075),
                  child: Text(
                    widget.date,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 50.0, start: 3.5),
                  Pin(size: 14.0, middle: 0.3915),
                  child: Text(
                    'Balance :',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 33.0, end: 15),
                  Pin(size: 14.0, middle: 0.3915),
                  child: Text(
                    Customer.balance,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 56.0, start: 3.5),
                  Pin(size: 14.0, middle: 0.5872),
                  child: Text(
                    'Van No : ' + User.vanNo,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 132.0, end: -20),
                  Pin(size: 14.0, middle: 0.5872),
                  child: Text(
                    'Driver : ' + User.number,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15,),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[500],
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ITEM',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 10,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'QTY',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 10,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'RATE',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 10,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'TAX',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 10,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'TOTAL',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 10,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: const EdgeInsets.only(left: 15, right: 15,),
            children: new List.generate(
             item.length ,
              (index) => Container(
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
                    Container(
                      width: 180,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item[index],
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
                        qty[index],
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
                       rate[index],
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
                        tax[index],
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
                        total[index],
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 5, right: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Company Name & Address',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    letterSpacing: 3,
                    color: const Color(0xff5b5b5b),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [

                Padding(
                  padding: EdgeInsets.only(left:15.0,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(totaltax,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:15.0,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RoundOff',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(roundOff,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:15.0,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cash',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(cash,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:15.0,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Card',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(card,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:15.0,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(totalDisc.toString(),
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:15.0,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Balance',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(balance,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: EdgeInsets.only(left:15.0,right: 15,top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bill Amount',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(bill,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BottomBar();
            }));
          },
          child: Container(
            width: 100,
            height: 45,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      begin: Alignment(0.01, -0.72),
                      end: Alignment(0.0, 1.0),
                      colors: [const Color(0xff385194), const Color(0xff182d66)],
                      stops: [0.0, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x80182d66),
                        offset: Offset(6, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 18,
                        color: const Color(0xfff7fdfd),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[900],
      automaticallyImplyLeading: false,
      centerTitle: false,
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: Container(
            height: 18,
            width: 40,
            child: Image.asset(
              'assets/images/print.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: GestureDetector(
            onTap: (){
             generateExampleDocument();
            },
            child: Container(
              height: 15,
              width: 25,
              child: Image.asset(
                'assets/images/pdf.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
      ],
      elevation: 1.0,
      titleSpacing: 0,
      toolbarHeight: 70,
    );
  }
}
