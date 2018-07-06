import 'package:flutter/material.dart';

import 'page/auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Infinite Parking',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new AuthPage(),
    );
  }
}
