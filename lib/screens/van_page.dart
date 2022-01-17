
import 'package:adobe_xd/page_link.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class VanPage extends StatefulWidget {
  VanPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  VanPageState createState() => VanPageState();
}

class VanPageState extends State<VanPage> {

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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffb0b0b0),
                  ),
                  child: Center(
                    child: Text(
                      'Company Logo',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 15,
                        color: const Color(0xfff9f9f9),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
          homeData()
        ],
      ),
    );
  }

  homeData(){
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
                  'VS3456',
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
          padding: const EdgeInsets.only(left: 15,right: 15,top: 80),
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(size: 111.0, start: 3.5),
                  Pin(size: 14.0, start: 0.0),
                  child: Text(
                    'Party Name : Party 1',
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
                  Pin(size: 63.0, end: 0),
                  Pin(size: 11.0, middle: 0.2075),
                  child: Text(
                    'DD/MM/YYYY',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 10,
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
                  Pin(size: 33.0, end: 0.5),
                  Pin(size: 14.0, middle: 0.3915),
                  child: Text(
                    '58954',
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
                    'Van No : 2',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 24.0, start: 3.5),
                  Pin(size: 11.0, end: 2.5),
                  child: Text(
                    'ITEM',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 10,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 21.0, middle: 0.4439),
                  Pin(size: 11.0, end: 2.5),
                  child: Text(
                    'QTY',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 10,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 26.0, middle: 0.6173),
                  Pin(size: 11.0, end: 2.5),
                  child: Text(
                    'RATE',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 10,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 19.0, middle: 0.7818),
                  Pin(size: 11.0, end: 2.5),
                  child: Text(
                    'TAX',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 10,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 31.0, end: 7.5),
                  Pin(size: 11.0, end: 2.5),
                  child: Text(
                    'TOTAL',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 10,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 132.0, end: -20),
                  Pin(size: 14.0, middle: 0.5872),
                  child: Text(
                    'Driver : + 971551549870',
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
          padding: const EdgeInsets.only(left:15.0,top: 35,right: 15),
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
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Pinned.fromPins(
              Pin(start: 20.0, end: 15.0),
              Pin(size: 129.0, middle: 0.6922),
              child: Stack(
                children: <Widget>[
                  Pinned.fromPins(
                    Pin(size: 67.0, start: 0.0),
                    Pin(size: 14.0, start: 0.0),
                    child: Text(
                      'Bill Amount',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: const Color(0xff5b5b5b),
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(size: 40.0, end: 0.0),
                    Pin(size: 14.0, start: 0.0),
                    child: Text(
                      '123456',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: const Color(0xff5b5b5b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(size: 19.0, start: 0.0),
                    Pin(size: 14.0, middle: 0.2),
                    child: Text(
                      'Tax',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: const Color(0xff5b5b5b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(size: 55.0, start: 0.0),
                    Pin(size: 14.0, middle: 0.4),
                    child: Text(
                      'Round Off',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: const Color(0xff5b5b5b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(size: 28.0, start: 0.0),
                    Pin(size: 14.0, middle: 0.6),
                    child: Text(
                      'Cash',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: const Color(0xff5b5b5b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(size: 26.0, start: 0.0),
                    Pin(size: 14.0, middle: 0.8),
                    child: Text(
                      'Card',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: const Color(0xff5b5b5b),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(size: 43.0, start: 0.0),
                    Pin(size: 14.0, end: 0.0),
                    child: Text(
                      'Balance',
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
        ),


        SizedBox(height: 50,),
        Container(
          width: 100,
          height: 45,
          child:  Stack(
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
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue[900],
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
          child: Container(
            height: 15,
            width: 25,
            child: Image.asset(
              'assets/images/pdf.png',
              fit: BoxFit.fill,
            ),
          ),
        ),

        SizedBox(
          width: 15,
        ),
      ],
      // leading: Container(
      //   child: GestureDetector(
      //     onTap: () {
      //      // _scaffoldKey.currentState.openDrawer();
      //     },
      //     child: Builder(
      //       builder: (context) => Padding(
      //         padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      //         child: Container(
      //           child: Image.asset(
      //             'assets/images/homebox.png',
      //             height: 30,
      //             width: 30,
      //             //color: MyTheme.dark_grey,
      //             color: Colors.grey,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      elevation: 1.0,
      titleSpacing: 0,
      toolbarHeight: 70,
    );
  }


}
