import 'dart:ui';
import 'package:adobe_xd/page_link.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:optimist_erp_app/app_config.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/screens/login.dart';
import 'package:optimist_erp_app/screens/pin_page.dart';
import 'package:optimist_erp_app/ui_elements/bottomNavigation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  getUser() async {
    // Obtain shared preferences.
    // final prefs = await SharedPreferences.getInstance();
    // String name = prefs.getString("name");
    // String number = prefs.getString("number");
    // String vanNumber = prefs.getString("vanNo");
    // String dbs = prefs.getString("database");
    //
    // if (name != null && number != null) {
    //   User.number = number;
    //   User.name = name;
    //   User.vanNo = vanNumber;
    //   User.database = dbs;
    //   User.database = dbs;
    //
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return BottomBar();
    //   }));
    // }
    AppConfig.getApi();
    User().fetchUser().then((value) => {
      if(value[0].id!=null&&value[0].accountId!=null){
        User().fetchUser().then((value) => {
      value.forEach((element) {
        setState(() {
          User.depotId=element.depotId.toString();
          User.name=element.userName.toString();
          User.userId=element.id.toString();
          User.accId=element.accountId.toString();
        });
      })
    }),
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BottomBar();
    }))
           // Navigator.push(context, MaterialPageRoute(builder: (context) {
           //    return PinPage();
           //  })),
      }
    });
  }

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);


    getUser();
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
      // backgroundColor: const Color(0xff2a7980),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/images/bizacc_splash.png",
                scale: 1.5, fit: BoxFit.cover),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -7.59),
                end: Alignment(0.0, 1.0),
                colors: [const Color(0xff2a7980), const Color(0xff20474f)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Login();
                      }));
                    },
                    child: Container(
                        width: 160,
                        height: 45,
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 1.0),
                            colors: [
                              const Color(0xff00ecb2),
                              const Color(0xff12b3e3)
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 20,
                              color: const Color(0xfff7fdfd),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
