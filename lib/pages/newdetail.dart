import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_v1/model/CustomerModel.dart';
import 'package:qr_v1/model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DetailPage.dart';
import 'HomePage.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'LoginPage.dart';
import 'package:intl/intl.dart';

class NextDetail extends StatefulWidget {
  final String code;
  NextDetail(this.code);

  @override
  _NextDetailState createState() => _NextDetailState();
}

class _NextDetailState extends State<NextDetail> {
//initialising variables
  Customer customer;
  User user;
  bool _isLoading = false;
  var status;
  var trim;
  bool _isButtonDisabled;
  bool _isButtonminusDisabled;
  int _counter = 0;
  int intialPax;
  var notes;
  SharedPreferences sharedPreferences;
  var txt = TextEditingController();
  int finalValue;
  var validInput;

  Future scanbarcode() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#009922", "Cancel", false, ScanMode.QR)
        .then((String code) {
      if (code != '-1') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Detail(code)));
      } else {
        return;
      }
    });
  }

  submitNotes() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var prf = sharedPreferences.getString("token");

    try {
      await http.post(
          "",
          body: {'notes': txt.text.toString()}).then((response) {
        var decodedJson = jsonDecode(response.body);
        if (decodedJson['meta']['statusCode'].toString() == '401' ||
            decodedJson['meta']['statusCode'].toString() == '404') {
          Future.delayed(const Duration(seconds: 1));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
          Fluttertoast.showToast(
              msg: "Token expired! Please Login again",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 3,
              backgroundColor: Colors.red.shade700,
              textColor: Colors.white,
              fontSize: 20.0);
        } else {
          Fluttertoast.showToast(
              msg: "Remarks added",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 3,
              backgroundColor: Colors.orange.shade700,
              textColor: Colors.white,
              fontSize: 20.0);
          getUser();
          txt.clear();
        }
      });
    } on Exception catch (e) {
      print(e);
      sharedPreferences.clear();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }

//widget.code is the value of the qr code
//update Pax after confirm pax-- Tag:function
  updatePax() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var prf = sharedPreferences.getString("token");
    int value = _counter;
    int updatedCounter = value + status['response']['numberOfSeats'];

    try {
      await http.post(
          "" ,
          body: {'seats': updatedCounter.toString()}).then((response) {
        print(widget.code);
        print(prf);
        var decodedJson = jsonDecode(response.body);
        if (decodedJson['meta']['statusCode'].toString() == '401' ||
            decodedJson['meta']['statusCode'].toString() == '404') {
          Future.delayed(const Duration(seconds: 1));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
          Fluttertoast.showToast(
              msg: "Token expired! Please Login again",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 3,
              backgroundColor: Colors.red.shade700,
              textColor: Colors.white,
              fontSize: 20.0);
        }
      });
      setState(() {
        _counter = 0;
      });
      getUser(); //get user again to check on updated informartion
    } on Exception catch (e) {
      print(e);
      sharedPreferences.clear();
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }

//get customer from API-- Tag:function
  getUser() async {
    // initialise
    sharedPreferences = await SharedPreferences.getInstance();

    // get the token
    var prf = sharedPreferences.getString("token");

    try {
      await http
          .get(
              "insert your endpoint here" 
                ,
              )
          .then((response) {
        var decodedJson = jsonDecode(response.body);

        if (decodedJson['meta']['statusCode'].toString() == '401' ||
            decodedJson['meta']['statusCode'].toString() == '404') {
          sharedPreferences.clear(); // clear token

          // navigate to login page
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => false);

          // show toast
          Fluttertoast.showToast(
              msg: "Token expired! Please Login again",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 3,
              backgroundColor: Colors.red.shade700,
              textColor: Colors.white,
              fontSize: 20.0);
        }

        if (jsonDecode(response.body) != null) {
          setState(() {
            _isLoading = false;
            status = decodedJson;
            int seats = status['response']['numberOfSeats'];
            if (status['response']['notes'] != null) {
              String t = status['response']['notes'];
              var a = t.replaceAll(RegExp('<br>'), '\n');
              notes = a;
            }
            finalValue = seats;
            validInput = status['response']['totalPax'] -
                status['response']['numberOfSeats'];
          });
        }
        print(validInput);
      });
    } on Exception catch (e) {
      // clear token
      sharedPreferences.clear();
      // push to home page
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
          (Route<dynamic> route) => false);
      print(e);
    }
  }

//pax decrement counter-- Tag:function
  void _decrementCounter() {
    if (_counter <= 0) {
      setState(() {
        _isButtonminusDisabled = false;
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonminusDisabled = false;

        _counter--;
      });
    }
  }

//pax increment counter--Tag:function
  void _incrementCounter() {
    if (_counter == status['response']['totalPax']) {
      setState(() {
        _isButtonDisabled = false;
        _isButtonminusDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = false;
        _isButtonminusDisabled = false;

        _counter++;
      });
    }
  }

//init getuser everytime--Tag:initial function
  @override
  void initState() {
    _isButtonDisabled = false;
    _isButtonminusDisabled = false;
    getUser();
    print(widget.code);
    super.initState();
  }

//the UI body
//understand the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => MyHomePage()),
                  (Route<dynamic> route) => false);
            },
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                sharedPreferences.clear();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
              child: Text("Log Out", style: TextStyle(color: Colors.white)),
            ),
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Confirmation"),
        ),
        body: GestureDetector(
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Center(
              child: status == null
                  ? CircularProgressIndicator()
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(status['response']['description'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              elevation: 5.0,
                              // margin: EdgeInsets.all(),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 5, 5),
                                              child: Text("Name:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 5, 5),
                                              child: Text(
                                                  status['response']
                                                      ['registeredCustomer'],
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                  )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 5, 5),
                                              child: Text("Total\npaid:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 5, 5),
                                              child: Text(
                                                  "RM" +
                                                      " " +
                                                      status['response']
                                                          ['amount'],
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                  )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 5, 5),
                                              child: Text(
                                                  "Number of\nseats taken:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 5, 5),
                                              child: Text(
                                                  finalValue.toString() +
                                                      " / " +
                                                      status['response']
                                                              ['totalPax']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 25.0,
                                                      color: Colors.red)),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 5, 5),
                                              child: Text("Total pax:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 5, 5),
                                              child: Text(
                                                  status['response']['totalPax']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 25.0,
                                                  )),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 20, 5, 5),
                                              child: Text("Notes:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                  )),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 20, 8, 5),
                                                child: Text(notes,
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 40, 5, 5),
                                      child: Center(
                                        child: Text(
                                            "Pax number is  : $_counter",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: IconButton(
                                              iconSize: 80,
                                              color: Colors.red,
                                              icon:
                                                  new Icon(Icons.remove_circle),
                                              onPressed: _isButtonminusDisabled
                                                  ? null
                                                  : _decrementCounter,
                                            ),
                                          ),
                                          Center(
                                            child: IconButton(
                                              iconSize: 80,
                                              color: Colors.green,
                                              icon: new Icon(Icons.add_circle),
                                              onPressed: _isButtonDisabled
                                                  ? null
                                                  : _incrementCounter,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 8.0),
                                          child: FlatButton(
                                              color: Colors.orange,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 18, 0, 18),
                                                child: Text(
                                                  "Scan Again",
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          8.0)),
                                              onPressed: () {
                                                if (status['meta']['statusCode']
                                                        .toString() ==
                                                    '401') {
                                                  sharedPreferences.clear();
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  LoginPage()),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                } else {
                                                  scanbarcode();
                                                }
                                              }),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 8),
                                          child: FlatButton(
                                              color: Colors.green,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 18, 0, 20),
                                                child: Text(
                                                  "Confirm Attendance",
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          8.0)),
                                              onPressed: () {
                                                if (status['response']
                                                                ['totalPax']
                                                            .toString() !=
                                                        status['response'][
                                                                'numberOfSeats']
                                                            .toString() &&
                                                    _counter <= validInput &&
                                                    _counter != 0) {
                                                  updatePax();
                                                  getUser();

                                                  setState(() {});

                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "${status['response']['registeredCustomer']} have succesfully attend",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.TOP,
                                                      timeInSecForIos: 1,
                                                      backgroundColor:
                                                          Colors.green.shade700,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                } else if (_counter >
                                                    validInput) {
                                                  Fluttertoast.showToast(
                                                      msg: "Invalid input!",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIos: 1,
                                                      backgroundColor:
                                                          Colors.red.shade700,
                                                      textColor: Colors.white,
                                                      fontSize: 20.0);
                                                  return null;
                                                } else if (status['response']
                                                            ['totalPax']
                                                        .toString() ==
                                                    status['response']
                                                            ['numberOfSeats']
                                                        .toString()) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Number of seats have reached the limit!",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIos: 1,
                                                      backgroundColor:
                                                          Colors.red.shade700,
                                                      textColor: Colors.white,
                                                      fontSize: 20.0);
                                                  return null;
                                                } else if (_counter == 0) {
                                                  Fluttertoast.showToast(
                                                      msg: "Invalid input!",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIos: 1,
                                                      backgroundColor:
                                                          Colors.red.shade700,
                                                      textColor: Colors.white,
                                                      fontSize: 20.0);
                                                  return null;
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Container(
                                        //   height: 200.0,
                                        decoration: new BoxDecoration(
                                            border: new Border.all(
                                                color: Colors.black)),

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: new TextField(
                                              controller: txt,
                                              maxLines: 10,
                                              style: new TextStyle(
                                                  fontSize: 16.0,
                                                  // height: 2.0,
                                                  color: Colors.black),
                                              decoration: const InputDecoration(
                                                hintText:
                                                    "Insert your notes/remarks here",
                                                // contentPadding:
                                                //     const EdgeInsets.symmetric(
                                                //         vertical: 40.0),
                                              )),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 8),
                                        child: FlatButton(
                                            color: Colors.orange,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 18, 0, 20),
                                              child: Text(
                                                "Submit notes",
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        8.0)),
                                            onPressed: () {
                                              submitNotes();
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 50,
                                            width: 83,
                                            child: Text("Invoice Number:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0,
                                                )),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 20, 5, 5),
                                          child: Container(
                                            height: 20,
                                            width: 80,
                                            child: Text(
                                                status['response']['invoiceNo'],
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 20, 5, 5),
                                          child: Text("Email:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 20, 5, 5),
                                          child:
                                              Text(status['response']['email'],
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  )),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 20, 5, 5),
                                          child: Text("Created at:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              )),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 20, 5, 5),
                                            child: Text(
                                                status['response']['createdAt']
                                                        ['date']
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 20, 5, 5),
                                          child: Text("Tag:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 20, 5, 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: new BorderRadius
                                                        .only(
                                                    topLeft:
                                                        const Radius.circular(
                                                            10.0),
                                                    bottomLeft:
                                                        const Radius.circular(
                                                            10.0),
                                                    bottomRight:
                                                        const Radius.circular(
                                                            10.0),
                                                    topRight:
                                                        const Radius.circular(
                                                            10.0))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  status['response']['tags']
                                                      ['vimigo'],
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ));
  }
}
