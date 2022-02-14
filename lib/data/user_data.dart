import 'package:shared_preferences/shared_preferences.dart';

class User{
  static String name="";
 static String vanNo="";
  static String number="";
  static String database="";

  static String voucherStarting="V"+vanNo+"S";
  static String orderStarting="S"+vanNo+"O";
  static String voucherNumber="";
  static String orderNumber="";


  addUser() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name);
    prefs.setString("number", number);
    prefs.setString("vanNo", vanNo);
    prefs.setString("database", database);
  }


  clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}