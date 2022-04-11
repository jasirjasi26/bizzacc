// @dart=2.9
import 'package:adobe_xd/pinned.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/screens/mis_reports/mis_home.dart';
import 'package:optimist_erp_app/screens/mis_reports/sales_ledger.dart';
import 'package:optimist_erp_app/screens/mis_reports/sales_report.dart';
import 'package:optimist_erp_app/screens/mis_reports_page.dart';
import 'package:optimist_erp_app/screens/reports/orders.dart';
import 'package:optimist_erp_app/screens/returns/sales_returns.dart';
import 'package:optimist_erp_app/screens/reciept_portal.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../reports/stock_report.dart';
import 'bill_balance_report.dart';

class MisHome extends StatefulWidget {
  @override
  StockReportsState1 createState() => StockReportsState1();
}

class StockReportsState1 extends State<MisHome> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SalesLedger(
                    );
                  }));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      height: MediaQuery.of(context).size.width / 3 - 10,
                      child: Column(
                        children: [
                          // Adobe XD layer: 'surface1' (group
                          Container(
                            height: 70,
                            width: 70,
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SvgPicture.string(
                                  '<svg viewBox="2.0 2.0 30.0 29.0" ><path  d="M 8 2 L 8 19.40000152587891 L 12.5 19.40000152587891 L 12.5 6.349999904632568 L 30.5 6.349999904632568 L 26 2 L 8 2 Z M 6.5 3.450000286102295 L 2 7.800000667572021 L 2 25.20000076293945 L 20 25.20000076293945 L 20 20.85000038146973 L 6.5 20.85000038146973 L 6.5 3.450000286102295 Z M 14 7.800000667572021 L 14 12.15000057220459 L 27.5 12.15000057220459 L 27.5 29.55000114440918 L 32 25.20000076293945 L 32 7.800000667572021 L 14 7.800000667572021 Z M 21.5 13.60000038146973 L 21.5 26.65000152587891 L 3.5 26.65000152587891 L 8 31.00000190734863 L 26 31.00000190734863 L 26 13.60000038146973 L 21.5 13.60000038146973 Z" fill="#22adda" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                  allowDrawingOutsideViewBox: true,
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Text(
                            'Ledger Report',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StockReports1(true);
                  }));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      height: MediaQuery.of(context).size.width / 3 - 10,
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: // Adobe XD layer: 'surface1' (group)
                                    Stack(
                                  children: <Widget>[
                                    Pinned.fromPins(
                                      Pin(start: 0.0, end: 0.0),
                                      Pin(start: 0.0, end: 0.0),
                                      child: SvgPicture.string(
                                        '<svg viewBox="3.9 3.9 27.7 27.7" ><path transform="translate(0.0, 0.0)" d="M 29.09345054626465 3.949219703674316 C 27.70490074157715 3.949219703674316 26.5799674987793 5.074037075042725 26.5799674987793 6.462651252746582 C 26.5799674987793 6.602003574371338 26.59500312805176 6.746337413787842 26.61985015869141 6.890671253204346 L 22.4141902923584 10.38956928253174 C 22.14050674438477 10.29002094268799 21.84681701660156 10.23527050018311 21.54816055297852 10.23527050018311 C 21.06042289733887 10.23527050018311 20.5776538848877 10.37960529327393 20.16457939147949 10.65335273742676 L 16.51635360717773 8.821785926818848 C 16.4317512512207 7.497884750366211 15.33675956726074 6.462651252746582 14.00796699523926 6.462651252746582 C 12.61431980133057 6.462651252746582 11.48950290679932 7.587469100952148 11.48950290679932 8.976070404052734 C 11.48950290679932 9.030819892883301 11.49447154998779 9.085570335388184 11.49447154998779 9.14031982421875 L 7.572536468505859 11.75326061248779 C 7.229119300842285 11.58406925201416 6.850854873657227 11.48950290679932 6.462651252746582 11.48950290679932 C 5.074037075042725 11.48950290679932 3.949219703674316 12.61431980133057 3.949219703674316 14.00796699523926 C 3.949219703674316 15.39651870727539 5.074037075042725 16.52132225036621 6.462651252746582 16.52132225036621 C 7.851253509521484 16.52132225036621 8.976070404052734 15.39651870727539 8.976070404052734 14.00796699523926 C 8.976070404052734 13.95318031311035 8.971101760864258 13.89839172363281 8.966119766235352 13.84870052337646 L 12.89309978485107 11.22571849822998 C 13.24144840240479 11.39991760253906 13.61973857879639 11.48950290679932 14.00796699523926 11.48950290679932 C 14.49570465087891 11.48950290679932 14.97847557067871 11.34516906738281 15.39154815673828 11.07142066955566 L 19.03977394104004 12.90303802490234 C 19.12437629699707 14.22686386108398 20.2193660736084 15.2620964050293 21.54816055297852 15.2620964050293 C 22.94180679321289 15.2620964050293 24.06661415100098 14.13729190826416 24.06661415100098 12.74874114990234 C 24.06661415100098 12.6043815612793 24.05170631408691 12.46499156951904 24.0267333984375 12.320631980896 L 28.2274227142334 8.816803932189941 C 28.50620269775391 8.921321868896484 28.79976272583008 8.976070404052734 29.09345054626465 8.976070404052734 C 30.48200035095215 8.976070404052734 31.60693168640137 7.851253509521484 31.60693168640137 6.462651252746582 C 31.60693168640137 5.074037075042725 30.48200035095215 3.949219703674316 29.09345054626465 3.949219703674316 Z M 27.83919334411621 14.00796699523926 C 27.14237022399902 14.00796699523926 26.5799674987793 14.57036972045898 26.5799674987793 15.2620964050293 L 26.5799674987793 31.60693168640137 L 31.60693168640137 31.60693168640137 L 31.60693168640137 15.2620964050293 C 31.60693168640137 14.57036972045898 31.04440498352051 14.00796699523926 30.35267639160156 14.00796699523926 L 27.83919334411621 14.00796699523926 Z M 12.74874114990234 16.52132225036621 C 12.05688667297363 16.52132225036621 11.48950290679932 17.08372497558594 11.48950290679932 17.77557945251465 L 11.48950290679932 31.60693168640137 L 16.52132225036621 31.60693168640137 L 16.52132225036621 17.77557945251465 C 16.52132225036621 17.08372497558594 15.95395088195801 16.52132225036621 15.2620964050293 16.52132225036621 L 12.74874114990234 16.52132225036621 Z M 20.29390335083008 19.03480529785156 C 19.60217666625977 19.03480529785156 19.03480529785156 19.60217666625977 19.03480529785156 20.29390335083008 L 19.03480529785156 31.60693168640137 L 24.06661415100098 31.60693168640137 L 24.06661415100098 20.29390335083008 C 24.06661415100098 19.60217666625977 23.49924087524414 19.03480529785156 22.80738639831543 19.03480529785156 L 20.29390335083008 19.03480529785156 Z M 5.203438282012939 21.54816055297852 C 4.511634826660156 21.54816055297852 3.949219703674316 22.11553382873535 3.949219703674316 22.80738639831543 L 3.949219703674316 31.60693168640137 L 8.976070404052734 31.60693168640137 L 8.976070404052734 22.80738639831543 C 8.976070404052734 22.11553382873535 8.413667678833008 21.54816055297852 7.716870307922363 21.54816055297852 L 5.203438282012939 21.54816055297852 Z" fill="#845cfd" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                        allowDrawingOutsideViewBox: true,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Text(
                            'Stock Report',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SalesReport();
                  }));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      height: MediaQuery.of(context).size.width / 3 - 10,
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: 60,
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: // Adobe XD layer: 'surface1' (group)
                                // Adobe XD layer: 'surface1' (group)
                                Stack(
                                  children: <Widget>[
                                    Pinned.fromPins(
                                      Pin(start: 0.0, end: 0.0),
                                      Pin(start: 0.0, end: 0.0),
                                      child: SvgPicture.string(
                                        '<svg viewBox="6.0 2.0 22.2 26.8" ><path transform="translate(0.0, 0.0)" d="M 5.953129768371582 1.984380125999451 L 5.953129768371582 28.80494689941406 L 28.11071586608887 28.80494689941406 L 28.11071586608887 1.984380125999451 L 5.953129768371582 1.984380125999451 Z M 18.19712257385254 23.55883026123047 L 10.03519344329834 23.55883026123047 L 10.03519344329834 22.39250755310059 L 18.19712257385254 22.39250755310059 L 18.19712257385254 23.55883026123047 Z M 18.19712257385254 20.05991363525391 L 10.03519344329834 20.05991363525391 L 10.03519344329834 18.89358711242676 L 18.19712257385254 18.89358711242676 L 18.19712257385254 20.05991363525391 Z M 18.19712257385254 16.56099510192871 L 10.03519344329834 16.56099510192871 L 10.03519344329834 15.39466857910156 L 18.19712257385254 15.39466857910156 L 18.19712257385254 16.56099510192871 Z M 24.02863502502441 23.55883026123047 L 21.11287689208984 23.55883026123047 L 21.11287689208984 22.39250755310059 L 24.02863502502441 22.39250755310059 L 24.02863502502441 23.55883026123047 Z M 24.02863502502441 20.05991363525391 L 21.11287689208984 20.05991363525391 L 21.11287689208984 18.89358711242676 L 24.02863502502441 18.89358711242676 L 24.02863502502441 20.05991363525391 Z M 24.02863502502441 16.56099510192871 L 21.11287689208984 16.56099510192871 L 21.11287689208984 15.39466857910156 L 24.02863502502441 15.39466857910156 L 24.02863502502441 16.56099510192871 Z M 24.02863502502441 8.399065017700195 L 10.03519344329834 8.399065017700195 L 10.03519344329834 7.232799053192139 L 24.02863502502441 7.232799053192139 L 24.02863502502441 8.399065017700195 Z" fill="#845cfd" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                        allowDrawingOutsideViewBox: true,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Text(
                            '    Product \nSales Report',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BillBalance();
                  }));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 10,
                      height: MediaQuery.of(context).size.width / 3 - 10,
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: 60,
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: // Adobe XD layer: 'surface1' (group)
                                // Adobe XD layer: 'surface1' (group)
                                Stack(
                                  children: <Widget>[
                                    Pinned.fromPins(
                                      Pin(start: 0.0, end: 0.0),
                                      Pin(start: 0.0, end: 0.0),
                                      child: SvgPicture.string(
                                        '<svg viewBox="6.0 2.0 22.2 26.8" ><path transform="translate(0.0, 0.0)" d="M 5.953129768371582 1.984380125999451 L 5.953129768371582 28.80494689941406 L 28.11071586608887 28.80494689941406 L 28.11071586608887 1.984380125999451 L 5.953129768371582 1.984380125999451 Z M 18.19712257385254 23.55883026123047 L 10.03519344329834 23.55883026123047 L 10.03519344329834 22.39250755310059 L 18.19712257385254 22.39250755310059 L 18.19712257385254 23.55883026123047 Z M 18.19712257385254 20.05991363525391 L 10.03519344329834 20.05991363525391 L 10.03519344329834 18.89358711242676 L 18.19712257385254 18.89358711242676 L 18.19712257385254 20.05991363525391 Z M 18.19712257385254 16.56099510192871 L 10.03519344329834 16.56099510192871 L 10.03519344329834 15.39466857910156 L 18.19712257385254 15.39466857910156 L 18.19712257385254 16.56099510192871 Z M 24.02863502502441 23.55883026123047 L 21.11287689208984 23.55883026123047 L 21.11287689208984 22.39250755310059 L 24.02863502502441 22.39250755310059 L 24.02863502502441 23.55883026123047 Z M 24.02863502502441 20.05991363525391 L 21.11287689208984 20.05991363525391 L 21.11287689208984 18.89358711242676 L 24.02863502502441 18.89358711242676 L 24.02863502502441 20.05991363525391 Z M 24.02863502502441 16.56099510192871 L 21.11287689208984 16.56099510192871 L 21.11287689208984 15.39466857910156 L 24.02863502502441 15.39466857910156 L 24.02863502502441 16.56099510192871 Z M 24.02863502502441 8.399065017700195 L 10.03519344329834 8.399065017700195 L 10.03519344329834 7.232799053192139 L 24.02863502502441 7.232799053192139 L 24.02863502502441 8.399065017700195 Z" fill="#845cfd" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                        allowDrawingOutsideViewBox: true,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Text(
                            'Bill Balance \n   Report',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ],
          )
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
        'Mis Reports',
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
    );
  }
}
