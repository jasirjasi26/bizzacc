import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimist_erp_app/ui_elements/bottomNavigation.dart';


class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  List<String> _locations = ['IND', 'US', 'UK', 'PK']; // Option 2
  String _selectedLocation;


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
                  Center(
                    child: Padding(
                      padding:  EdgeInsets.all(0),
                      child: Card(
                        elevation: 5,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 50,
                          padding: const EdgeInsets.only(),
                          // decoration: BoxDecoration(
                          //   // color: Color(0xfffb4ce5),
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          child: Row(
                            children: [
                              SizedBox(width: 5,),
                              Icon(
                                Icons.flag,
                                size: 25.0,
                                color: Colors.grey,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 50,
                                padding: EdgeInsets.only(
                                    left: 20.0, top: 10, ),
                                child: DropdownButton(
                                  isDense: true,
                                  //itemHeight: 50,
                                  iconSize: 30,
                                  isExpanded: true,
                                  hint: Text('Select Country'),
                                  value: _selectedLocation,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedLocation = newValue;
                                    });
                                  },
                                  items: _locations.map((location) {
                                    return DropdownMenuItem(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:0.0,left: 0),
                                        child: new Text(location),
                                      ),
                                      value: location,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.714,
                      child: Card(
                        elevation: 10,
                        child: Container(
                          child: TextFormField(
                            // controller: _username,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    left: 20, top: 15),
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
                        ' Login ',
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
