import 'package:coletiv_infinite_parking/page/auth.dart';
import 'package:coletiv_infinite_parking/page/sessions.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Infinite Parking',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        '/Auth': (BuildContext context) => new AuthPage(),
        '/Sessions': (BuildContext context) => new SessionsPage()
      },
      home: new AuthPage(),
    );
  }
}
