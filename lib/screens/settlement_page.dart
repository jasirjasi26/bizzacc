import 'package:adobe_xd/page_link.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettlementPage extends StatefulWidget {
  SettlementPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SettlementPageState createState() => SettlementPageState();
}

class SettlementPageState extends State<SettlementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ListView(
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
                    borderRadius: BorderRadius.circular(16.0),
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
                      // controller: _username,
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.35-10,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
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
                      // controller: _username,
                      decoration: InputDecoration(
                    hintText: 'Old Balance',
                    //filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 15, top: 15, right: 15),
                    filled: false,
                    isDense: false,
                  )),
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.35-10,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
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
                      decoration: InputDecoration(
                    hintText: 'Bill Amount',
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
                        borderRadius: BorderRadius.circular(16.0),
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
                                // controller: _username,
                                decoration: InputDecoration(
                              hintText: '',
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
                        borderRadius: BorderRadius.circular(16.0),
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
                                decoration: InputDecoration(
                              hintText: '',
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
                  color: const Color(0xff5b5b5b),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45 - 10,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
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
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                      decoration: InputDecoration(
                    hintText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 15, top: 15, right: 15),
                    filled: false,
                    isDense: false,
                  )),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xff8561f0),
                        ),
                        child: Image.asset(
                          "assets/images/back.png",
                          fit: BoxFit.scaleDown,
                             color: Colors.white
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xff8561f0),
                        ),
                        child: Image.asset(
                            "assets/images/front.png",
                            fit: BoxFit.scaleDown,
                            color: Colors.white
                        ),
                      )
                    ],
                  ),
                  Text("Round Off", style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xff5b5b5b),
                  ),)
                ],
              ),

            ],
          ),
          SizedBox(
            height: 40,
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
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      begin: Alignment(0.0, -4.12),
                      end: Alignment(0.0, 1.0),
                      colors: [
                        const Color(0xffffffff),
                        const Color(0xfffaa731)
                      ],
                      stops: [0.0, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xfffae7cb),
                        offset: Offset(6, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(child: Text("0.00")),
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
                  'Balance   ',
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
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      begin: Alignment(0.0, -4.12),
                      end: Alignment(0.0, 1.0),
                      colors: [
                        const Color(0xffffffff),
                        const Color(0xfffb4ce5)
                      ],
                      stops: [0.0, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xfffae7cb),
                        offset: Offset(6, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(child: Text("0.00")),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 50,
                width: 100,
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
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      automaticallyImplyLeading: true,
      title: Text(
        "Settlements",
        style: TextStyle(color: Colors.black),
      ),
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      elevation: 0,
      titleSpacing: 0,
      toolbarHeight: 80,
    );
  }
}
