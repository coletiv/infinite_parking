import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/network/client/session_client.dart';
import 'package:flutter/material.dart';

class SessionsPage extends StatefulWidget {
  @override
  State createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  BuildContext buildContext;

  bool isLoading = false;

  List<Session> sessions = List<Session>();

  void getSessions() async {
    updateLoadingState(true);

    List<Session> userSessions = await sessionClient.getSessions();

    showSessions(userSessions);
  }

  void addSession() {
    Navigator.of(context).pushNamed('/AddSession');
  }

  void updateLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  void showSessions(List<Session> sessions) {
    setState(() {
      this.isLoading = false;
      this.sessions = sessions;
    });
  }

  @override
  void initState() {
    super.initState();
    getSessions();
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
          return Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Opacity(
                opacity: isLoading ? 1.0 : 0.0,
                child: CircularProgressIndicator(),
              ),
              Opacity(
                opacity: isLoading ? 0.0 : 1.0,
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        sessions[index].getPlate(),
                      ),
                      subtitle: Text(
                        sessions[index].getFormattedFinalDate(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addSession,
      ),
    );
  }
}
