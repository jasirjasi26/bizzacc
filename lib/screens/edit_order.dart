// @dart=2.9
import 'package:adobe_xd/pinned.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:flutter_svg/svg.dart';
import '../app_config.dart';
import '../controller.dart';
import '../contactinfomodel.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/screens/settlement_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:optimist_erp_app/screens/qr_scan.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:optimist_erp_app/models/products.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../app_config.dart';
import '../models/customers.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import '../models/units.dart';

class EditOrderPage extends StatefulWidget {
  EditOrderPage({Key key, this.customerName, this.salesType, this.orderId})
      : super(key: key);

  final String customerName;
  final String salesType;
  final String orderId;

  @override
  NewOrderPageState createState() => NewOrderPageState();
}

class NewOrderPageState extends State<EditOrderPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _screenshotController = ScreenshotController();
  final pdf = pw.Document();
  int _radioValue1 = 0;

  //List<String> itemList = [];
  List<String> unitlist = [];
  String _selectedUnit = "";
  var saleRate = TextEditingController();
  var saleQty = TextEditingController();
  var depoStock = TextEditingController();
  var unitController = TextEditingController();
  var byPercentage = TextEditingController();
  var byPrice = TextEditingController();
  double totalAmount = 0;
  List<String> itemname = [];
  List<String> percentages = [];
  List<String> itemIds = [];
  List<String> units = [];
  List<String> totalamount = [];
  List<double> discountAmount = [];
  List<String> discountedFinalRate = [];
  List<int> quantity = [];
  List<String> discount = [];
  List<double> taxTotal = [];
  List<String> vatTotal = [];
  List<String> gstTotal = [];
  List<String> rateList = [];
  List<String> allDiscounts = [];
  double totalBill = 0;
  double discountedBill = 0;
  double disc = 0;

  String unit = "";
  String rate = "";
  String stock = "";
  String code;
  String totalStock = "";
  double lastSaleRate = 0;
  String itemId = "";
  String customerId = "";
  double tax = 0;
  double vat = 0;
  double cess = 0;
  double gst = 0;
  int dicPer = 0;
  int dicPri = 0;
  String Name = "";
  String ID = "1";
  String unitID = "";
  String ids = "";
  bool isLoading = false;
  String voucherid = DateTime.now().year.toString() +
      DateTime.now().month.toString() +
      DateTime.now().day.toString() +
      DateTime.now().hour.toString() +
      DateTime.now().minute.toString() +
      DateTime.now().second.toString();

  DateTime selectedDate = DateTime.now();
  String from = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString();
  String today = DateTime.now().year.toString() +
      "-" +
      DateTime.now().month.toString() +
      "-" +
      DateTime.now().day.toString();
  List<Products> products;
  var name = TextEditingController();
  Future<List<Products>> fetchProducts;
  String as = "";
  String customer_balance = "";
  String orderId = "";
  String orderDate = "";
  String salesTypeId = "";
  List<String> getIds = [];

  getSingleOrder(String id) async {
    Map data = {
      'Order_id': id,
    };
    //encode Map to JSON
    var body = json.encode(data);
    String url = AppConfig.DOMAIN_PATH + "salesorder/show";
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
      print(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        orderId = data['OrderID'];
        orderDate = data['OrderingDate'];
        salesTypeId = data['SalesTypeID'].toString();
        customerId = data['CustomerID'].toString();
        discountedBill = data['BillAmount'];
        totalBill= data['BillAmount'];
      });

      for (int i = 0; i < data['Items'].length; i++) {
        setState(() {
          getIds.add(data['Items'][i]['Id'].toString());
          itemIds.add(data['Items'][i]['ItemID'].toString());
          itemname.add(data['Items'][i]['ItemName'].toString());
          totalamount.add(data['Items'][i]['Amount'].toString());
          quantity.add(data['Items'][i]['Qty'].round());
          rateList.add(data['Items'][i]['Rate'].toString());
          discountAmount.add(data['Items'][i]['DiscAmount']);
          units.add("Box");
          unitlist.add(data['Items'][i]['UnitID'].toString());
          allDiscounts.add(data['Items'][i]['DiscAmount'].toString());
          percentages.add(data['Items'][i]['DiscPercentage'].toString());
          discountedFinalRate.add(data['Items'][i]['Amount'].toString());
          taxTotal.add(data['Items'][i]['VATAmount']);
          vatTotal.add(data['Items'][i]['VATAmount'].toString());
          gstTotal.add(data['Items'][i]['GSTAmount'].toString());
        });
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete');
    }
  }

  getNames() async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("cs");

    if (!isCacheExist) {
      print("Data not exists");

      Map data = {'depotid': User.depotId, 'search': ""};
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
          if (widget.customerName == json[i]['Name']) {
            setState(() {
              customerId = json[i]['id'].toString();
              customer_balance = json[i]['Balance'].toString();
            });
          }
        }
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
        if (widget.customerName == json[i]['Name']) {
          setState(() {
            customerId = json[i]['id'].toString();
            customer_balance = json[i]['Balance'].toString();
          });
        }
      }
    }
  }

  Future<bool> refreshData() async {
    if (await DataConnectionChecker().hasConnection) {
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

        EasyLoading.showSuccess('Refresh done...');
        return true;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }
  }

  Future<List<Products>> fetchDatas() async {
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
      print("Product Data exists");
      var cacheData = await APICacheManager().getCacheData("ps");
      return productsFromJson(cacheData.syncData);
    }
  }

  Future<List<Units>> fetchUnits(String id) async {
    var isCacheExist = await APICacheManager().isAPICacheKeyExist("units");

    if (!isCacheExist) {
      print("Data not exists");
      Map data = {
        'product_id': "",
      };
      //encode Map to JSON
      var body = json.encode(data);
      String url = AppConfig.DOMAIN_PATH + "units";
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
        // // then parse the JSON.
        APICacheDBModel cacheDBModel =
            new APICacheDBModel(key: "units", syncData: response.body);
        await APICacheManager().addCacheData(cacheDBModel);
        List<Units> filtered = [];
        unitsFromJson(response.body).forEach((element) {
          if (element.productId.toString() == id) {
            filtered.add(element);
          }
        });

        return filtered;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } else {
      print("Data exists");
      var cacheData = await APICacheManager().getCacheData("units");
      List<Units> filtered = [];

      unitsFromJson(cacheData.syncData).forEach((element) {
        if (element.productId.toString() == id) {
          filtered.add(element);
        }
      });

      return filtered;
    }
  }

  Future<void> _selectDate() async {
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
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  void addItem(
      String Aname,
      String Aunit,
      String AunitId,
      String AdiscountedAmount,
      int Aqty,
      String Aid,
      String Atax,
      String Avat,
      String Agst,
      String Arate,
      String Acode,
      String Atotal,
      String Apercentage) {
    double discount = double.parse(Atotal) - double.parse(AdiscountedAmount);

    setState(() {
      percentages.add(Apercentage);
      itemname.add(Aname);
      itemIds.add(Aid);
      unitlist.add(AunitId);
      units.add(Aunit);
      totalamount.add(Atotal);
      allDiscounts.add(discount.toStringAsFixed(User.decimals));
      discountAmount.add(double.parse(discount.toStringAsFixed(User.decimals)));
      discountedFinalRate.add(AdiscountedAmount);
      quantity.add(Aqty);
      totalBill = totalBill + double.parse(Atotal);
      taxTotal.add(double.parse(Atax));
      vatTotal.add(Avat);
      gstTotal.add(Agst);
      rateList.add(Arate);
      discountedBill = totalBill;
      disc = discountAmount.reduce((a, b) => a + b);
    });
  }

  void deleteItem(int index) {
    print(index);
    setState(() {
      itemname.removeAt(index);
      itemIds.removeAt(index);
      units.removeAt(index);
      unitlist.removeAt(index);
      percentages.removeAt(index);
      totalBill = totalBill - double.parse(totalamount[index]);
      totalamount.removeAt(index);
      allDiscounts.removeAt(index);
      discountAmount.removeAt(index);
      discountedFinalRate.removeAt(index);
      quantity.removeAt(index);
      taxTotal.removeAt(index);
      vatTotal.removeAt(index);
      gstTotal.removeAt(index);
      rateList.removeAt(index);
      if (totalamount.length > 0) {
        double val = 0;
        for (int i = 0; i < totalamount.length; i++) {
          val = val + double.parse(totalamount[i]);
        }
        discountedBill = val;
        disc = discountAmount.reduce((a, b) => a + b);
      } else {
        String val = "0";
        totalBill = 0;
        discountedBill = double.parse(val);
        disc = 0;
      }
    });
    print(itemname);
  }

  void discountPrice(String a) {
    setState(() {
      discountedBill = totalBill;
    });

    setState(() {
      discountedBill = totalBill - double.parse(byPrice.text);
      double a = (totalBill - discountedBill) / (totalBill) * 100;
      double b = (a);
      byPercentage.text = b.toStringAsFixed(User.decimals);
    });
  }

  void discountPer(String a) {
    setState(() {
      discountedBill = totalBill;
    });
    setState(() {
      discountedBill =
          totalBill - totalBill / 100 * double.parse(byPercentage.text);
      double d = totalBill - discountedBill;
      byPrice.text = d.toStringAsFixed(User.decimals);
    });
  }

  Future<void> addtoInvoiceValues() async {
    List amm = [];
    String time = DateTime.now().toString();

    for (int i = 0; i < itemname.length; i++) {
      Map<String, dynamic> itemValues = {
        "Id": 0,
        "ItemID": itemIds[i],
        "Qty": quantity[i],
        "Rate": rateList[i],
        "ItemName": itemname[i],
        "Amount": totalamount[i],
        "UnitID": unitlist[i],
        "GSTAmount": gstTotal[i],
        "VATAmount": vatTotal[i],
        "CESSAmount": "",
        "InclusiveRate": "",
        "DiscAmount": discountAmount[i],
        "DiscPercentage": percentages[i],
        // "SalesOrderHDRID": 0,
        // "SalesOrderDTLID": 0
      };
      amm.add(itemValues);
    }
    double bamount = discountedBill - disc;

    Map<String, dynamic> da = {
      "Id": 0,
      "BillAmount": bamount.toStringAsFixed(User.decimals),
      "Discount": disc,
      "CustomerID": customerId,
      "DeliveryDate": from,
      "Items": amm.toList(),
      "InvoiceID": voucherid,
      "InvoiceDate": time,
      "RoundOff": "",
      "UpdatedTime": time,
      "SalesTypeID": widget.salesType,
      "Remarks": "",
      "UserID": User.userId
    };

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SettlementPage(
        customerName: widget.customerName,
        date: today,
        values: da,
        balance: customer_balance,
        radioValue: _radioValue1,
      );
    }));
  }

  Future<void> addtoOrders() async {
    EasyLoading.showInfo('Please Wait...');
    setState(() {
      isLoading = true;
    });

    List amm = [];
    String time = DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().day.toString() +
        " " +
        DateTime.now().hour.toString() +
        ":" +
        DateTime.now().minute.toString() +
        ":" +
        DateTime.now().second.toString();

    print(getIds.length);
    print(itemname.length);
    print(unitlist);

    for (int i = 0; i < itemname.length; i++) {
      Map<String, dynamic> itemValues = {
        "Id": i < getIds.length ? getIds[i] : 0,
        "ItemID": itemIds[i],
        "ItemName": itemname[i],
        "Amount": totalamount[i],
        "Qty": quantity[i],
        "Rate": rateList[i],
        "TaxAmount": taxTotal[i],
        "Total": totalamount[i],
        "UnitID": unitlist[i],
        "UpdatedBy": User.userId,
        "UpdatedTime": time,
        "GSTAmount": gstTotal[i],
        "VATAmount": vatTotal[i],
        "CESSAmount": "",
        "DiscAmount": discountAmount[i],
        "DiscPercentage": percentages[i],
      };
      amm.add(itemValues);
    }

    double bamount = discountedBill - disc;

    Map<String, dynamic> data = {
      //"Id": 28,
      "TotalTax": taxTotal.reduce((a, b) => a + b),
      "BillAmount": bamount.toStringAsFixed(User.decimals),
      "CustomerID": customerId,
      "DeliveryDate": from,
      "Items": amm.toList(),
      "OrderID": orderId,
      "OrderingDate": orderDate,
      "Remarks": "",
      "UpdatedTime": time,
      "SalesTypeID": salesTypeId,
      "UserID": User.userId,
    };

    var body = jsonEncode(data);

    if (await DataConnectionChecker().hasConnection) {
      print("Mobile data detected & internet connection confirmed.");
      String url = AppConfig.DOMAIN_PATH + "salesorder/save";
      final response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        EasyLoading.showSuccess('Successfully Saved');
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });
        EasyLoading.showError('Failed to Sent');
      }
    } else {
      print('No internet :( Reason:');
      APICacheDBModel cacheDBModel =
          new APICacheDBModel(key: data['OrderID'].toString(), syncData: body);
      await APICacheManager().addCacheData(cacheDBModel).then((value) => {
            if (value) {saveToDb(data)}
          });
    }
  }

  saveToDb(Map<String, dynamic> data) async {
    ContactinfoModel contactinfoModel = ContactinfoModel(
        id: null, userId: data['OrderID'].toString(), createdAt: "Order");
    await Controller().addData(contactinfoModel).then((value) {
      if (value > 0) {
        EasyLoading.showSuccess('Successfully Saved');
        Navigator.pop(context);
      } else {
        print("failed");
      }
    });
  }

  void initState() {
    // TODO: implement initState
    getSingleOrder(widget.orderId);
    fetchProducts = fetchDatas();
    getNames();
    refreshData();

    User().fetchUser().asStream().forEach((element) {
      ids = element[0].id.toString();
    });

    print(ids);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Screenshot(
        controller: _screenshotController,
        child: RefreshIndicator(
          onRefresh: refreshData,
          child: ListView(
            children: [
              homeData(),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  homeData() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Customer Name : ' + widget.customerName,
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 13,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Spacer(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Order Date : ' + today,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: _selectDate,
                    child: Text(
                      'Delivery Date : ' + from,
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: Colors.blueGrey,
                          decoration: TextDecoration.underline),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  takeBillPdf();
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
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Color(0xff20474f),
          height: 35,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.33,
                  child: Text(
                    'Item',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Text(
                    'Qty',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Text(
                    'Rate',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Text(
                    'Disc',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Text(
                    'Tax',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 14,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              ],
            ),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              itemCount: itemname.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    height: 30,
                    color: i.floor().isEven
                        ? Colors.blueGrey
                        : Colors.blueGrey[900],
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.33,
                          child: Text(
                            itemname[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          child: Text(
                            quantity[i].toString() + " " + units[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            rateList[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            allDiscounts[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            vatTotal[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Text(
                            discountedFinalRate[i].toString(),
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: GestureDetector(
                            onTap: () {
                              deleteItem(i);
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )),

        ///after container
        ///
        ///sss
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Discount',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      color: const Color(0xff5b5b5b),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/percentage.png',
                      fit: BoxFit.scaleDown,
                      height: 25,
                      width: 25,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 30,
                    padding: EdgeInsets.only(bottom: 7, left: 5),
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
                        controller: byPercentage,
                        maxLines: 1,
                        onChanged: discountPer,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'By Percentage',
                          hintStyle: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 10,
                            color: const Color(0x8cb0b0b0),
                          ),
                          //filled: true,
                          border: InputBorder.none,
                          filled: false,
                          isDense: false,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/dollar.png',
                      fit: BoxFit.scaleDown,
                      height: 25,
                      width: 25,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 30,
                    padding: EdgeInsets.only(bottom: 7, left: 5),
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
                        onChanged: discountPrice,
                        controller: byPrice,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'By Price',
                          hintStyle: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 10,
                            color: const Color(0x8cb0b0b0),
                          ),
                          //filled: true,
                          border: InputBorder.none,
                          filled: false,
                          isDense: false,
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    'Bill Amount   ',
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
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xff00ecb2),
                          const Color(0xff22bef1)
                        ],
                        stops: [0.0, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x80747474),
                          offset: Offset(6, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child:
                        Center(child: Text((discountedBill - disc).toString())),
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
                    'Balance Amount   ',
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
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          const Color(0xff00ecb2),
                          const Color(0xff22bef1)
                        ],
                        stops: [0.0, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x80747474),
                          offset: Offset(6, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(child: Text(customer_balance)),
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
                    'Confirmed   ',
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
                    child: Row(
                      children: [
                        Radio(
                          activeColor: Colors.cyan,
                          value: 0,
                          groupValue: _radioValue1,
                          onChanged: _handleRadioValueChange,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _radioValue1 = 0;
                            });
                          },
                          child: Text(
                            "Yes",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                //height: 1.6,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Radio(
                          activeColor: Colors.cyan,
                          value: 1,
                          groupValue: _radioValue1,
                          onChanged: _handleRadioValueChange,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _radioValue1 = 1;
                            });
                          },
                          child: Text(
                            "No",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                //height: 1.6,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return QRViewExample();
                      }));
                    },
                    child: Center(
                      child: Image.asset(
                        'assets/images/approvalscan.png',
                        fit: BoxFit.scaleDown,
                        color: Colors.blueGrey,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  Text(
                    "\nScan to Approve",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      _radioValue1 == 1
                          ? GestureDetector(
                              onTap: () {
                                if (itemname.length > 0) {
                                  if (from != "Select a date") {
                                    addtoOrders();
                                  } else {
                                    FlutterFlexibleToast.showToast(
                                        message: "Please select date...",
                                        // toastLength: Toast.LENGTH_LONG,
                                        toastGravity: ToastGravity.BOTTOM,
                                        icon: ICON.ERROR,
                                        radius: 50,
                                        elevation: 10,
                                        imageSize: 15,
                                        textColor: Colors.white,
                                        backgroundColor: Colors.black,
                                        timeInSeconds: 2);
                                  }
                                } else {
                                  FlutterFlexibleToast.showToast(
                                      message: "Please add items",
                                      // toastLength: Toast.LENGTH_LONG,
                                      toastGravity: ToastGravity.BOTTOM,
                                      icon: ICON.ERROR,
                                      radius: 50,
                                      elevation: 10,
                                      imageSize: 20,
                                      textColor: Colors.white,
                                      backgroundColor: Colors.black,
                                      timeInSeconds: 2);
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 120,
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
                                  child: Stack(
                                    children: [
                                      Center(
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
                                      isLoading
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        width: 15,
                      ),
                      _radioValue1 == 0
                          ? GestureDetector(
                              onTap: () {
                                if (itemname.length > 0) {
                                  if (from != "Select a date") {
                                    addtoInvoiceValues();
                                  } else {
                                    FlutterFlexibleToast.showToast(
                                        message: "Please select date...",
                                        // toastLength: Toast.LENGTH_LONG,
                                        toastGravity: ToastGravity.BOTTOM,
                                        icon: ICON.ERROR,
                                        radius: 50,
                                        elevation: 10,
                                        imageSize: 15,
                                        textColor: Colors.white,
                                        backgroundColor: Colors.black,
                                        timeInSeconds: 2);
                                  }
                                } else {
                                  FlutterFlexibleToast.showToast(
                                      message: "Please add items",
                                      // toastLength: Toast.LENGTH_LONG,
                                      toastGravity: ToastGravity.BOTTOM,
                                      icon: ICON.ERROR,
                                      radius: 50,
                                      elevation: 10,
                                      imageSize: 20,
                                      textColor: Colors.white,
                                      backgroundColor: Colors.black,
                                      timeInSeconds: 2);
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: const Color(0xff20474f),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x85747474),
                                      offset: Offset(6, 3),
                                      blurRadius: 6,
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Generate Invoice',
                                    style: TextStyle(
                                      fontFamily: 'Arial',
                                      fontSize: 18,
                                      color: const Color(0xfff7fdfd),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Spacer(),
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Future<void> showBookingDialog() {
    var textEditingController = TextEditingController();
    var byPer = TextEditingController();
    var byPri = TextEditingController();

    searchItemDialog() {
      showGeneralDialog(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 500),
        context: context,
        pageBuilder: (_, __, ___) {
          return StatefulBuilder(builder: (context, setState) {
            return Material(
                type: MaterialType.transparency,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xffffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x29000000),
                                      offset: Offset(6, 3),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                    controller: name,
                                    onChanged: (data) {
                                      setState(() {
                                        as = name.text;
                                        fetchProducts = fetchDatas();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter product name here',
                                      //filled: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 5,
                                          top: 15,
                                          right: 15),
                                      filled: false,
                                      isDense: false,
                                      prefixIcon: Icon(
                                        Icons.search,
                                        size: 25.0,
                                        color: Colors.grey,
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FutureBuilder<List<Products>>(
                                  future: fetchProducts,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              if (snapshot.data[index].name
                                                  .toLowerCase()
                                                  .contains(as.toLowerCase())) {
                                                return Card(
                                                  color: Colors.blueGrey[300],
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            180,
                                                        child: ListTile(
                                                          onTap: () {
                                                            setState(() {
                                                              textEditingController
                                                                      .text =
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .name;
                                                              vat = snapshot
                                                                  .data[index]
                                                                  .vatPerc;
                                                              tax = snapshot
                                                                  .data[index]
                                                                  .vatPerc;
                                                              Name = snapshot
                                                                  .data[index]
                                                                  .name;
                                                              saleRate.text =
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .salesRate
                                                                      .toString();
                                                              unitController
                                                                      .text =
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .baseUnit
                                                                      .toString();
                                                              stock = snapshot
                                                                  .data[index]
                                                                  .stock
                                                                  .toString();
                                                              ID = snapshot
                                                                  .data[index]
                                                                  .id
                                                                  .toString();
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                            showBookingDialog();
                                                          },
                                                          title: Text(
                                                            snapshot.data[index]
                                                                .name,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Arial',
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          subtitle: Text(
                                                            "Price : " +
                                                                snapshot
                                                                    .data[index]
                                                                    .salesRate
                                                                    .toString(),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Arial',
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          leading: snapshot
                                                                      .data[
                                                                          index]
                                                                      .productImage !=
                                                                  null
                                                              ? Container(
                                                                  width: 60,
                                                                  height: 80,
                                                                  child: Image
                                                                      .memory(
                                                                    base64Decode(snapshot
                                                                        .data[
                                                                            index]
                                                                        .productImage),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ))
                                                              : Image.asset(
                                                                  "assets/images/products.jpg",
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  //    color: Colors.white
                                                                ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return Container(
                                                  color: Colors.blue,
                                                );
                                              }
                                            }),
                                      );
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  }),
                            ],
                          ),
                        )),
                  ),
                ));
          });
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
            child: child,
          );
        },
      );
    }

    setState(() {
      saleQty.text = "1";
    });

    void calculteAmount(String a) {
      if (vat > 0) {
        print(rate);
        setState(() {
          totalAmount =
              double.parse(saleQty.text) * double.parse(saleRate.text);
          double t = totalAmount * (vat / 100);
          tax = double.parse(t.toStringAsFixed(User.decimals));
          totalAmount = totalAmount + tax;
          lastSaleRate = totalAmount;
        });
      } else {
        setState(() {
          print(saleRate.text);
          totalAmount = double.parse(saleQty.text) *
              double.parse(saleRate.text.toString());
          lastSaleRate =
              double.parse(totalAmount.toStringAsFixed(User.decimals));
        });
      }
    }

    void disPri(String a) {
      setState(() {
        lastSaleRate = totalAmount;
      });
      setState(() {
        lastSaleRate = totalAmount - double.parse(byPri.text);
        double a = (totalAmount - lastSaleRate) / (totalAmount) * 100;
        byPer.text = a.toStringAsFixed(User.decimals);
      });
    }

    void disPer(String a) {
      setState(() {
        lastSaleRate = totalAmount;
      });
      setState(() {
        lastSaleRate =
            totalAmount - totalAmount / 100 * double.parse(byPer.text);
        double val = totalAmount - lastSaleRate;
        byPri.text = val.toStringAsFixed(User.decimals);
      });
    }

    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (context, setState) {
          return Material(
              type: MaterialType.transparency,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 50, bottom: 5),
                            child: Text(
                              "Add Item",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 22),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    searchItemDialog();
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                          "assets/images/item.png",
                                          fit: BoxFit.scaleDown,
                                          color: Colors.black)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    searchItemDialog();
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        color: const Color(0xffffffff),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x29000000),
                                            offset: Offset(6, 3),
                                            blurRadius: 12,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18.0, left: 10),
                                        child: Text(Name),
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
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/weels.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18.0, left: 10),
                                      child: Text(stock),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/bucket.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.38,
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 0, bottom: 0, top: 12),
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
                                      //width:120,
                                      child: FutureBuilder(
                                          future: Future.delayed(
                                                  Duration(milliseconds: 200))
                                              .then((value) => fetchUnits(ID)),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data != null) {
                                              final List<Units> _cadastro =
                                                  snapshot.data;
                                              return Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        // canvasColor: Colors.blueGrey, // background color for the dropdown items
                                                        buttonTheme: ButtonTheme
                                                                .of(context)
                                                            .copyWith(
                                                                alignedDropdown:
                                                                    true,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 25,
                                                                        left:
                                                                            10),
                                                                height:
                                                                    50 //If false (the default), then the dropdown's menu will be wider than its button.
                                                                )),
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  value: null,
                                                  items: _cadastro.map((map) {
                                                    return DropdownMenuItem(
                                                      child: Text(map.unitName
                                                          .toString()),
                                                      value: map.salesRate
                                                          .toString(),
                                                      onTap: () {
                                                        setState(() {
                                                          saleRate.text = map
                                                              .salesRate
                                                              .toString();
                                                          unit = map.unitName
                                                              .toString();
                                                          unitID = map.unitId
                                                              .toString();
                                                        });
                                                        calculteAmount("");
                                                      },
                                                    );
                                                  }).toList(),
                                                  onChanged: (selected) {
                                                    setState(() {
                                                      _selectedUnit = selected;
                                                    });
                                                    calculteAmount("");
                                                    print(_selectedUnit);
                                                  },
                                                  hint: Text(unit),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                  height: 20,
                                                  width: 20,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()));
                                            }
                                          }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/dollar.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
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
                                      controller: saleRate,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Rate',
                                        //filled: true,
                                        hintStyle:
                                            TextStyle(color: Color(0xffb0b0b0)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            top: 15,
                                            right: 15),
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                // Adobe XD layer: 'surface1' (group)
                                GestureDetector(
                                    onTap: () {
                                      if (saleQty.text != "0") {
                                        setState(() {
                                          byPri.text = "";
                                          byPer.text = "";
                                          int a = int.parse(saleQty.text) - 1;
                                          saleQty.text = a.toString();
                                          calculteAmount("0");
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.blueGrey,
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
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
                                      controller: saleQty,
                                      onChanged: calculteAmount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Qty',
                                        //filled: true,
                                        hintStyle:
                                            TextStyle(color: Color(0xffb0b0b0)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            top: 15,
                                            right: 15),
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        byPri.text = "";
                                        byPer.text = "";
                                        int a = int.parse(saleQty.text) + 1;
                                        saleQty.text = a.toString();
                                        calculteAmount("0");
                                      });
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 50, bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/percentage.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Tax :  " +
                                      tax.toString() +
                                      "  (" +
                                      vat.toString() +
                                      "%)",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Discount',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 15,
                                    color: const Color(0xff5b5b5b),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Center(
                                  child: Image.asset(
                                    'assets/images/percentage.png',
                                    fit: BoxFit.scaleDown,
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 100,
                                  height: 30,
                                  padding: EdgeInsets.only(bottom: 7, left: 5),
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
                                      controller: byPer,
                                      maxLines: 1,
                                      onChanged: disPer,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'By Percentage',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 10,
                                          color: const Color(0x8cb0b0b0),
                                        ),
                                        //filled: true,
                                        border: InputBorder.none,
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Center(
                                  child: Image.asset(
                                    'assets/images/dollar.png',
                                    fit: BoxFit.scaleDown,
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 100,
                                  height: 30,
                                  padding: EdgeInsets.only(bottom: 5, left: 5),
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
                                      onChanged: disPri,
                                      controller: byPri,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'By Price',
                                        hintStyle: TextStyle(
                                          fontFamily: 'Arial',
                                          fontSize: 10,
                                          color: const Color(0x8cb0b0b0),
                                        ),
                                        //filled: true,
                                        border: InputBorder.none,
                                        filled: false,
                                        isDense: false,
                                      )),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Spacer(),
                                Text(
                                  'Total Amount   ',
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
                                    gradient: LinearGradient(
                                      begin: Alignment(0.0, -1.0),
                                      end: Alignment(0.0, 1.0),
                                      colors: [
                                        const Color(0xff00ecb2),
                                        const Color(0xff22bef1)
                                      ],
                                      stops: [0.0, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x80747474),
                                        offset: Offset(6, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: Text(lastSaleRate.toString())),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (Name != "" &&
                                        saleQty.text != "0" &&
                                        lastSaleRate > 0) {
                                      //   print("xxx3xxxxxx");
                                      if (byPri.text.isEmpty &&
                                          byPer.text.isEmpty) {
                                        addItem(
                                            Name,
                                            unit,
                                            unitID,
                                            totalAmount.toString(),
                                            int.parse(saleQty.text),
                                            ID,
                                            tax.toString(),
                                            tax.toString(),
                                            gst.toString(),
                                            saleRate.text,
                                            code,
                                            totalAmount.toString(),
                                            "0");
                                      } else {
                                        print("xxx4xxxxxx");
                                        addItem(
                                            Name,
                                            unit,
                                            unitID,
                                            lastSaleRate.toString(),
                                            int.parse(saleQty.text),
                                            ID,
                                            tax.toString(),
                                            tax.toString(),
                                            gst.toString(),
                                            saleRate.text,
                                            code,
                                            totalAmount.toString(),
                                            byPer.text);
                                      }

                                      setState(() {
                                        unit = "";
                                        unitID = "";
                                        ID = "";
                                        textEditingController.text = "";
                                        rate = "";
                                        saleQty.text = "";
                                        saleRate.text = "";
                                        unitController.text = "";
                                        totalAmount = 0.0;
                                        tax = 0;
                                        vat = 0;
                                        depoStock.text = "";
                                        lastSaleRate = 0;
                                      });

                                      Navigator.pop(context);
                                    } else {
                                      FlutterFlexibleToast.showToast(
                                          message: "Please add quantity",
                                          toastGravity: ToastGravity.BOTTOM,
                                          icon: ICON.ERROR,
                                          radius: 50,
                                          elevation: 10,
                                          imageSize: 15,
                                          textColor: Colors.white,
                                          backgroundColor: Colors.black,
                                          timeInSeconds: 2);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 120,
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
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  width: 120,
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
                                      'Cancel',
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
                              Spacer()
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )),
              ));
        });
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

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
    final file = File("${output.path}/" + "Sample.pdf");
    await file.writeAsBytes(await pdf.save());
    Share.shareFiles([file.path], text: "Shared from Cybrix");
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff20474f),
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text("Edit Order", style: TextStyle(color: Colors.white)),
      elevation: 1.0,
      actions: [
        Column(
          children: [
            Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showBookingDialog2();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/additem.png',
                              fit: BoxFit.scaleDown,
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "Return item",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showBookingDialog();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/additem.png',
                              fit: BoxFit.scaleDown,
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "Add item",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
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

  Future<void> showBookingDialog2() {
    var textEditingController = TextEditingController();

    searchItemDialog2() {
      showGeneralDialog(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 500),
        context: context,
        pageBuilder: (_, __, ___) {
          return StatefulBuilder(builder: (context, setState) {
            return Material(
                type: MaterialType.transparency,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListView(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xffffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x29000000),
                                      offset: Offset(6, 3),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                    controller: name,
                                    onChanged: (data) {
                                      setState(() {
                                        as = name.text;
                                        fetchProducts = fetchDatas();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter product name here',
                                      //filled: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 5,
                                          top: 15,
                                          right: 15),
                                      filled: false,
                                      isDense: false,
                                      prefixIcon: Icon(
                                        Icons.search,
                                        size: 25.0,
                                        color: Colors.grey,
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FutureBuilder<List<Products>>(
                                  future: fetchProducts,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              if (snapshot.data[index].name
                                                  .toLowerCase()
                                                  .contains(as.toLowerCase())) {
                                                return Card(
                                                  color: Colors.blueGrey[300],
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            180,
                                                        child: ListTile(
                                                          onTap: () {
                                                            setState(() {
                                                              textEditingController
                                                                      .text =
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .name;
                                                              Name = snapshot
                                                                  .data[index]
                                                                  .name;
                                                              saleRate.text =
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .salesRate
                                                                      .toString();
                                                              unitController
                                                                      .text =
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .baseUnit
                                                                      .toString();
                                                              stock = snapshot
                                                                  .data[index]
                                                                  .stock
                                                                  .toString();
                                                              ID = snapshot
                                                                  .data[index]
                                                                  .id
                                                                  .toString();
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                            showBookingDialog2();
                                                          },
                                                          title: Text(
                                                            snapshot.data[index]
                                                                .name,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Arial',
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          subtitle: Text(
                                                            "Price : " +
                                                                snapshot
                                                                    .data[index]
                                                                    .salesRate
                                                                    .toString(),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Arial',
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          leading: Image.asset(
                                                            "assets/images/products.jpg",
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            //    color: Colors.white
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return Container(
                                                  color: Colors.blue,
                                                );
                                              }
                                            }),
                                      );
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  }),
                            ],
                          ),
                        )),
                  ),
                ));
          });
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
            child: child,
          );
        },
      );
    }

    setState(() {
      saleQty.text = "1";
    });

    void calculteAmount(String a) {
      if (vat > 0) {
        setState(() {
          totalAmount = double.parse(saleQty.text) * double.parse(rate);
          double t = totalAmount * (vat / 100);
          tax = double.parse(t.toStringAsFixed(User.decimals));
          totalAmount = totalAmount + tax;
          lastSaleRate = totalAmount;
        });
      } else {
        setState(() {
          print(saleRate.text);
          totalAmount = double.parse(saleQty.text) *
              double.parse(saleRate.text.toString());
          lastSaleRate =
              double.parse(totalAmount.toStringAsFixed(User.decimals));
        });
      }
    }

    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(builder: (context, setState) {
          return Material(
              type: MaterialType.transparency,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 50, bottom: 5),
                            child: Text(
                              "Return Item",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 22),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    searchItemDialog2();
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                          "assets/images/item.png",
                                          fit: BoxFit.scaleDown,
                                          color: Colors.black)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    searchItemDialog2();
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        color: const Color(0xffffffff),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x29000000),
                                            offset: Offset(6, 3),
                                            blurRadius: 12,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18.0, left: 10),
                                        child: Text(Name),
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
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/weels.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18.0, left: 10),
                                      child: Text(stock),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/bucket.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.38,
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 0, bottom: 0, top: 12),
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
                                      //width:120,
                                      child: FutureBuilder(
                                          future: Future.delayed(
                                                  Duration(milliseconds: 200))
                                              .then((value) => fetchUnits(ID)),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data != null) {
                                              final List<Units> _cadastro =
                                                  snapshot.data;
                                              return Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        buttonTheme: ButtonTheme
                                                                .of(context)
                                                            .copyWith(
                                                                alignedDropdown:
                                                                    true,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 25,
                                                                        left:
                                                                            10),
                                                                height:
                                                                    50 //If false (the default), then the dropdown's menu will be wider than its button.
                                                                )),
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  value: null,
                                                  items: _cadastro.map((map) {
                                                    return DropdownMenuItem(
                                                      child: Text(map.unitName
                                                          .toString()),
                                                      value: map.salesRate
                                                          .toString(),
                                                      onTap: () {
                                                        setState(() {
                                                          saleRate.text = map
                                                              .salesRate
                                                              .toString();
                                                          unit = map.unitName
                                                              .toString();
                                                          unitID = map.unitId
                                                              .toString();
                                                        });
                                                        calculteAmount("");
                                                      },
                                                    );
                                                  }).toList(),
                                                  onChanged: (selected) {
                                                    setState(() {
                                                      _selectedUnit = selected;
                                                    });
                                                    calculteAmount("");
                                                    print(_selectedUnit);
                                                  },
                                                  hint: Text(unit),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                  height: 20,
                                                  width: 20,
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()));
                                            }
                                          }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/dollar.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
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
                                      controller: saleRate,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Rate',
                                        //filled: true,
                                        hintStyle:
                                            TextStyle(color: Color(0xffb0b0b0)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            top: 15,
                                            right: 15),
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                // Adobe XD layer: 'surface1' (group)
                                GestureDetector(
                                    onTap: () {
                                      if (saleQty.text != "0") {
                                        setState(() {
                                          int a = int.parse(saleQty.text) - 1;
                                          saleQty.text = a.toString();
                                          calculteAmount("0");
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.blueGrey,
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
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
                                      controller: saleQty,
                                      onChanged: calculteAmount,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Qty',
                                        //filled: true,
                                        hintStyle:
                                            TextStyle(color: Color(0xffb0b0b0)),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 15,
                                            top: 15,
                                            right: 15),
                                        filled: false,
                                        isDense: false,
                                      )),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        int a = int.parse(saleQty.text) + 1;
                                        saleQty.text = a.toString();
                                        calculteAmount("0");
                                      });
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blueGrey,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 50, bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                        "assets/images/percentage.png",
                                        fit: BoxFit.scaleDown,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Tax :  " +
                                      tax.toString() +
                                      "  (" +
                                      vat.toString() +
                                      "%)",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
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
                                  'Total Amount   ',
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
                                    gradient: LinearGradient(
                                      begin: Alignment(0.0, -1.0),
                                      end: Alignment(0.0, 1.0),
                                      colors: [
                                        const Color(0xff00ecb2),
                                        const Color(0xff22bef1)
                                      ],
                                      stops: [0.0, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x80747474),
                                        offset: Offset(6, 3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                      child: Text(lastSaleRate.toString())),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Spacer(),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (Name != "" &&
                                        saleQty.text != "0" &&
                                        lastSaleRate > 0) {
                                      addItem(
                                          Name,
                                          unit,
                                          unitID,
                                          "-" + totalAmount.toString(),
                                          int.parse("-" + saleQty.text),
                                          ID,
                                          "-" + tax.toString(),
                                          "-" + tax.toString(),
                                          "-" + gst.toString(),
                                          saleRate.text,
                                          code,
                                          "-" + totalAmount.toString(),
                                          "0");

                                      setState(() {
                                        unit = "";
                                        unitID = "";
                                        ID = "";
                                        textEditingController.text = "";
                                        rate = "";
                                        saleQty.text = "";
                                        saleRate.text = "";
                                        unitController.text = "";
                                        totalAmount = 0.0;
                                        tax = 0;
                                        vat = 0;
                                        depoStock.text = "";
                                        lastSaleRate = 0;
                                      });

                                      Navigator.pop(context);
                                    } else {
                                      FlutterFlexibleToast.showToast(
                                          message: "Please add quantity",
                                          toastGravity: ToastGravity.BOTTOM,
                                          icon: ICON.ERROR,
                                          radius: 50,
                                          elevation: 10,
                                          imageSize: 15,
                                          textColor: Colors.white,
                                          backgroundColor: Colors.black,
                                          timeInSeconds: 2);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 120,
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
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  width: 120,
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
                                      'Cancel',
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
                              Spacer()
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )),
              ));
        });
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
