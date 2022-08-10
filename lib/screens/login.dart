import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flexible_toast/flutter_flexible_toast.dart';
import 'package:optimist_erp_app/screens/pin_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../app_config.dart';
import '../data/user_data.dart';
import '../models/login_details.dart';
import '../ui_elements/bottomNavigation.dart';


class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  late String code;
  List<String> userNumbers = [];
  var username = TextEditingController();
  var password = TextEditingController();
  var api = TextEditingController();




  Future<bool> login(String username, String password) async {
    AppConfig.setApi(api.text);

    try {
      Map data = {'name': username, 'pass': password};
      String url = AppConfig.DOMAIN_PATH + "login";

      FlutterFlexibleToast.showToast(
          message: url,
          toastGravity: ToastGravity.BOTTOM,
          icon: ICON.LOADING,
          radius: 50,
          elevation: 10,
          imageSize: 15,
          textColor: Colors.white,
          backgroundColor: Colors.black,
          timeInSeconds: 2);

      final response = await http.post(url,
          body:data,
      );

      switch (response.statusCode) {
        case 200:
          FlutterFlexibleToast.showToast(
              message: "Please Wait...",
              toastGravity: ToastGravity.BOTTOM,
              icon: ICON.LOADING,
              radius: 50,
              elevation: 10,
              imageSize: 15,
              textColor: Colors.white,
              backgroundColor: Colors.black,
              timeInSeconds: 2);
          bool a=await User().addUser(response.body);
          return a;
          break;
        case 404:
          FlutterFlexibleToast.showToast(
              message: response.body,
              toastGravity: ToastGravity.BOTTOM,
              //icon: ICON.ERROR,
              radius: 50,
              elevation: 10,
              imageSize: 15,
              textColor: Colors.white,
              backgroundColor: Colors.black,
              timeInSeconds: 2);
          return false;
          break;
        default:
          FlutterFlexibleToast.showToast(
              message: response.body,
              toastGravity: ToastGravity.BOTTOM,
              //icon: ICON.ERROR,
              radius: 50,
              elevation: 10,
              imageSize: 15,
              textColor: Colors.white,
              backgroundColor: Colors.black,
              timeInSeconds: 2);
          return false;
          break;
      }
    } on Exception {
      FlutterFlexibleToast.showToast(
          message: "Something went wrong",
          toastGravity: ToastGravity.BOTTOM,
          icon: ICON.ERROR,
          radius: 50,
          elevation: 10,
          imageSize: 15,
          textColor: Colors.white,
          backgroundColor: Colors.black,
          timeInSeconds: 2);
      return false;
    }
  }


  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);

    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(77, 102, 169, 1),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Stack(
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
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4),
                child: Column(
                  children: [
                    Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        // padding: EdgeInsets.only(bottom: 7, left: 5),
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
                            controller: api,
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.only(left: 20, top: 15),
                              prefixIcon: Icon(
                                Icons.data_usage,
                                size: 25.0,
                                color: Colors.grey,
                              ),
                              hintText: 'http://123.456.789.10/ERPWeb/api/',
                              hintStyle: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 14,
                                //color:  Colors.black,
                              ),
                              //filled: true,
                              border: InputBorder.none,
                              filled: false,
                              isDense: false,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                       // padding: EdgeInsets.only(bottom: 7, left: 5),
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
                            controller: username,
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.only(left: 20, top: 15),
                              prefixIcon: Icon(
                                Icons.person,
                                size: 25.0,
                                color: Colors.grey,
                              ),
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 14,
                                //color:  Colors.black,
                              ),
                              //filled: true,
                              border: InputBorder.none,
                              filled: false,
                              isDense: false,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Card(
                          elevation: 10,
                          child: Container(
                            child: TextFormField(
                                controller: password,
                               // keyboardType: TextInputType.number,
                                obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 20, top: 15),
                                  hintText: 'Password',
                                  //filled: true,
                                  filled: false,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    size: 25.0,
                                    color: Colors.grey,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {

                        login(username.text, password.text).then((value) => {
                          if(value){
                            User().fetchUser().then((value) => {
                          value.forEach((element) {
                            setState(() {
                              User.depotId=element.depotId.toString();
                              User.name=element.userName.toString();
                              User.userId=element.id.toString();
                            });
                          })
                        }),
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BottomBar();
                            }))
                          }
                        });



                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 1.0),
                            colors: [const Color(0xff00ecb2), const Color(0xff12b3e3)],
                            stops: [0.0, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xffcdcdcd),
                              offset: Offset(6, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            ' Login ',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 20,
                              color: const Color(0xfff7fdfd),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
