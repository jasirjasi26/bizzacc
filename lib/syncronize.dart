import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'databasehelper.dart';
import 'contactinfomodel.dart';
import 'package:http/http.dart' as htpp;
import 'package:optimist_erp_app/app_config.dart';

import 'models/order_save.dart';

class SyncronizationData {
  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet :( Reason:');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("wifi data detected & internet connection confirmed.");
        return true;
      } else {
        print('No internet :( Reason:');
        return false;
      }
    } else {
      print(
          "Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }

  final conn = SqfliteDatabaseHelper.instance;

  Future<List<ContactinfoModel>> fetchAllInfo() async {
    final dbClient = await conn.db;
    List<ContactinfoModel> contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.contactinfoTable);
      for (var item in maps) {
        contactList.add(ContactinfoModel.fromJson(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future saveToMysqlWith(List<ContactinfoModel> contactList) async {
    String url1 = AppConfig.DOMAIN_PATH + "salesorder/save";
    String url2 = AppConfig.DOMAIN_PATH + "salesinvoice/save";
    String url3 = AppConfig.DOMAIN_PATH + "salesreturn/save";

    if (await DataConnectionChecker().hasConnection) {
      for (var i = 0; i < contactList.length; i++) {
        if (contactList[i].createdAt.toString() == "Order") {
          var cacheData = await APICacheManager()
              .getCacheData(contactList[i].userId.toString());
          final response = await htpp.post(
            url1,
            body: cacheData.syncData,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );
          if (response.statusCode == 200) {
            print("Saving Data ");
            await APICacheManager().deleteCache(contactList[i].userId.toString());
          } else {
            print("Failed Saving Data ");
          }
        }

        if (contactList[i].createdAt.toString() == "Invoice") {
          var cacheData = await APICacheManager()
              .getCacheData(contactList[i].userId.toString());
          final response = await htpp.post(
            url2,
            body: cacheData.syncData,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );
          if (response.statusCode == 200) {
            print("Saving Data ");
            await APICacheManager().deleteCache(contactList[i].userId.toString());
          } else {
            print("Failed Saving Data ");
          }
        }

        if (contactList[i].createdAt.toString() == "Return") {
          var cacheData = await APICacheManager()
              .getCacheData(contactList[i].userId.toString());
          final response = await htpp.post(
            url3,
            body: cacheData.syncData,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          );
          if (response.statusCode == 200) {
            print("Saving Data ");
            await APICacheManager().deleteCache(contactList[i].userId.toString());
          } else {
            print("Failed Saving Data ");
          }
        }
      }

    }


  }

  Future<List> fetchAllCustoemrInfo() async {
    final dbClient = await conn.db;
    List contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.contactinfoTable);
      for (var item in maps) {
        contactList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future saveToMysql(List contactList) async {
    for (var i = 0; i < contactList.length; i++) {
      Map<String, dynamic> data = {
        "contact_id": contactList[i]['id'].toString(),
        "user_id": contactList[i]['user_id'].toString(),
        "name": contactList[i]['name'],
        "email": contactList[i]['email'],
        "gender": contactList[i]['gender'],
        "created_at": contactList[i]['created_at'],
      };
      final response = await htpp.post(
          'http://192.168.43.6/syncsqftomysqlflutter/load_from_sqflite_contactinfo_table_save_or_update_to_mysql.php',
          body: data);
      if (response.statusCode == 200) {
        print("Saving Data ");
      } else {
        print(response.statusCode);
      }
    }
  }
}
