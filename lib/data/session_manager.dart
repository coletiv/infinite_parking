import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sessionManager = SessionManager._internal();

class SessionManager {
  SessionManager._internal();

  final _sessionKey = "UserSession";

  Future<bool> saveSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = json.encode(session);
    return await prefs.setString(_sessionKey, sessionJson);
  }

  Future<Session> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = await prefs.get(_sessionKey);
    return Session.fromJson(sessionJson);
  }

  Future<bool> deleteSession() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_sessionKey, null);
  }
}
