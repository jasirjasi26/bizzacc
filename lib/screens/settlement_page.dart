// @dart=2.9
import 'dart:convert';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:optimist_erp_app/data/customed_details.dart';
import 'package:http/http.dart' as http;
import 'package:optimist_erp_app/screens/van_page.dart';
import '../app_config.dart';
import '../controller.dart';
import '../contactinfomodel.dart';
import '../data/user_data.dart';

class SettlementPage extends StatefulWidget {
  SettlementPage(
      {Key key,
      this.customerName,
      this.date,
      this.values,
      this.balance,
      this.radioValue})
      : super(key: key);
  final int radioValue;
  final String balance;
  final String date;
  final String customerName;
  final Map<String, dynamic> values;

  @override
  SettlementPageState createState() => SettlementPageState();
}

class SettlementPageState extends State<SettlementPage> {
  var voucherNo = TextEditingController();
  var billAmount = TextEditingController();
  var oldBalance = TextEditingController();
  var paidCash = TextEditingController();
  var paidCard = TextEditingController();
  var subTotal = TextEditingController();
  double finalBalance = 0;
  var totalDisc = 0.0;
  double rounoff = 0;
  double totalReceived = 0;
  bool isLoading=false;

  roundOff() {
    double total;
    setState(() {
      total = double.parse(subTotal.text);
      subTotal.text = double.parse(subTotal.text).round().toString();
      rounoff = double.parse(subTotal.text) - total;
    });
  }

  roundDown() {
    double total;
    setState(() {
      total = double.parse(subTotal.text);
      subTotal.text = double.parse(subTotal.text).floor().toString();
      rounoff = total - double.parse(subTotal.text);
    });
  }

  payOn(String a) {
    finalBalance = double.parse(widget.balance) + double.parse(subTotal.text);
    setState(() {
      finalBalance = finalBalance -
          (double.parse(paidCard.text) + double.parse(paidCash.text));
      totalReceived =
          (double.parse(paidCard.text) + double.parse(paidCash.text));
      finalBalance=double.parse(finalBalance.toStringAsFixed(User.decimals));
    });
  }

  addValues() async {
setState(() {
  isLoading=true;
});

    Map<String, dynamic> datas = {
      'Balance': finalBalance,
      'CardReceived': paidCard.text,
      'CashReceived': paidCash.text,
      'RoundOff': rounoff.toStringAsFixed(User.decimals),
      'UpdatedTime': DateTime.now().toString(),
    };

    Map<String, dynamic> finalData=widget.values;
    finalData.addEntries(datas.entries);

    var body=jsonEncode(finalData);

    if (await DataConnectionChecker().hasConnection) {
      print("Mobile data detected & internet connection confirmed.");
      String url=AppConfig.DOMAIN_PATH+"salesinvoice/save";
      final response = await http.post(url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        setState(() {
          isLoading=false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VanPage(
            customerName: widget.customerName,
            voucherNumber: voucherNo.text,
            date: widget.date,
            data:finalData,
            billAmount: widget.values['BillAmount'].toString(),
            back: false,
          );
        }));
      }else{
        setState(() {
          isLoading=false;
        });
        EasyLoading.showError('Failed');
        print("Failed");
      }
    }else{
      APICacheDBModel cacheDBModel =
      new APICacheDBModel(key: widget.values['InvoiceID'].toString(), syncData: body);
      await APICacheManager().addCacheData(cacheDBModel).then((value) => {
        if(value){
          saveToDb()
        }
      });
    }
  }

  saveToDb() async {
    ContactinfoModel contactinfoModel = ContactinfoModel(id: null,userId: widget.values['InvoiceID'].toString(),createdAt: "Invoice");
    await Controller().addData(contactinfoModel).then((value){
      if (value>0) {
        print("Success");
        EasyLoading.showSuccess('Successfully Saved');
      }else{
        print("failed");
      }
    });
  }




  void initState() {
    // TODO: implement initState
    setState(() {
      oldBalance.text = widget.balance;
      finalBalance=double.parse(widget.balance)+double.parse(widget.values['BillAmount']);
      finalBalance=double.parse(finalBalance.toStringAsFixed(User.decimals));
      billAmount.text = widget.values['BillAmount'].toString();
      subTotal.text = widget.values['BillAmount'].toString();
      paidCash.text = "0";
      paidCard.text = "0";
      voucherNo.text=widget.values['InvoiceID'].toString();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Stack(
          children: [
            ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                          height: 25,
                          width: 25,
                          child: Image.asset("assets/images/voucher.png",
                              fit: BoxFit.scaleDown, color: Colors.black)),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
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
                            controller: voucherNo,
                            decoration: InputDecoration(
                              hintText: 'Voucher Number',
                              //filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 15, top: 15, right: 15),
                              filled: false,
                              isDense: false,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                          height: 25,
                          width: 25,
                          child: Image.asset("assets/images/balance.png",
                              fit: BoxFit.scaleDown, color: Colors.black)),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.35 - 10,
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
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15, bottom: 15, top: 15, right: 15),
                                child: Text(oldBalance.text),
                              )),
                          Text(
                            "Old Balance",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          height: 25,
                          width: 25,
                          child: Image.asset("assets/images/balance.png",
                              fit: BoxFit.scaleDown, color: Colors.black)),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.35 - 10,
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
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15, bottom: 15, top: 15, right: 15),
                                child: Text(billAmount.text),
                              )),
                          Text(
                            "Bill Amount",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Container(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            "assets/images/cashrecived.png",
                            fit: BoxFit.fill,
                            //    color: Colors.black
                          )),
                      Text(
                        "    Cash Received",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45 - 10,
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
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 25,
                                      width: 25,
                                      child: Image.asset(
                                        "assets/images/money.png",
                                        fit: BoxFit.scaleDown,
                                        //    color: Colors.black
                                      )),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: TextFormField(
                                      controller: paidCash,
                                      onChanged: payOn,
                                      decoration: InputDecoration(
                                        hintText: '',
                                        //filled: true,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            top: 15,
                                            right: 15),
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Paid via cash",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45 - 10,
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
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 25,
                                      width: 25,
                                      child: Image.asset(
                                        "assets/images/card.png",
                                        fit: BoxFit.scaleDown,
                                        //    color: Colors.black
                                      )),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: TextFormField(
                                      controller: paidCard,
                                      onChanged: payOn,
                                      decoration: InputDecoration(
                                        hintText: '',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            top: 15,
                                            right: 15),
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Paid via card",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '   Subtotal  ',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
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
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 15, bottom: 15, top: 15, right: 15),
                            child: Text(subTotal.text),
                          )),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                roundDown();
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color:  Colors.blueGrey,
                                ),
                                child: Image.asset("assets/images/back.png",
                                    fit: BoxFit.scaleDown, color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                roundOff();
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.blueGrey,
                                ),
                                child: Image.asset("assets/images/front.png",
                                    fit: BoxFit.scaleDown, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        Text(
                          "Round Off",
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 12,
                            color: const Color(0xff5b5b5b),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        'Grand Total  ',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 1.0),
                            colors: [
                              const Color(0xff00ecb2),
                              const Color(0xff22bef1)
                            ],
                            stops: [0.0, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x80747474),
                              offset: Offset(6, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Center(child: Text(subTotal.text)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        'New Balance   ',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Container(
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 1.0),
                            colors: [
                              const Color(0xff00ecb2),
                              const Color(0xff22bef1)
                            ],
                            stops: [0.0, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x80747474),
                              offset: Offset(6, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Center(child: Text(finalBalance.toString())),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      addValues();
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color(0xff20474f),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x85747474),
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
                  ),
                ),
              ],
            ),
            isLoading?Center(child: CircularProgressIndicator()):Container(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff20474f),
      centerTitle: false,
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      automaticallyImplyLeading: true,
      title: Text(
        "Settlements",
        style: TextStyle(color: Colors.white),
      ),
      elevation: 0,
      titleSpacing: 0,
      toolbarHeight: 120,
    );
  }
}
