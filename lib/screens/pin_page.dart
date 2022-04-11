
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:optimist_erp_app/ui_elements/bottomNavigation.dart';
import 'package:pinput/pin_put/pin_put.dart';
import '../data/user_data.dart';
import 'otp.dart';

class PinPage extends StatefulWidget {
  @override
  PinPageState createState() => new PinPageState();
}

class PinPageState extends State<PinPage> {
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  String id="";

  void _showSnackBar(String pin) {
    if (_pinPutController.text == "1111") {

      User().fetchUser().then((value) => {
        value.forEach((element) {
          setState(() {
            User.depotId=element.depotId.toString();
            User.name=element.userName.toString();
            User.userId=element.id.toString();
          });
        })
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BottomBar();
      }));
    } else {
      EasyLoading.showError('Incorrect Pin');
      _pinPutController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 120),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/images/bizacc_login.png",
                scale: 1.5, fit: BoxFit.cover),
          ),
           Center(
              child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Welcome back!",style: TextStyle(fontSize: 30,color: Colors.blueGrey),),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: PinPut(
                    obscureText: "*",
                    fieldsCount: 4,
                    withCursor: true,
                    textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                    eachFieldWidth: 55.0,
                    eachFieldHeight: 55.0,
                    onSubmit: (String pin) => _showSnackBar(pin),
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                    pinAnimationType: PinAnimationType.fade,
                  ),
                ),
                Spacer(),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
