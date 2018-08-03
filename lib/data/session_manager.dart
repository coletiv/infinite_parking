import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/auth_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sessionManager = _SessionManager._internal();

class _SessionManager {
  _SessionManager._internal();

  final String _authTokenKey = 'AuthToken';

  Future<bool> saveAuthToken(AuthToken authToken) async {
    final prefs = await SharedPreferences.getInstance();
    final String authTokenJson = json.encode(authToken);
    return await prefs.setString(_authTokenKey, authTokenJson);
  }

  Future<AuthToken> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String authTokenJson = await prefs.get(_authTokenKey);
    return AuthToken.fromJson(json.decode(authTokenJson));
  }

  Future<bool> deleteAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_authTokenKey, null);
  }

  Future<bool> isLoggedIn() async {
    final authToken = await getAuthToken();
    return authToken != null ? true : false;
  }
}
