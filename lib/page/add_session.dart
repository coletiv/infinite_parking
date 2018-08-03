import 'package:flutter/material.dart';

class AddSessionPage extends StatefulWidget {
  @override
  State createState() => _AddSessionPageState();
}

class _AddSessionPageState extends State<AddSessionPage> {
  BuildContext buildContext;

  bool isLoading = false;

  void addSession() {
    // TODO add session
  }

  void updateLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Session'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          buildContext = context;
          return Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Opacity(
                opacity: isLoading ? 1.0 : 0.0,
                child: CircularProgressIndicator(),
              ),
            ],
          );
        },
      ),
    );
  }
}
