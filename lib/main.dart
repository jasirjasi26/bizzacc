// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:optimist_erp_app/screens/splash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:optimist_erp_app/syncronize.dart';
import 'contactinfomodel.dart';
import 'controller.dart';
import 'databasehelper.dart';
import 'package:uuid/uuid.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  await SqfliteDatabaseHelper.instance.db;
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Splash(),
      //home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: () async{
                //Controller().delete();
                var uuid = Uuid();
                print(uuid.v1().trim());
                String id="V10S"+DateTime.now().year.toString()+DateTime.now().month.toString()+DateTime.now().day.toString()+DateTime.now().hour.toString()+DateTime.now().minute.toString()+DateTime.now().second.toString();

                ContactinfoModel contactinfoModel = ContactinfoModel(id: null,userId: id,name: "ssss",email: "ee",gender: "dddddd",createdAt: DateTime.now().toString());
                await Controller().addData(contactinfoModel).then((value){
                  if (value>0) {
                    print("Success");
                    Controller().fetchData().then((value) => {
                      print(value)
                    });
                    //userList();
                  }else{
                    print("faild");
                  }

                });
              },
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}







// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       //home: VanPage(back: true,billAmount: "",date: "",voucherNumber: "",customerName: "",),
//       home: Splash(),
//     );
//   }
// }
//
