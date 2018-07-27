import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/auth_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sessionManager = SessionManager._internal();

class SessionManager {
  SessionManager._internal();

  final _authTokenKey = "AuthToken";

  Future<bool> saveAuthToken(AuthToken authToken) async {
    final prefs = await SharedPreferences.getInstance();
    final authTokenJson = json.encode(authToken);
    return await prefs.setString(_authTokenKey, authTokenJson);
  }

  Future<AuthToken> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final authTokenJson = await prefs.get(_authTokenKey);
    return AuthToken.fromJson(authTokenJson);
  }

  Future<bool> deleteAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_authTokenKey, null);
  }
}
