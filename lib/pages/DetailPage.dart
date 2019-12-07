import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_v1/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'newdetail.dart';

class Detail extends StatefulWidget {
  final String code;
  Detail(this.code);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  User user;
  bool _isLoading = false;
  bool statuss;
  SharedPreferences sharedPreferences;

  checkPayment() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var prf = sharedPreferences.getString("token");
    try {
      await http
          .get(
              "insert your endpoint here",
              )
          .then((response) {
        print(widget.code);
        print(prf);
        var decodedJson = jsonDecode(response.body);
        if (decodedJson['meta']['statusCode'].toString() != '401') {
          Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NextDetail(widget.code)));
        } else {
          sharedPreferences.clear();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage()));
          Fluttertoast.showToast(
              msg: "Please Login again",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 4,
              backgroundColor: Colors.red.shade700,
              textColor: Colors.white,
              fontSize: 20.0);
        }

        if (response.statusCode == 200) {
          if (jsonDecode(response.body) != null) {
            setState(() {
              _isLoading = false;
              statuss = decodedJson['response']['verified'];
            });
          }
        } else {
          throw Exception('Request Error: ${response.body}');
        }
      });
    } on Exception catch (e) {
      print(e);
      sharedPreferences.clear();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }

  @override
  void initState() {
    checkPayment();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment verification"),
      ),
      body: statuss.toString() != 'true'
          ? SingleChildScrollView(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 130),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        elevation: 12.0,
                        margin: EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 50, 5, 5),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Customer have not paid for the event. Please assist",
                                      style: TextStyle(fontSize: 20.0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                child: Center(
                                  child: FlatButton(
                                    color: Colors.cyan.shade100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Back",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                          child: Container(
                              width: 300,
                              child: Image.asset(
                                'assets/Logo_Vimigo.png',
                                fit: BoxFit.cover,
                              )),
                        )),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 130),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        elevation: 12.0,
                        margin: EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 50, 5, 5),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Customer(s) have paid for the event. ",
                                      style: TextStyle(fontSize: 20.0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                child: Center(
                                  child: FlatButton(
                                    color: Colors.cyan.shade100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Proceed to confirmation",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black),
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NextDetail(widget.code)));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                          child: Container(
                              width: 300,
                              child: Image.asset(
                                'assets/Logo_Vimigo.png',
                                fit: BoxFit.cover,
                              )),
                        )),
                  ],
                ),
              ),
            ),
    );
  }
}
