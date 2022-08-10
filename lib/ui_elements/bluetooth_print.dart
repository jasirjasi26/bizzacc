// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:typed_data';
import 'package:optimist_erp_app/data/user_data.dart';


class Print extends StatefulWidget {
  Print(
      {Key key,
        this.customerName,
        this.date,
        this.voucherNumber,
        this.billAmount,this.customerCode,  this.cash,this.card, this.balance})
      : super(key: key);

  final String date;
  final String cash;final String card;
  final String balance;
  final String customerName;
  final String voucherNumber;
  final String billAmount;
  final String customerCode;

  @override
  PrintState createState() => PrintState();
}

class PrintState extends State<Print> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  DatabaseReference reference;
  List<String> total = [];
  List<String> item = [];
  List<String> rate = [];
  List<int> qty = [];
  List<String> tax = [];
  List<dynamic> disc = [];
  String cash = "-";
  String card = "-";
  String roundOff = "-";
  String balance = "-";
  String totaltax = "-";
  String totalDisc = "-";
  String bill = "-";
  String generatedPdfFilePath;
  String totalBill = "-";
  double totalReceived=0;
  String billTime="--";
  int totalQty=0;
  Uint8List bytes;
  String company="--";
  String companyTrno="--";
  String companyAddress="--";
  String name="--";
  String customerName="--";
  String customerCode="--";
  String voucherNumber="--";
  //var image;


  Future<void> getBill() async {

    ///load details of company
    ///
    setState(() {
      name=User.name=="" || User.name==null ? "--" : User.name;
      company=User.companyName == "" || User.companyName==null ? "--" : User.companyName;
      //companyTrno=User == "" || User.trno==null ? "--" :User.trno;
      companyAddress=User.companyAdd1 =="" || User.companyAdd1==null ? "--" :User.companyAdd1;
      customerName=widget.customerName=="" ? "--" : widget.customerName;
      customerCode=widget.customerCode=="" || widget.customerCode == null ? "--" : widget.customerCode;
      voucherNumber=widget.voucherNumber=="" ? "--" : widget.voucherNumber;
    });
    //
    // print("kk");
    // print(name);
    // print(company);
    // print(customerCode);
    // print(customerName);
    // print(voucherNumber);
    // print(companyTrno);
    // print(companyAddress);

  }


  sample() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    try{
      await bluetooth.isConnected.then((isConnected) {
        if (isConnected) {
          EasyLoading.showInfo('Started Printing....');
          bluetooth.printNewLine();
          bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printCustom(company, 3, 1);
          bluetooth.printNewLine();
          bluetooth.printCustom(companyAddress, 1, 1);
          bluetooth.printCustom("TRN No."+companyTrno, 1, 1);
          bluetooth.printNewLine();
          bluetooth.printCustom("CASH RECEIPT", 2, 1);
          bluetooth.printCustom("------------------------------------", 0, 1);
          bluetooth.printCustom("Customer Name : "+ widget.customerName, 1, 1);
          bluetooth.printCustom("Customer Code : "+ widget.customerCode, 1, 1);
          bluetooth.printCustom("Customer Address : ", 1, 1);
          bluetooth.printCustom("Invoice Number : "+ widget.voucherNumber, 1, 1);
          bluetooth.printNewLine();
          bluetooth.printCustom("Date&Time: "+ widget.date, 1, 1);
          bluetooth.printCustom("Salesman Name: "+name.toUpperCase(), 1, 1);
         // bluetooth.printCustom("-----------------------------", 0, 1);
          //bluetooth.printCustom("Item Name           Qty   Amount", 0, 0);
         // bluetooth.printCustom("-----------------------------", 0, 1);
          // for(int i=0;i<item.length;i++){
          //   bluetooth.printLeftRight(item[i].toString(), qty[i].toString()+"    "+total[i].toString(), 0);
          //   bluetooth.printNewLine();
          // }
          //bluetooth.printCustom("-----------------------------", 0, 1);
          bluetooth.printNewLine();
          //bluetooth.printLeftRight("Total Qty: "+totalQty.toString(), "", 0);
          //bluetooth.printLeftRight("Grand Total: "+widget.billAmount, " ", 0);
          // bluetooth.printLeftRight("Discount: "+totalDisc, " ", 0);
          // bluetooth.printLeftRight("RoundOff: "+roundOff, " ", 0);
          // bluetooth.printLeftRight("Vat (5%): "+totaltax, " ", 0);
          bluetooth.printCustom("Net Amount: "+widget.billAmount, 2, 1);
          bluetooth.printNewLine();
          bluetooth.printCustom("Cash Received: "+widget.cash, 1, 1);
          bluetooth.printCustom("Card Received: "+widget.card, 1, 1);
          bluetooth.printCustom("Total Received: "+widget.billAmount, 1, 1);
          bluetooth.printCustom("Current Balance: "+widget.balance, 1, 1);
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printLeftRight("Authorized Signature :           ", "    Customer Signature :          ", 1);
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.paperCut();
          EasyLoading.showInfo('Printing Done....');
        }else{
          EasyLoading.showError('Not Connected');
        }
      });
    }catch(e){
      EasyLoading.showError(e);
    }

  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getBill();
  }


  Future<void> initPlatformState() async {

    ///Loading image
    Uint8List bytes1 = base64Decode(User.companylogo);
        // setState(() {
        //   image = bytes;
        // });
  //  final ByteData data = await rootBundle.load('assets/images/logo.jpg');
    setState(() {
      //bytes = data.buffer.asUint8List();
      bytes=bytes1;
    });


    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            EasyLoading.showInfo('bluetooth device state: connected');
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            EasyLoading.showInfo('bluetooth device state: disconnected');
            print("bluetooth device state: disconnected");
          });
          break;
        // case BlueThermalPrinter.DISCONNECT_REQUESTED:
        //   setState(() {
        //     _connected = false;
        //     print("bluetooth device state: disconnect requested");
        //   });
        //   break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            EasyLoading.showInfo('bluetooth device state: bluetooth turning off');
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            EasyLoading.showInfo('bluetooth device state: bluetooth off');
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            EasyLoading.showInfo('bluetooth device state: bluetooth on');
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            EasyLoading.showInfo('bluetooth device state: bluetooth turning on');
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            EasyLoading.showInfo('bluetooth device state: error');
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                bytes != null
                    ? Center(child: Container(width: 150, height: 150, child: Image.memory(bytes,fit: BoxFit.fill,)))
                    : Container(),
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (value) => setState(() => _device = value),
                        value: _device,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.brown),
                      onPressed: () {
                        initPlatformState();
                      },
                      child: Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: _connected ? Colors.red : Colors.green),
                      onPressed: _connected ? _disconnect : _connect,
                      child: Text(
                        _connected ? 'Disconnect' : 'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 30.0, right: 30.0, top: 40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.brown),
                    onPressed: ()  {
                      sample();
                    },
                    child: Text('PRINT',
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      EasyLoading.showError("No device selected");
      show('No device selected.');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            EasyLoading.showError(error);
            setState(() => _connected = false);
          });

          setState(() => _connected = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future show(
      String message, {
        Duration duration: const Duration(seconds: 3),
      }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    // ScaffoldMessenger.of(context).showSnackBar(
    //   new SnackBar(
    //     content: new Text(
    //       message,
    //       style: new TextStyle(
    //         color: Colors.white,
    //       ),
    //     ),
    //     duration: duration,
    //   ),
   // );
  }
}