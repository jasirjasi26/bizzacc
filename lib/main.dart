import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:optimist_erp_app/screens/splash.dart';
import 'package:optimist_erp_app/screens/van_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: VanPage(back: true,billAmount: "",date: "",voucherNumber: "",customerName: "",),
      home: Splash(),
    );
  }
}

