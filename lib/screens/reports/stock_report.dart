// @dart=2.9
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/models/products.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimist_erp_app/screens/pin_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../../app_config.dart';

class StockReports1 extends StatefulWidget {
  StockReports1(this.a);

  bool a;

  @override
  StockReportsState1 createState() => StockReportsState1();
}

class StockReportsState1 extends State<StockReports1> {
  var name = TextEditingController();

  Future<List<Products>> fetchProducts;
  String as = "";

  Future<List<Products>> fetchData() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("ps");

    if (!isCacheExist) {
      print("Data not exists");

      Map data = {'depotid': "8", 'search': ""};
      //encode Map to JSON
      var body = json.encode(data);
      String url = AppConfig.DOMAIN_PATH + "products";
      final response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        APICacheDBModel cacheDBModel =
            new APICacheDBModel(key: "ps", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);

        return productsFromJson(response.body);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } else {
      print("Data exists");
      var cacheData = await APICacheManager().getCacheData("ps");
      return productsFromJson(cacheData.syncData);
    }
  }

  Future<bool> refreshData() async {
    Map data = {'depotid': "8", 'search': ""};
    //encode Map to JSON
    var body = json.encode(data);
    String url = AppConfig.DOMAIN_PATH + "products";
    final response = await http.post(
      url,
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      APICacheDBModel cacheDBModel =
          new APICacheDBModel(key: "ps", syncData: response.body);
      await APICacheManager().addCacheData(cacheDBModel);

      EasyLoading.showSuccess('Refresh done...');
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void initState() {
    fetchProducts = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.a ? buildAppBar(context) : null,
      body: Column(
        children: [searchRow(), salesOrder()],
      ),
    );
  }

  searchRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xff20474f),
      height: 80,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.93,
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
                      onChanged: (data) {
                        setState(() {
                          as = name.text;
                          fetchProducts = fetchData();
                        });
                      },
                      // onChanged: getCustomerId,
                      decoration: InputDecoration(
                        hintText: 'Enter item name here',
                        //filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 5, top: 15, right: 15),
                        filled: false,
                        isDense: false,
                        prefixIcon: Icon(
                          Icons.settings_input_composite_outlined,
                          size: 25.0,
                          color: Colors.grey,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  salesOrder() {
    return Container(
      width: 600,
      height: MediaQuery.of(context).size.height*0.8,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: 600,
            height: MediaQuery.of(context).size.height*0.8,
            child: ListView(
              children: [
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xff454d60),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Code',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xffffffff),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: 170,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 14,
                              color: const Color(0xffffffff),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Stock',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xffffffff),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sale Rate',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xffffffff),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'P. Rate',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                            color: const Color(0xffffffff),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder<List<Products>>(
                      future: fetchProducts,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                // ignore: missing_return
                                itemBuilder: (context, index) {
                                  if (snapshot.data[index].name
                                      .toLowerCase()
                                      .contains(as.toLowerCase())) {
                                    return Container(
                                      height: 28,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: index.floor().isEven
                                            ? Color(0x66d6d6d6)
                                            : Color(0x66f3ceef),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data[index].id.toString(),
                                              style: TextStyle(
                                                fontFamily: 'Arial',
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container(
                                            width: 170,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                snapshot.data[index].name,
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
                                              snapshot.data[index].stock
                                                  .toString(),
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
                                              snapshot.data[index].salesRate
                                                  .toString(),
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
                                              snapshot.data[index].purchaseRate
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
                                  }
                                }),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
              ],
            ),
          )),
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
        'Stock Reports',
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
      //toolbarHeight: 0,
    );
  }
}
