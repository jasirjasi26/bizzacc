import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimist_erp_app/data/user_data.dart';

class SalesLedger extends StatefulWidget {
  @override
  SalesLedgerState createState() => SalesLedgerState();
}

class SalesLedgerState extends State<SalesLedger> {
  DatabaseReference reference;
  List<String> names = [];
  List<String> balance = [];

  Future<void> getCustomerId() async {
    setState(() {
      names.clear();
      balance.clear();
    });

    await reference.child("Accounts").once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        setState(() {
          names.add(key);
          balance.add(values["TotalBalance"].toString());
        });
      });
    });
  }

  void initState() {
    // TODO: implement initState
    reference = FirebaseDatabase.instance
        .reference()
        .child("Companies")
        .child(User.database);
    getCustomerId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     // appBar: buildAppBar(context),
      body: salesOrder()
    );
  }

  salesOrder() {
    return Column(
      children: [
        Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color(0xff454d60),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Balance',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 12,
                    color: const Color(0xffffffff),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                width: 25,
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height *0.8,
          child:ListView.builder(
            shrinkWrap: true,
            itemCount: names.length,
            itemBuilder: (context, index) {
              return Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: index.floor().isEven
                      ? Color(0x66d6d6d6)
                      : Color(0x66f3ceef),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        names[index],
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        balance[index].toString(),
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                  ],
                ),
              );
            },
          )
        ),
      ],
    );
  }

}
