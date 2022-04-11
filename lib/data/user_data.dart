import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_details.dart';

class User{
  static String name="";
 static String vanNo="";
  static String number="";
  static String database="";
  static String depotId="";
  static String userId="";
  static String accId="";
  static String companylogo="";

  // static String voucherStarting="V"+vanNo+"S";
  // static String orderStarting="S"+vanNo+"O";
  // static String voucherNumber="";
  // static String orderNumber="";

  Future<bool> addUser(var response) async {
    // Obtain shared preferences.
    bool result=false;
    final prefs = await SharedPreferences.getInstance();
    var user = jsonEncode(logindataFromJson(response));
    await prefs.setString('userData', user).then((value) => {
      if(value){
        result=value,
      }
    });
    return result;
  }

  Future<List<Logindata>> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    var json = jsonDecode(prefs.getString('userData'));
    var user1 = logindataFromJson(prefs.getString('userData'));
    return user1;
  }


  clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}