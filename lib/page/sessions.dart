import 'package:coletiv_infinite_parking/network/client/session_client.dart';
import 'package:flutter/material.dart';

class SessionsPage extends StatefulWidget {
  @override
  State createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  BuildContext buildContext;

  bool isLoading = false;

  void getSessions() async {
    updateLoadingState(true);

    final response = await sessionClient.getSessions();

    updateLoadingState(false);
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
        title: Text('Sessions'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          buildContext = context;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Opacity(
                    opacity: isLoading ? 1.0 : 0.0,
                    child: CircularProgressIndicator(),
                  ),
                  Opacity(
                    opacity: isLoading ? 0.0 : 1.0,
                    child: RaisedButton(
                      onPressed: getSessions,
                      child: Text('GET SESSIONS'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
