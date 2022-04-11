// @dart=2.9
import 'dart:convert';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/models/returns.dart';
import 'package:optimist_erp_app/screens/returns/return_order.dart';
import 'dart:ui';
import 'package:textfield_search/textfield_search.dart';
import 'package:http/http.dart' as http;
import '../../app_config.dart';
import '../../models/customers.dart';
import '../../models/sales_types.dart';

class ReturnsPage extends StatefulWidget {
  @override
  ReturnsPageState createState() => ReturnsPageState();
}

class ReturnsPageState extends State<ReturnsPage> {
  bool select = true;
  DatabaseReference reference;
  List<String> names = [];
  List<String> amount = [];
  List<String> dates = [];
  List<String> code = [];
  List<String> vNo = [];
  List<String> balance = [];
  List<String> tax = [];
  var name = TextEditingController();
  DatabaseReference allnames;
  String label = "Enter Customer Name";
  List<String> _locations = []; // Option 2
  String _selectedLocation; //
  DatabaseReference types; // O
  String salesType = "";
  Future<Returns> returns;

  DateTime selectedDate = DateTime.now();
  String from = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString();

  String to = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString();

  Future<Returns> getReturns() async {
    Map data = {'from_Date': from, 'to_Date': to, "billed": "0"};
    //encode Map to JSON
    var body = json.encode(data);

    if (await DataConnectionChecker().hasConnection) {
      print("Mobile data detected & internet connection confirmed.");
      String url = AppConfig.DOMAIN_PATH + "salesreturn/showall";
      final response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Success");
        print(response.body);
        return returnsFromJson(response.body);
      } else {
        print("Failed");
      }
    }
  }

  fetchData() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("types");

    if (!isCacheExist) {
      print("Data not exists");

      String url = AppConfig.DOMAIN_PATH + "salestypes";
      final response = await http.get(
        url,
        // body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        APICacheDBModel cacheDBModel =
            new APICacheDBModel(key: "types", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);

        var json = jsonDecode(response.body);
        for (int i = 0; i < salestypesFromJson(response.body).length; i++) {
          _locations.add(json[i]['Name']);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } else {
      print("Data exists");
      var cacheData = await APICacheManager().getCacheData("types");
      var json = jsonDecode(cacheData.syncData);
      for (int i = 0; i < salestypesFromJson(cacheData.syncData).length; i++) {
        _locations.add(json[i]['Name']);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        from = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });

    setState(() {
      returns=getReturns();
    });
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        to = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
    setState(() {
      returns=getReturns();
    });
  }

  void initState() {
    // TODO: implement initState
    returns = getReturns();
    fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff20474f),
        elevation: 15,
        isExtended: true,
        onPressed: showBookingDialog,
        child: Icon(
          Icons.add_circle,
          color: Colors.white,
          size: 25,
        ),
      ),
      body: ListView(
        children: [searchRow(), salesOrder()],
      ),
    );
  }

  void showBookingDialog() {
    var textEditingController = TextEditingController();
    Future<List> getNames(String input) async {
      List _list = [];
      var isCacheExist = await APICacheManager().isAPICacheKeyExist("cs");

      if (!isCacheExist) {
        print("Data not exists");

        Map data = {'depotid': "8", 'search': ""};
        //encode Map to JSON
        var body = json.encode(data);
        String url = AppConfig.DOMAIN_PATH + "customers";
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
              new APICacheDBModel(key: "cs", syncData: response.body);
          await APICacheManager().addCacheData(cacheDBModel);
          var json = jsonDecode(response.body);
          for (int i = 0; i < customersFromJson(response.body).length; i++) {
            _list.add(json[i]['Name']);
          }
          return _list;
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          throw Exception('Failed to load album');
        }
      } else {
        print("Data exists");
        var cacheData = await APICacheManager().getCacheData("cs");
        var json = jsonDecode(cacheData.syncData);
        for (int i = 0; i < customersFromJson(cacheData.syncData).length; i++) {
          _list.add(json[i]['Name']);
        }
        return _list;
      }
    }

    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Material(
                type: MaterialType.transparency,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 30.0, top: 25, bottom: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Container(
                                    child: Image.asset(
                                      "assets/images/closebutton.png",
                                      color: Color.fromRGBO(153, 153, 153, 1),
                                      height: 20,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 50.0, right: 50),
                            child: Card(
                              elevation: 5,
                              child: TextFieldSearch(
                                  label: label,
                                  minStringLength: 0,
                                  future: () {
                                    return getNames(textEditingController.text);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Enter Customer Name / Code',
                                    contentPadding: EdgeInsets.only(
                                        left: 15, top: 15, right: 15),
                                    filled: false,
                                    prefixIcon: Icon(
                                      Icons.person,
                                      size: 25.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  controller: textEditingController),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 50.0, right: 50, bottom: 5),
                            child: Text(
                              " Select Sales Type",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 50.0, right: 50, bottom: 20),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 50.0, top: 10),
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButton(
                                    isDense: true,
                                    //itemHeight: 50,
                                    iconSize: 35,
                                    isExpanded: true,
                                    hint: Text('Choose sales type'),
                                    value: _selectedLocation,
                                    onChanged: (newValue) async {
                                      setState(() {
                                        _selectedLocation = newValue;
                                      });
                                      var cacheData = await APICacheManager()
                                          .getCacheData("types");
                                      var json = jsonDecode(cacheData.syncData);
                                      for (int i = 0;
                                          i <
                                              salestypesFromJson(
                                                      cacheData.syncData)
                                                  .length;
                                          i++) {
                                        if (_selectedLocation ==
                                            json[i]['Name'].toString()) {
                                          setState(() {
                                            salesType =
                                                json[i]['id'].toString();
                                          });
                                        }
                                      }
                                    },
                                    items: _locations.map((location) {
                                      return DropdownMenuItem(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 4.0, left: 0),
                                          child: new Text(location),
                                        ),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                if (textEditingController.text.isNotEmpty &&
                                    _selectedLocation.isNotEmpty) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ReturnOrder(
                                      customerName: textEditingController.text,
                                      refNo: "0",
                                      salesType: salesType,
                                    );
                                  }));
                                }
                              },
                              child: Container(
                                height: 45,
                                width: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(0.0, -1.0),
                                    end: Alignment(0.0, 1.0),
                                    colors: [
                                      const Color(0xff00ecb2),
                                      const Color(0xff12b3e3)
                                    ],
                                    stops: [0.0, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xffcdcdcd),
                                      offset: Offset(6, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset(
                                            "assets/images/save.png",
                                            color: Colors.white,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        " Save",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
                ));
          },
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  searchRow() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      color: Color(0xff20474f),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
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
                       onChanged: (value){
                        setState(() {
                          name.text=value;
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '  From : ',
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
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Text(
                    from,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 13,
                        color: Colors.white,
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.left,
                  ),
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
                GestureDetector(
                  onTap: () {
                    _selectToDate(context);
                  },
                  child: Text(
                    to,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 13,
                        color: Colors.white,
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.left,
                  ),
                ),
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Container(
                  height: 25,
                  width: 500,
                  decoration: BoxDecoration(
                    color: const Color(0xff454d60),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: 500,
                      height: MediaQuery.of(context).size.height,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '   V No ',
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
                              '  Date ',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                color: const Color(0xffffffff),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  '  Name ',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 12,
                                    color: const Color(0xffffffff),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                ' Code  ',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: 12,
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              ' Amount  ',
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
                  )),
              Container(
                width: 500,
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<Returns>(
                    future: getReturns(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView(
                          children: new List.generate(
                            snapshot.data.data.length,
                                (index) => Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: index.floor().isEven
                                    ? Color(0x66d6d6d6)
                                    : Color(0x66f3ceef),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data.data[index].voucherNo,
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Text(
                                      snapshot.data.data[index].returnDate.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    width: 180,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        snapshot.data.data[index].customerName,
                                        style: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Center(
                                      child: Text(
                                        snapshot.data.data[index].returnId ?? "",
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
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      snapshot.data.data[index].grandTotal.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(width: 5,)
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      else{
                        return Container(height:50,width: 50,child: Center(child: CircularProgressIndicator()));
                      }
                    }),
              ),
            ],
          ),
        )
      ],
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
        "Return List",
        style: TextStyle(color: Colors.white),
      ),
      elevation: 0,
      titleSpacing: 0,
      toolbarHeight: 80,
    );
  }
}
