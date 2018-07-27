import 'package:flutter/material.dart';

class SessionsPage extends StatefulWidget {
  @override
  State createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessions'),
      ),
      body: Text("My Sessions"),
    );
  }
}
