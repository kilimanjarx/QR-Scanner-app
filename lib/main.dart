import 'package:flutter/material.dart';
import 'package:qr_v1/pages/HomePage.dart';

void main() => runApp(MyApp());
Widget getErrorWidget(FlutterErrorDetails error) {
  return Center(
    child: Text("Error appeared."),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        ErrorWidget.builder = getErrorWidget;
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'qr scan',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: MyHomePage(),
    );
  }
}
