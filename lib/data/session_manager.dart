import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/auth_token.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sessionManager = _SessionManager._internal();

class _SessionManager {
  _SessionManager._internal();

  final String _authTokenKey = 'AuthToken';
  final String _emailKey = "Email";
  final String _passwordKey = "Password";
  final String _providerKey = "Provider";
  final String _selectedVehicleKey = "SelectedVehicle";
  final String _selectedZoneTokenKey = "SelectedZoneToken";
  final String _selectedTimeKey = "SelectedTimeToken";
  final String _parkingSessionKey = "ParkingSession";

  Future<SharedPreferences> _getPrefs() async =>
      await SharedPreferences.getInstance();

  // User Session

  Future<bool> _saveAuthToken(AuthToken authToken) async {
    final String authTokenJson = json.encode(authToken);
    return await _getPrefs()
        .then((prefs) => prefs.setString(_authTokenKey, authTokenJson));
  }

  Future<bool> _saveEmail(String email) async {
    return await _getPrefs().then((prefs) => prefs.setString(_emailKey, email));
  }

  Future<bool> _savePassword(String password) async {
    return await _getPrefs()
        .then((prefs) => prefs.setString(_passwordKey, password));
  }

  Future<bool> saveProvider(int provider) async {
    return await _getPrefs()
        .then((prefs) => prefs.setInt(_providerKey, provider));
  }

  Future<bool> saveSession(
      AuthToken authToken, String email, String password) async {
    return Future.wait([
      _saveAuthToken(authToken),
      _saveEmail(email),
      _savePassword(password),
    ]).then((_) => true).catchError((_) => false);
  }

  Future<AuthToken> getAuthToken() async {
    final String authTokenJson =
        await _getPrefs().then((prefs) => prefs.get(_authTokenKey));

    if (authTokenJson == null) {
      return null;
    } else {
      return AuthToken.fromJson(json.decode(authTokenJson));
    }
  }

  Future<String> getEmail() async =>
      await _getPrefs().then((prefs) => prefs.get(_emailKey));

  Future<String> getPassword() async =>
      await _getPrefs().then((prefs) => prefs.get(_passwordKey));

  Future<int> getProvider() async =>
      await _getPrefs().then((prefs) => prefs.get(_providerKey));

  Future<bool> deleteSession() async =>
      await _getPrefs().then((prefs) => prefs.clear());

  Future<bool> isLoggedIn() async {
    final AuthToken authToken = await getAuthToken();
    return authToken != null ? true : false;
  }

  // Parking Session

  Future<bool> _saveSelectedVehicle(Vehicle vehicle) async {
    final String vehicleJson = json.encode(vehicle);
    return await _getPrefs()
        .then((prefs) => prefs.setString(_selectedVehicleKey, vehicleJson));
  }

  Future<bool> _saveSelectedZoneToken(MunicipalZone zone) async {
    return await _getPrefs()
        .then((prefs) => prefs.setString(_selectedZoneTokenKey, zone.token));
  }

  Future<bool> _saveSelectedTime(DateTime time) async {
    return await _getPrefs().then(
        (prefs) => prefs.setString(_selectedTimeKey, time.toIso8601String()));
  }

  Future<bool> saveSelectedParkingSession(
      Vehicle vehicle, MunicipalZone zone, DateTime time) async {
    return Future.wait([
      _saveSelectedVehicle(vehicle),
      _saveSelectedZoneToken(zone),
      _saveSelectedTime(time),
    ]).then((_) => true).catchError(() => false);
  }

  Future<bool> saveParkingSession(Session session) async {
    final String sessionJson = json.encode(session);
    return await _getPrefs()
        .then((prefs) => prefs.setString(_parkingSessionKey, sessionJson));
  }

  Future<bool> deleteParkingSession() async {
    return await _getPrefs().then((prefs) {
      Future.wait([
        prefs.setString(_selectedVehicleKey, null),
        prefs.setString(_selectedZoneTokenKey, null),
        prefs.setString(_selectedTimeKey, null),
        prefs.setString(_parkingSessionKey, null)
      ]).then((_) => true).catchError(() => false);
    });
  }

  Future<Vehicle> getSelectedVehicle() async {
    final String vehicleJson =
        await _getPrefs().then((prefs) => prefs.get(_selectedVehicleKey));

    if (vehicleJson == null) {
      return null;
    } else {
      return Vehicle.fromJson(json.decode(vehicleJson));
    }
  }

  Future<String> getSelectedZoneToken() async =>
      await _getPrefs().then((prefs) => prefs.get(_selectedZoneTokenKey));

  Future<DateTime> getSelectedTime() async {
    String selectedTimeString =
        await _getPrefs().then((prefs) => prefs.get(_selectedTimeKey));
    return DateTime.tryParse(selectedTimeString);
  }

  Future<Session> getParkingSession() async {
    final String sessionJson =
        await _getPrefs().then((prefs) => prefs.get(_parkingSessionKey));

    if (sessionJson == null) {
      return null;
    } else {
      return Session.fromJson(json.decode(sessionJson));
    }
  }
}
