import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optimist_erp_app/data/user_data.dart';
import 'package:optimist_erp_app/ui_elements/bottomNavigation.dart';
import 'package:firebase_database/firebase_database.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  List<dynamic> _locations = [];
  String code;
  List<String> userNumbers = []; // Option 2
  String _selectedLocation;
  DatabaseReference types;
  DatabaseReference numbers;
  var number=TextEditingController();

  Future<void> getCountryAndNumbers() async {
    await types.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        _locations.add(values.toString());
      });
    });
  }

  Future<void> authenticate() async {

    await numbers.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if(code.toString()+number.text==values["ID"].toString()){
          User.number=values["ID"].toString();
          User.name=values["Name"].toString();
          User.vanNo=values["VanNO"].toString();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BottomBar();
          }));
        }else{
          print("Error");
        }
      });
    });
  }

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    types = FirebaseDatabase.instance
        .reference()
        .child("CountryCodes");

    numbers = FirebaseDatabase.instance
        .reference().child("Companies")
        .child("CYBRIX").child("USERS");

    getCountryAndNumbers();
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
                                    if(_selectedLocation=="UAE"){
                                      setState(() {
                                        code="+971";
                                      });
                                    }
                                    if(_selectedLocation=="India"){
                                      setState(() {
                                        code="+91";
                                      });
                                    }
                                    if(_selectedLocation=="Nigeria"){
                                      setState(() {
                                        code="+234";
                                      });
                                    }
                                    if(_selectedLocation=="Sri Lanka"){
                                      setState(() {
                                        code="+94";
                                      });
                                    }
                                    if(_selectedLocation=="Kuwait"){
                                      setState(() {
                                        code="+965";
                                      });
                                    }
                                    if(_selectedLocation=="Saudi Arabia"){
                                      setState(() {
                                        code="+966";
                                      });
                                    }
                                    if(_selectedLocation=="Oman"){
                                      setState(() {
                                        code="+968";
                                      });
                                    }
                                    if(_selectedLocation=="Bahrain"){
                                      setState(() {
                                        code="+973";
                                      });
                                    }
                                    if(_selectedLocation=="Quatar"){
                                      setState(() {
                                        code="+974";
                                      });
                                    }
                                    print(_selectedLocation);
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
                             controller: number,
                              keyboardType: TextInputType.number,
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
                     authenticate();
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
