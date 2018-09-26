import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/auth_token.dart';
import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sessionManager = _SessionManager._internal();

class _SessionManager {
  _SessionManager._internal();

  final String _authTokenKey = 'AuthToken';
  final String _emailKey = "Email";
  final String _passwordKey = "Password";
  final String _fareTokenKey = "FareToken";
  final String _selectedFaresKeys = "SelectedFares";

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

  Future<bool> _saveFareToken(Fare fare) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_fareTokenKey, fare.promiseToken);
  }

  Future<bool> _saveSelectedFares(List<FareCost> selectedFares) async {
    final prefs = await SharedPreferences.getInstance();
    final String selectedFaresJson = json.encode(selectedFares);
    return await prefs.setString(_selectedFaresKeys, selectedFaresJson);
  }

  Future<bool> saveParkingSession(Fare fare) async {
    return await _saveFareToken(fare) &&
        await _saveSelectedFares(fare.getSelectedFares());
  }

  Future<bool> updateSelectedFares() async {
    List<FareCost> selectedFares = await getSelectedFares();

    if (selectedFares == null) {
      return false;
    }

    if (selectedFares.length > 0) {
      selectedFares.removeAt(0);
    } else {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_selectedFaresKeys, null);
    }

    return await _saveSelectedFares(selectedFares);
  }

  Future<String> getFareToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.get(_fareTokenKey);
  }

  Future<List<FareCost>> getSelectedFares() async {
    final prefs = await SharedPreferences.getInstance();
    final String selectedFaresJson = await prefs.get(_selectedFaresKeys);

    if (selectedFaresJson == null) {
      return null;
    } else {
      return json.decode(selectedFaresJson);
    }
  }
}
