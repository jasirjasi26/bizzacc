import 'dart:ui';
import 'package:adobe_xd/page_link.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:optimist_erp_app/screens/bottomNavigation.dart';
import 'package:optimist_erp_app/screens/home.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
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
            child: Image.asset("assets/images/loginbackground.png",scale: 1.5,fit: BoxFit.cover),
          ),
          Center(
            child: Padding(
              padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.35),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:  AssetImage('assets/images/login_logo.png'),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Card(
                        elevation: 10,
                        child: Container(
                          child: TextFormField(
                           // controller: _username,
                            decoration: InputDecoration(
                                hintText: 'Select Country',
                                //filled: true,
                              filled: false,
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 15, top: 15, right: 15),
                                prefixIcon: Icon(
                                  Icons.flag,
                                  size: 25.0,
                                  color: Colors.grey,
                                ),)
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Card(
                        elevation: 10,
                        child: Container(
                          child: TextFormField(
                            // controller: _username,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 15, top: 15, right: 15),
                                hintText: 'Enter Mobile Number',
                                //filled: true,
                                filled: false,
                                prefixIcon: Icon(
                                  Icons.phone,
                                  size: 25.0,
                                  color: Colors.grey,
                                ),)
                          ),
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 50,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return BottomBar(
                        );
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        gradient: LinearGradient(
                          begin: Alignment(0.01, -0.72),
                          end: Alignment(0.0, 1.0),
                          colors: [const Color(0xff385194), const Color(0xff182d66)],
                          stops: [0.0, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x80182d66),
                            offset: Offset(6, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 20,
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
