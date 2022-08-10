// @dart=2.9
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/models/customers.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../app_config.dart';

class CustomersList extends StatefulWidget {
  @override
  CustomersListState createState() => CustomersListState();
}

class CustomersListState extends State<CustomersList> {
  DatabaseReference reference;
  List<String> names = [];
  List<String> balance = [];
  List<String> id = [];
  var name = TextEditingController();
  Future<List<Customers>> fetchCustomers;
  String as="";

  Future<List<Customers>> fetchData() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("cs");

    if (!isCacheExist) {
      print("Data not exists");

      Map data = {'depotid': User.userId, 'search': ""};
      //encode Map to JSON
      var body = json.encode(data);
      String url=AppConfig.DOMAIN_PATH+"customers";
      final response = await http.post(url,
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
            new APICacheDBModel(key: "cs", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        List<dynamic> responseJson = json.decode(response.body);

        List<Customers> profileList =
        responseJson.map((d) => new Customers.fromJson(d)).toList();

        profileList.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

        return profileList;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } else {
      print("Data exists");
      var cacheData = await APICacheManager().getCacheData("cs");
      List<dynamic> responseJson = json.decode(cacheData.syncData);

      List<Customers> profileList =
      responseJson.map((d) => new Customers.fromJson(d)).toList();

      profileList.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      return profileList;
    }
  }


  Future<bool> refreshData() async {
    Map data = {'depotid': User.userId, 'search': ""};
    //encode Map to JSON
    var body = json.encode(data);
    String url=AppConfig.DOMAIN_PATH+"customers";
    final response = await http.post(url,
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
          new APICacheDBModel(key: "cs", syncData: response.body);
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
    fetchCustomers = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ListView(
        children: [searchRow(), salesOrder()],
      ),
    );
  }

  searchRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      color: Color(0xff20474f),
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 30),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
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
                      onChanged: (date){
                        setState(() {
                          as=name.text;
                          fetchCustomers=fetchData();
                        });
                      },
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
            ],
          ),
        ],
      ),
    );
  }

  salesOrder() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Container(
              height: 30,
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
                      'Customer ID',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: const Color(0xffffffff),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Customer Name',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: const Color(0xffffffff),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Balance',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 12,
                        color: const Color(0xffffffff),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            RefreshIndicator(
              onRefresh: refreshData,
              child: FutureBuilder<List<Customers>>(
                  future: fetchCustomers,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              if(snapshot.data[index].name.toLowerCase().contains(as.toLowerCase())){
                                return Container(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: index.floor().isEven
                                        ? Color(0x66d6d6d6)
                                        : Color(0x66f3ceef),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                      Padding(
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data[index].balance.toString(),
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
      title: Text(
        "Customers",
        style: TextStyle(fontSize: 22, color: Colors.white),
      ),
      automaticallyImplyLeading: true,
      elevation: 0,
      titleSpacing: 0,
      //toolbarHeight: 100,
    );
  }
}
