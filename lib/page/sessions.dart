import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/network/client/session_client.dart';
import 'package:flutter/material.dart';

class SessionsPage extends StatefulWidget {
  @override
  SessionsPageState createState() => SessionsPageState();
}

class SessionsPageState extends State<SessionsPage> {
  @override
  void initState() {
    super.initState();

    _getSessions();
  }

  BuildContext _context;

  bool _isLoading = false;
  final List<Session> _sessions = List<Session>();

  void _getSessions() async {
    _updateLoadingState(true);

    List<Session> sessions = await sessionClient.getSessions();

    setState(() {
      _sessions.clear();
      _sessions.addAll(sessions);
    });

    _updateLoadingState(false);
  }

  void _addSession() {
    Navigator.of(context).pushNamed('/AddSession');
  }

  void _updateLoadingState(bool isLoading) {
    setState(() {
      this._isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessions'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _getSessions,
          )
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          _context = context;
          return Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Opacity(
                opacity: _isLoading ? 1.0 : 0.0,
                child: CircularProgressIndicator(),
              ),
              Opacity(
                opacity: _isLoading ? 0.0 : 1.0,
                child: ListView.builder(
                  itemCount: _sessions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _sessions[index].getPlate(),
                      ),
                      subtitle: Text(
                        _sessions[index].getFormattedFinalDate(),
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
        onPressed: _addSession,
      ),
    );
  }
}
