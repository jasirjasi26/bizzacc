import 'package:adobe_xd/page_link.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  bool select = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ListView(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              select = true;
                            });
                          },
                          child: Text(
                            'Sales Order',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 16,
                              color: select ? Colors.black : Color(0xffb0b0b0),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Divider(
                          color: Colors.blue,
                          height: 10,
                          thickness: 2,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            select = false;
                          });
                        },
                        child: Text(
                          'Sales Invoice',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 16,
                            color: select ? Color(0xffb0b0b0) : Colors.black,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Divider(
                        color: Colors.blue,
                        height: 10,
                        thickness: 2,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          searchRow(),
          select ? salesOrder() : salesInvoice()
        ],
      ),
    );
  }

  searchRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
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
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Container(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      "assets/images/calender.png",
                      fit: BoxFit.scaleDown,
                      //    color: Colors.white
                    )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'From',
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
                Text(
                  '22/12/2021',
                  style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 13,
                      color: Colors.black,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.left,
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
                Text(
                  '25/12/2021',
                  style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 13,
                      color: Colors.black,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Container(
            height: 25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color(0xff454d60),
            ),
            child: Row(
              children: [
                Text(
                  '   V No ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '  Date ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '  Name ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                Spacer(),
                Text(
                  ' Code  ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  ' Amt  ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  ' Status  ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  ' Action   ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                )
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
        Row(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: const Color(0x80f2aeae),
                ),
                child: Text(
                  '   Pending   ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xfff50e0e),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.blue[900],
                ),
                child: Text(
                  '   Pending   ',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            )
          ],
        ),
        Column(
          children: [
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            )
          ],
        )
      ],
    );
  }

  salesInvoice() {
    return Column(
      children: [
        Row(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                 // color: const Color(0x80f2aeae),
                ),
                child: Container(
                    height: 20,
                    width: 20,
                    child: Image.asset("assets/images/eye.png",
                        fit: BoxFit.scaleDown,
                    //    color: Colors.blue
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  //color: Colors.blue[900],
                ),
                child: Container(
                    height: 20,
                    width: 20,
                    child: Image.asset("assets/images/download.png",
                        fit: BoxFit.scaleDown,
                        //color: Colors.white
                    )),
              ),
            )
          ],
        ),
        Column(
          children: [
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66d6d6d6),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0x66f3ceef),
              ),
            )
          ],
        )
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      automaticallyImplyLeading: true,
      title: Text(
        "Order List",
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      titleSpacing: 0,
      toolbarHeight: 80,
    );
  }
}
