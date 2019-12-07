import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_v1/pages/DetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences sharedPreferences;
  var code = "";

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  Future scanbarcode() async {
    try {
      await FlutterBarcodeScanner.scanBarcode(
              "#009922", "Cancel", true, ScanMode.DEFAULT)
          .then((String code) {
        if (code != '-1') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Detail(code)));
        } else {
          return;
        }
      });
    } catch (e) {
      sharedPreferences.clear();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);

      Fluttertoast.showToast(
          msg: "Token expired! Please Login again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 3,
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
          fontSize: 20.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           Padding(
             padding: const EdgeInsets.only(bottom:50.0,top: 20 ),
             child: Image.asset('assets/illus.png'),
           ),
            Padding(
              padding: const EdgeInsets.only(top:50.0),
              child: Center(
                child: Transform.scale(
                  scale: 6,
                  child: IconButton(
                    onPressed: () {
                      scanbarcode();
                    },
                    icon: new Icon(Icons.camera_alt),
                    color: Colors.purpleAccent.shade100,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text("Scan here"),
            ),
           
          ]),
    );
  }
}
