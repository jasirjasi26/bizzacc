// @dart=2.9
import 'dart:typed_data';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:optimist_erp_app/models/products.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../app_config.dart';
import '../data/user_data.dart';

class AllProductPage extends StatefulWidget {
  AllProductPage({Key key, this.back}) : super(key: key);

  final bool back;

  @override
  AllProductPageState createState() => AllProductPageState();
}

class AllProductPageState extends State<AllProductPage> {
  var name = TextEditingController();
  Future<List<Products>> fetchProducts;
  String as = "";

  Future<List<Products>> fetchData() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("ps");

    if (!isCacheExist) {
      print("Data not exists");

      Map data = {'depotid': User.depotId, 'search': ""};
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
    // TODO: implement initState
    fetchProducts = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: WillPopScope(
        onWillPop: () async {
          return widget.back;
        },
        child: homeData()
      ),
    );
  }

  searchRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 0, top: 50),
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
                      fetchProducts=fetchData();

                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter product name here',
                    //filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 5, top: 15, right: 15),
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
        ],
      ),
    );
  }

  homeData() {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: FutureBuilder<List<Products>>(
          future: fetchProducts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder<List<Products>>(
                  future: fetchProducts,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data[index].name
                                .toLowerCase()
                                .contains(as.toLowerCase())) {
                              return Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Card(
                                  color: Colors.blueGrey[300],
                                  child: ListTile(
                                    trailing: Text(
                                     "Stock : "+ snapshot.data[index].stock.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color:
                                        const Color(0xff182d66),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    title: Text(
                                      snapshot.data[index].name,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color:
                                        const Color(0xff182d66),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    subtitle: Text(
                                      "Sale Rate : " + snapshot.data[index].salesRate
                                          .toString()+"    Purchase Rate : " + snapshot.data[index].purchaseRate
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 10,
                                        color: const Color(0xff182d66),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    leading: snapshot.data[index].productImage!=null? Container(width: 60, height:80, child: Image.memory(base64Decode(snapshot.data[index].productImage),fit: BoxFit.fill,)) :Image.asset(
                                      "assets/images/products.jpg",
                                      fit: BoxFit.scaleDown,
                                      //    color: Colors.white
                                    ),
                                  ),
                                ),
                              );
                            }
                            else{
                              return Container();
                            }
                          }
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator());
                    }
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff20474f),
      elevation: 1.0,
      titleSpacing: 0,
      leadingWidth: 150,
      leading: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                Text(
                  "  Products",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
      actions: [
        searchRow(),
      ],
      toolbarHeight: 150,
    );
  }
}
