// @dart=2.9
import 'dart:convert';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/models/customers.dart';
import 'package:optimist_erp_app/screens/cash_receipt_bill.dart';
import 'dart:ui';
import 'package:textfield_search/textfield_search.dart';
import 'package:http/http.dart' as http;
import '../../app_config.dart';

class SaveRecieptPage extends StatefulWidget {
  @override
  ReturnsPageState createState() => ReturnsPageState();
}

class ReturnsPageState extends State<SaveRecieptPage> {
  var customername = TextEditingController();
  var customerid = TextEditingController();
  String customerAddress='';
  var remarks = TextEditingController();
  var card = TextEditingController();
  var cash = TextEditingController();
  var invoicedate = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List _list = [];
  String label = "Enter Customer Name";
  String recieptId = DateFormat('yyMMdd/kkmmss').format(DateTime.now());
  String balance='';
  bool isLoading=false;

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        invoicedate.text =
            selectedDate.year.toString() + "-" + selectedDate.month.toString() +
                "-" + selectedDate.day.toString();
      });
  }


  Future<List> getNames(String input) async {

    if (await DataConnectionChecker().hasConnection) {
      Map data = {'depotid': User.depotId, 'search': ""};
      //encode Map to JSON
      var body = json.encode(data);
      String url = AppConfig.DOMAIN_PATH + "customers";
      final response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        APICacheDBModel cacheDBModel =
        new APICacheDBModel(key: "cs", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        var json = jsonDecode(response.body);
        for (int i = 0; i < customersFromJson(response.body).length; i++) {
          _list.add(json[i]['Name']);
        }



        return _list;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } else {
      print("Data exists");
      var cacheData = await APICacheManager().getCacheData("cs");
      var json = jsonDecode(cacheData.syncData);
      for (int i = 0; i < customersFromJson(cacheData.syncData).length; i++) {
        _list.add(json[i]['Name']);
      }

      return _list;
    }


  }

  void initState() {
    invoicedate.text=selectedDate.year.toString() + "-" + selectedDate.month.toString() +
        "-" + selectedDate.day.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              "Add New Reciept",
              style:
              TextStyle(color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 30.0, right: 30),
            child: Card(
              elevation: 5,
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.bookmark,
                        size: 25.0,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Receipt ID : "+recieptId,
                        style:
                        TextStyle(color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 30.0, right: 30),
            child: Card(
              elevation: 5,
              child: TextFieldSearch(
                  label: label,
                  minStringLength: 0,
                  future: () {
                    setState(() {
                      balance='';
                    });
                    return getNames(customername.text);
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Customer Name',
                    contentPadding: EdgeInsets.only(
                        left: 15, top: 15, right: 15),
                    filled: false,
                    prefixIcon: Icon(
                      Icons.person,
                      size: 25.0,
                      color: Colors.grey,
                    ),
                  ),
                  controller: customername),
            ),
          ),
          SizedBox(
            height: 20,
          ),

          Padding(
            padding:
            const EdgeInsets.only(left: 30.0, right: 30),
            child: Card(
              elevation: 5,
              child: TextField(
                  decoration: InputDecoration(
                    hintText: balance,
                    contentPadding: EdgeInsets.only(
                        left: 15, top: 15, right: 15),
                    filled: false,
                    //enabled: false,
                    suffixIcon:  GestureDetector(
                      onTap: () async {
                        ///get Balance
                        var cacheData = await APICacheManager().getCacheData("cs");
                        var json1 = jsonDecode(cacheData.syncData);
                        for (int i = 0; i <
                            customersFromJson(cacheData.syncData).length; i++) {
                          if (customername.text == json1[i]['Name']) {
                            setState(() {
                              balance = json1[i]['Balance'].toString();
                            });
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Get Balance",style: TextStyle(color: Colors.blueAccent,fontSize: 15),),
                      ),
                    ),
                    prefixIcon: GestureDetector(
                      child: Icon(
                        Icons.account_balance_wallet_sharp,
                        size: 25.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              //    controller: customername
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 30.0, right: 30),
            child: Card(
              elevation: 5,
              child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cash Received',
                    contentPadding: EdgeInsets.only(
                        left: 15, top: 15, right: 15),
                    filled: false,
                    prefixIcon: Icon(
                      Icons.monetization_on,
                      size: 25.0,
                      color: Colors.grey,
                    ),
                  ),
                  controller: cash
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 30.0, right: 30),
            child: Card(
              elevation: 5,
              child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Card Received',
                    contentPadding: EdgeInsets.only(
                        left: 15, top: 15, right: 15),
                    filled: false,
                    prefixIcon: Icon(
                      Icons.card_membership_outlined,
                      size: 25.0,
                      color: Colors.grey,
                    ),
                  ),
                  controller: card
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 30.0, right: 30),
            child: GestureDetector(
              onTap: () {
                _selectDate();
              },
              child: Card(
                elevation: 5,
                child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: 'Invoice Date',
                      contentPadding: EdgeInsets.only(
                          left: 15, top: 15, right: 15),
                      filled: false,
                      prefixIcon: Icon(
                        Icons.date_range,
                        size: 25.0,
                        color: Colors.grey,
                      ),
                    ),
                    controller: invoicedate
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 30.0, right: 30),
            child: Card(
              elevation: 5,
              child: TextField(
                maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Remarks',
                    contentPadding: EdgeInsets.only(
                        left: 15, top: 15, right: 15),
                    filled: false,

                  ),
                  controller: remarks
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading=true;
                });
                if(customername.text.isNotEmpty){
                  if(balance==''){
                    EasyLoading.showError('Please fetch balance');
                    return null;
                  }
                  if(card.text.isNotEmpty || cash.text.isNotEmpty){
                    var cacheData = await APICacheManager().getCacheData("cs");
                    var json1 = jsonDecode(cacheData.syncData);

                    for (int i = 0; i <
                        customersFromJson(cacheData.syncData).length; i++) {
                      if (customername.text == json1[i]['Name']) {
                        setState(() {
                          customerid.text = json1[i]['id'].toString();
                          customerAddress = json1[i]['Address'].toString();
                        });
                      }
                    }

                    if (customerid != '') {
                      ///Api calling for add reciept
                      ///
                      String url = AppConfig.DOMAIN_PATH + "Receipt/Save";
                      Map data = {
                        'CustomerID': customerid.text,
                        'UserID': User.userId,
                        'OrderID': recieptId,
                        'Remarks': remarks.text,
                        'CashReceived': cash.text ?? '0',
                        'CardReceived': card.text ?? '0',
                        'InvoiceDate': selectedDate.toString()
                      };

                      var body = json.encode(data);

                      print(body);

                      final response = await http.post(
                        url,
                        body: body,
                        headers: {
                          'Content-Type': 'application/json',
                          'Accept': 'application/json',
                        },
                      );
                      print(response.body);

                      double  totalAmount=0;
                      double cashRecieved=0;
                      double cardRecieved=0;

                      if(cash.text.isNotEmpty&&card.text.isNotEmpty){
                        cashRecieved=double.parse(cash.text);
                        cardRecieved=double.parse(card.text);
                        totalAmount=double.parse(cash.text)+double.parse(card.text);
                      }else if(card.text.isEmpty){
                        cardRecieved=double.parse('0');
                        totalAmount=double.parse(cash.text);
                      }else{
                        cashRecieved=double.parse('0');
                        totalAmount=double.parse(card.text);
                      }

                      double a=double.parse(balance);

                      double availableBalance=a-totalAmount;

                      

                      
                      if (response.statusCode == 200) {
                        EasyLoading.showSuccess('New Reciept added...');
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return CashReceiptPage(
                            customerName: customername.text,
                            voucherNumber: recieptId,
                            date:  selectedDate.toString(),
                            customerCode: customerid.text,
                            customerBalance:availableBalance.toStringAsFixed(3),
                            card: cardRecieved.toStringAsFixed(3),
                            cash: cashRecieved.toStringAsFixed(3),
                            billAmount: totalAmount.toStringAsFixed(3),
                            back: false,
                          );
                        }));
                      } else {
                        EasyLoading.showError('Something wrong...');
                      }
                    } else {
                      EasyLoading.showError('No Customer ID found');
                    }
                  }else{
                    EasyLoading.showError('Enter Cash/Card');
                  }

                }else{
                  EasyLoading.showError('Enter Customer Name');
                }
                setState(() {
                  isLoading=false;
                });
              },
              child: Padding(
                padding:
                const EdgeInsets.only(left: 30.0, right: 30),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0, -1.0),
                      end: Alignment(0.0, 1.0),
                      colors: [
                        const Color(0xff00ecb2),
                        const Color(0xff12b3e3)
                      ],
                      stops: [0.0, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffcdcdcd),
                        offset: Offset(6, 3),
                        blurRadius: 6,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    child: Row(
                      children: [
                        Spacer(),
                        isLoading ? CircularProgressIndicator(color: Colors.white,) :Text(
                          " Add Receipt",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
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
        "Save Reciept",
        style: TextStyle(color: Colors.white),
      ),
      elevation: 0,
      titleSpacing: 0,
      toolbarHeight: 80,
    );
  }
}
