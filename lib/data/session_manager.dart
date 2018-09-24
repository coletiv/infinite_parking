import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/auth_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sessionManager = _SessionManager._internal();

class _SessionManager {
  _SessionManager._internal();

  final String _authTokenKey = 'AuthToken';
  final String _emailKey = "Email";
  final String _passwordKey = "Password";

  Future<bool> _saveAuthToken(AuthToken authToken) async {
    final prefs = await SharedPreferences.getInstance();
    final String authTokenJson = json.encode(authToken);
    return await prefs.setString(_authTokenKey, authTokenJson);
  }

  Future<bool> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_emailKey, email);
  }

  Future<bool> _savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_passwordKey, password);
  }

  Future<bool> saveSession(
      AuthToken authToken, String email, String password) async {
    return await _saveAuthToken(authToken) &&
        await _saveEmail(email) &&
        await _savePassword(password);
  }

  Future<AuthToken> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String authTokenJson = await prefs.get(_authTokenKey);

    if (authTokenJson == null) {
      return null;
    } else {
      return AuthToken.fromJson(json.decode(authTokenJson));
    }
  }

  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.get(_emailKey);
  }

  Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.get(_passwordKey);
  }

  Future<bool> deleteSession() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    final authToken = await getAuthToken();
    return authToken != null ? true : false;
  }
}
