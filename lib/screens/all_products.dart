import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllProductPage extends StatefulWidget {
  AllProductPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  AllProductPageState createState() => AllProductPageState();
}

class AllProductPageState extends State<AllProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          searchRow(),
          SizedBox(
            height: 10,
          ),
          homeData()
        ],
      ),
    );
  }

  searchRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
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
                hintText: 'Enter product name here',
                //filled: true,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 5, top: 15, right: 15),
                filled: false,
                isDense: false,
                prefixIcon: Icon(
                  Icons.search,
                  size: 25.0,
                  color: Colors.grey,
                ),
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Column(
              children: [
                Spacer(),
                Container(
                    height: 25,
                    width: 25,
                    child: Image.asset(
                      "assets/images/filter.png",
                      fit: BoxFit.scaleDown,
                      //    color: Colors.white
                    )),
                Spacer(),
                Text("Filter")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Column(
              children: [
                Spacer(),
                Container(
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      "assets/images/scan.png",
                      fit: BoxFit.scaleDown,
                      //    color: Colors.white
                    )),
                Spacer(),
                Text("Scan")
              ],
            ),
          ),
        ],
      ),
    );
  }

  homeData() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            itemCount: 20,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 0.7,),

            itemBuilder: (_, index) =>  Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width / 3 ,
                  child: Column(
                    children: [
                      Card(
                        child: Container(
                            height: MediaQuery.of(context).size.width / 3-20,
                            width:MediaQuery.of(context).size.width / 3-20,
                            child: Image.asset(
                              "assets/images/vegitable.png",
                              fit: BoxFit.cover,
                              //    color: Colors.white
                            )),
                      ),
                      Container(
                        height: 50,
                        child: Column(
                          children: [
                            Text(
                              'Product Name',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                color: const Color(0xff182d66),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                SizedBox(width: 10,),
                                Text(
                                  'Code:1234567',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 8,
                                    color: const Color(0xff182d66),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 10,),
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 8,
                                      color: const Color(0xff182d66),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Unit: Kg  In Stock: ',
                                      ),
                                      TextSpan(
                                        text: '123',
                                        style: TextStyle(
                                          color: const Color(0xffff0023),
                                        ),
                                      ),
                                    ],
                                  ),
                                  textHeightBehavior:
                                  TextHeightBehavior(applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 10,),
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 8,
                                      color: const Color(0xff182d66),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Sale Rate: ',
                                      ),
                                      TextSpan(
                                        text: '96 \$',
                                        style: TextStyle(
                                          color: const Color(0xff388e3c),
                                        ),
                                      ),
                                    ],
                                  ),
                                  textHeightBehavior:
                                  TextHeightBehavior(applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 10,),
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 8,
                                      color: const Color(0xff182d66),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Purchase Rate:',
                                      ),
                                      TextSpan(
                                        text: ' 28 \$',
                                        style: TextStyle(
                                          color: const Color(0xff388e3c),
                                        ),
                                      ),
                                    ],
                                  ),
                                  textHeightBehavior:
                                  TextHeightBehavior(applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            ),
          ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[900],
      centerTitle: false,
      title: Text("Product"),
      elevation: 1.0,
      titleSpacing: 0,
      toolbarHeight: 70,
    );
  }
}
