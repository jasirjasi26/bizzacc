import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:optimist_erp_app/ui_elements/bluetooth_print.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/ui_elements/bottomNavigation.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'dart:typed_data';

class CashReceiptPage extends StatefulWidget {
  CashReceiptPage(
      {required Key key,
        required this.customerName,
        required this.date,
        required this.card,
        required this.cash,
        required this.voucherNumber,
        required this.billAmount,required this.back,
        //required this.data,
        required this.customerCode,  required this.customerBalance,})
      : super(key: key);

  final String date;
  final String customerName;
  final String customerCode;
  final String customerBalance;
  final String card;
  final String cash;
  final String voucherNumber;
  final String billAmount;
  final bool back;
  //final Map<String, dynamic> data;

  @override
  VanPageState createState() => VanPageState();
}

class VanPageState extends State<CashReceiptPage> {
  final _screenshotController = ScreenshotController();
  final pdf = pw.Document();
  String cash = "-";
  String card = "-";
  String roundOff = "-";
  String balance = "-";
  String totaltax = "-";
  String totalDisc = "-";
  String bill = "-";
  late String generatedPdfFilePath;
  String totalBill = "-";
  var image;
  late Uint8List bytes;

  takeBillPdf() async {
    final imageFile = await _screenshotController.capture();

    final image = pw.MemoryImage(
      File(imageFile.path).readAsBytesSync(),
    );

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          ); // Center
        }));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/"+widget.voucherNumber+".pdf");
    await file.writeAsBytes(await pdf.save());
    Share.shareFiles([file.path], text: "Shared");
    return file;
  }



  void initState() {
    // TODO: implement initState
    bytes = base64Decode(User.companylogo);
    // setState(() {
    //   image=bytes;
    // });

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
          if(widget.back){
            return true;
          }
          else{
            return false;
          }

        },
        child: Stack(
          children: [
            Screenshot(
              controller: _screenshotController,
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: [
                    homeData()
                  ],
                ),
              ),
            ),
            widget.back ? Container()  : Positioned(
              bottom: 40,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return BottomBar();
                          }));
                    },
                    child: Container(
                      width: 120,
                      height: 45,
                      child: Stack(
                        children: <Widget>[
                          Container(
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  homeData() {
    return Column(
      children: [
        Row(
          children: [
            bytes != null
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Container(width: 150, height: 100, child: Image.memory(bytes,fit: BoxFit.cover,))),
            )
                : Container(),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Voucher Number',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    widget.voucherNumber,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      color: const Color(0xff5b5b5b),
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
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
                  Pin(size: 232.0, start: 3.5),
                  Pin(size: 14.0, middle: 0.1957),
                  child: Text(
                    'Date :'+widget.date.substring(0,10),
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
                    'Van No :   ' + User.depotId,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 150.0, end: -50),
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
          padding: const EdgeInsets.only(left: 15.0, top: 25, right: 15),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Text(
              //       'Company Name & Address',
              //       style: TextStyle(
              //         fontFamily: 'Arial',
              //         fontSize: 12,
              //         color: const Color(0xff5b5b5b),
              //       ),
              //       textAlign: TextAlign.left,
              //     ),
              //   ],
              // ),
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
          padding: EdgeInsets.only(top: 10),
          child: Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Bill',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: const Color(0xff5b5b5b),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.billAmount,
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
                // Padding(
                //   padding: EdgeInsets.only(left: 15.0, right: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         'Tax',
                //         style: TextStyle(
                //           fontFamily: 'Arial',
                //           fontSize: 12,
                //           color: const Color(0xff5b5b5b),
                //           fontWeight: FontWeight.w500,
                //         ),
                //         textAlign: TextAlign.left,
                //       ),
                //       Text(
                //         totaltax,
                //         style: TextStyle(
                //           fontFamily: 'Arial',
                //           fontSize: 12,
                //           color: const Color(0xff5b5b5b),
                //         ),
                //         textAlign: TextAlign.left,
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: 15.0, right: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         'RoundOff',
                //         style: TextStyle(
                //           fontFamily: 'Arial',
                //           fontSize: 12,
                //           color: const Color(0xff5b5b5b),
                //           fontWeight: FontWeight.w500,
                //         ),
                //         textAlign: TextAlign.left,
                //       ),
                //       Text(
                //         widget.data['RoundOff'].toString(),
                //         style: TextStyle(
                //           fontFamily: 'Arial',
                //           fontSize: 12,
                //           color: const Color(0xff5b5b5b),
                //         ),
                //         textAlign: TextAlign.left,
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15),
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
                      Text(
                        widget.cash.toString(),
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
                  padding: EdgeInsets.only(left: 15.0, right: 15),
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
                      Text(
                        widget.card.toString(),
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
                  padding: EdgeInsets.only(left: 15.0, right: 15),
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
                      Text(
                        widget.customerBalance,
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
                  padding: EdgeInsets.only(left: 15.0, right: 15, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Net Bill Amount',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 13,
                          color: const Color(0xff5b5b5b),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.billAmount,
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 13,
                          color: const Color(0xff5b5b5b),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.back ? true : false,
      backgroundColor: Color(0xff20474f),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      leadingWidth: 50,
      title: Text("Cash Receipt",style: TextStyle(color: Colors.white)),
      elevation: 1.0,
      actions: [
        Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Print(
                                  billAmount: widget.billAmount,
                                  date: widget.date,
                                  voucherNumber: widget.voucherNumber,
                                  customerName: widget.customerName,
                                  customerCode: widget.customerCode,
                                  cash:widget.cash,
                                  card:widget.card,
                                    balance:widget.customerBalance
                                )));
                      },
                      child: Center(
                        child: Container(
                            height: 35,
                            width: 30,
                            child: // Adobe XD layer: 'surface1' (group)
                            Stack(
                              children: <Widget>[
                                Pinned.fromPins(
                                  Pin(start: 0.0, end: 0.0),
                                  Pin(size: 6.8, middle: 0.3704),
                                  child: SvgPicture.string(
                                    '<svg viewBox="4.0 11.2 24.8 6.8" ><path transform="translate(0.0, -3.79)" d="M 4 21.8271312713623 L 28.825927734375 21.8271312713623 L 28.825927734375 17.48259353637695 C 28.825927734375 16.11040115356445 27.71552467346191 15 26.34333419799805 15 L 6.482592582702637 15 C 5.110376834869385 15 4 16.11040115356445 4 17.48259353637695 L 4 21.8271312713623 Z" fill="#616161" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(start: 3.1, end: 3.1),
                                  Pin(size: 1.9, middle: 0.2),
                                  child: SvgPicture.string(
                                    '<svg viewBox="7.1 9.3 18.6 1.9" ><path transform="translate(-1.9, -2.66)" d="M 9 12 L 27.61944580078125 12 L 27.61944580078125 13.8619441986084 L 9 13.8619441986084 L 9 12 Z" fill="#424242" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(start: 0.0, end: 0.0),
                                  Pin(size: 7.4, middle: 0.7692),
                                  child: SvgPicture.string(
                                    '<svg viewBox="4.0 17.4 24.8 7.4" ><path transform="translate(0.0, -7.59)" d="M 6.482592582702637 32.44777679443359 L 26.34333419799805 32.44777679443359 C 27.71552467346191 32.44777679443359 28.825927734375 31.33737754821777 28.825927734375 29.96518516540527 L 28.825927734375 25 L 4 25 L 4 29.96518516540527 C 4 31.33737754821777 5.110376834869385 32.44777679443359 6.482592582702637 32.44777679443359" fill="#424242" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 1.2, end: 1.9),
                                  Pin(size: 1.2, middle: 0.3611),
                                  child: SvgPicture.string(
                                    '<svg viewBox="25.7 13.1 1.2 1.2" ><path transform="translate(-13.28, -4.93)" d="M 39 18.62064743041992 C 39 18.96250152587891 39.2787971496582 19.24129676818848 39.62064743041992 19.24129676818848 C 39.96250152587891 19.24129676818848 40.24129867553711 18.96250152587891 40.24129867553711 18.62064743041992 C 40.24129867553711 18.27879524230957 39.96250152587891 18 39.62064743041992 18 C 39.2787971496582 18 39 18.27879524230957 39 18.62064743041992" fill="#00e676" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(start: 3.1, end: 3.1),
                                  Pin(size: 1.9, middle: 0.6857),
                                  child: SvgPicture.string(
                                    '<svg viewBox="7.1 19.9 18.6 1.9" ><path transform="translate(-1.9, -9.1)" d="M 26.68847274780273 30.86194610595703 L 9.930972099304199 30.86194610595703 C 9.417000770568848 30.86194610595703 9 30.44493103027344 9 29.93097305297852 C 9 29.41701507568359 9.417000770568848 29 9.930972099304199 29 L 26.68847274780273 29 C 27.20243072509766 29 27.61944580078125 29.41701507568359 27.61944580078125 29.93097305297852 C 27.61944580078125 30.44493103027344 27.20243072509766 30.86194610595703 26.68847274780273 30.86194610595703" fill="#242424" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(start: 4.3, end: 4.3),
                                  Pin(size: 6.2, start: 0.0),
                                  child: SvgPicture.string(
                                    '<svg viewBox="8.3 5.0 16.1 6.2" ><path transform="translate(-2.66, 0.0)" d="M 11 5 L 27.1368522644043 5 L 27.1368522644043 11.20648193359375 L 11 11.20648193359375 L 11 5 Z" fill="#90caf9" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(start: 4.3, end: 4.3),
                                  Pin(size: 6.8, end: 0.0),
                                  child: SvgPicture.string(
                                    '<svg viewBox="8.3 21.8 16.1 6.8" ><path transform="translate(-2.66, -10.24)" d="M 11 32 L 27.1368522644043 32 L 27.1368522644043 38.82712936401367 L 11 38.82712936401367 L 11 32 Z" fill="#90caf9" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(start: 4.3, end: 4.3),
                                  Pin(size: 1.2, middle: 0.6944),
                                  child: SvgPicture.string(
                                    '<svg viewBox="8.3 20.5 16.1 1.2" ><path transform="translate(-2.66, -9.48)" d="M 11 30 L 27.1368522644043 30 L 27.1368522644043 31.24129676818848 L 11 31.24129676818848 L 11 30 Z" fill="#42a5f5" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 10.6, middle: 0.5217),
                                  Pin(size: 1.2, middle: 0.8056),
                                  child: SvgPicture.string(
                                    '<svg viewBox="11.4 23.0 10.6 1.2" ><path transform="translate(-4.55, -11.0)" d="M 16 34 L 26.55101776123047 34 L 26.55101776123047 35.24129867553711 L 16 35.24129867553711 L 16 34 Z" fill="#1976d2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 8.1, middle: 0.4444),
                                  Pin(size: 1.2, end: 1.9),
                                  child: SvgPicture.string(
                                    '<svg viewBox="11.4 25.5 8.1 1.2" ><path transform="translate(-4.55, -12.52)" d="M 16 38 L 24.06842803955078 38 L 24.06842803955078 39.24129486083984 L 16 39.24129486083984 L 16 38 Z" fill="#1976d2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        takeBillPdf();
                      },
                      child: Center(
                        child: Container(
                            height: 35,
                            width: 25,
                            child: // Adobe XD layer: 'surface1' (group)
                            Stack(
                              children: <Widget>[
                                Pinned.fromPins(
                                  Pin(start: 0.0, end: 0.0),
                                  Pin(start: 0.0, end: 0.0),
                                  child: SvgPicture.string(
                                    '<svg viewBox="8.0 3.0 16.8 22.0" ><path  d="M 24.76190567016602 25 L 8 25 L 8 3 L 19.5238094329834 3 L 24.76190567016602 8.238094329833984 L 24.76190567016602 25 Z" fill="#ff5722" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 5.0, end: 0.8),
                                  Pin(size: 5.0, start: 0.8),
                                  child: SvgPicture.string(
                                    '<svg viewBox="19.0 3.8 5.0 5.0" ><path transform="translate(-10.0, -0.71)" d="M 33.97619247436523 9.476189613342285 L 29 9.476189613342285 L 29 4.5 L 33.97619247436523 9.476189613342285 Z" fill="#fbe9e7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 3.5, middle: 0.2286),
                                  Pin(size: 5.2, middle: 0.6255),
                                  child: SvgPicture.string(
                                    '<svg viewBox="11.0 13.5 3.5 5.2" ><path transform="translate(-2.76, -9.55)" d="M 14.85250568389893 26.42709541320801 L 14.85250568389893 28.26042938232422 L 13.80080032348633 28.26042938232422 L 13.80080032348633 23.04689979553223 L 15.576828956604 23.04689979553223 C 16.09246635437012 23.04689979553223 16.50370788574219 23.20650482177734 16.81066131591797 23.5277042388916 C 17.11756134033203 23.84691429138184 17.27103805541992 24.26229667663574 17.27103805541992 24.77384757995605 C 17.27103805541992 25.28330612182617 17.11756134033203 25.68637466430664 16.81474685668945 25.98306083679199 C 16.51193237304688 26.27980041503906 16.09246635437012 26.42709541320801 15.55430507659912 26.42709541320801 L 14.85250568389893 26.42709541320801 Z M 14.85250568389893 25.54929542541504 L 15.576828956604 25.54929542541504 C 15.77734279632568 25.54929542541504 15.932861328125 25.48381996154785 16.04129028320312 25.35286712646484 C 16.15181541442871 25.22191429138184 16.20702362060547 25.03161430358887 16.20702362060547 24.77997589111328 C 16.20702362060547 24.52011299133301 16.14977264404297 24.31341934204102 16.03924942016602 24.1579532623291 C 15.92673397064209 24.00447654724121 15.77530002593994 23.92674255371094 15.58704280853271 23.9246997833252 L 14.85250568389893 23.9246997833252 L 14.85250568389893 25.54929542541504 Z" fill="#ffebee" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 3.4, middle: 0.5391),
                                  Pin(size: 5.2, middle: 0.6255),
                                  child: SvgPicture.string(
                                    '<svg viewBox="15.2 13.5 3.4 5.2" ><path transform="translate(-6.56, -9.55)" d="M 21.76560020446777 28.26042938232422 L 21.76560020446777 23.04689979553223 L 23.14264297485352 23.04689979553223 C 23.75240898132324 23.04689979553223 24.23735237121582 23.23924446105957 24.59951400756836 23.62591934204102 C 24.95963287353516 24.01264762878418 25.14584732055664 24.5425853729248 25.15197563171387 25.21578598022461 L 25.15197563171387 26.06084823608398 C 25.15197563171387 26.74630546569824 24.97188949584961 27.28441429138184 24.60972785949707 27.67522811889648 C 24.24756622314453 28.06604194641113 23.7503662109375 28.26042938232422 23.11398887634277 28.26042938232422 L 21.76560020446777 28.26042938232422 Z M 22.81730461120605 23.9246997833252 L 22.81730461120605 27.38671493530273 L 23.1324291229248 27.38671493530273 C 23.48437690734863 27.38671493530273 23.72988510131836 27.29468154907227 23.87314796447754 27.10846710205078 C 24.016357421875 26.92429542541504 24.0920467376709 26.6050853729248 24.10027122497559 26.1508903503418 L 24.10027122497559 25.24648094177246 C 24.10027122497559 24.75949668884277 24.0306568145752 24.41985511779785 23.8956184387207 24.22751426696777 C 23.75853729248047 24.03516960144043 23.52732849121094 23.93491363525391 23.19994735717773 23.9246997833252 L 22.81730461120605 23.9246997833252 Z" fill="#ffebee" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Pinned.fromPins(
                                  Pin(size: 2.9, middle: 0.8182),
                                  Pin(size: 5.2, middle: 0.6255),
                                  child: SvgPicture.string(
                                    '<svg viewBox="19.4 13.5 2.9 5.2" ><path transform="translate(-10.32, -9.55)" d="M 32.36255264282227 26.1324520111084 L 30.72564697265625 26.1324520111084 L 30.72564697265625 28.26042938232422 L 29.67189979553223 28.26042938232422 L 29.67189979553223 23.04689979553223 L 32.55898284912109 23.04689979553223 L 32.55898284912109 23.9246997833252 L 30.72564697265625 23.9246997833252 L 30.72564697265625 25.26078033447266 L 32.36255264282227 25.26078033447266 L 32.36255264282227 26.1324520111084 Z" fill="#ffebee" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                    allowDrawingOutsideViewBox: true,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => super.widget));
                      },
                      child: Icon(
                        Icons.refresh,
                        size: 35,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          width: 10,
        )
      ],
      titleSpacing: 0,
      toolbarHeight: 120,
    );
  }
}
