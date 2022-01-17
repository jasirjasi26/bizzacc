import 'dart:ui';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:optimist_erp_app/screens/login.dart';

import 'home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

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
      backgroundColor:  Color.fromRGBO(77,102,169,1),

      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/images/splashbackground.png",scale: 1.5,fit: BoxFit.cover),
          ),
          Center(
            child: Padding(
              padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.35),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:  AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Text(
                    'It\'s Time To Inspire',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 25,
                      color: const Color(0xfff7fdfd),
                    ),
                    textAlign: TextAlign.left,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.3,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Login(
                        );
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 25,right: 25,top: 10,bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: LinearGradient(
                          begin: Alignment(0.0, -4.76),
                          end: Alignment(0.0, 1.0),
                          colors: [const Color(0xffffffff), const Color(0xff1ebdf2)],
                          stops: [0.0, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x291ebdf2),
                            offset: Offset(6, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 25,
                          color: const Color(0xfff7fdfd),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
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
