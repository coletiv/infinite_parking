import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/auth_token.dart';
import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sessionManager = _SessionManager._internal();

class _SessionManager {
  _SessionManager._internal();

  final String _authTokenKey = 'AuthToken';
  final String _emailKey = "Email";
  final String _passwordKey = "Password";
  final String _selectedVehicleKey = "SelectedVehicle";
  final String _selectedZoneTokenKey = "SelectedZoneToken";
  final String _selectedFareTokenKey = "SelectedFareToken";
  final String _selectedFaresKeys = "SelectedFares";

  Future<SharedPreferences> _getPrefs() async =>
      await SharedPreferences.getInstance();

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

  Future<bool> saveSession(
      AuthToken authToken, String email, String password) async {
    return Future.wait([
      _saveAuthToken(authToken),
      _saveEmail(email),
      _savePassword(password),
    ]).then((_) => true).catchError(() => false);
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

  Future<bool> deleteSession() async =>
      await _getPrefs().then((prefs) => prefs.clear());

  Future<bool> isLoggedIn() async {
    final AuthToken authToken = await getAuthToken();
    return authToken != null ? true : false;
  }

  Future<bool> _saveSelectedVehicle(Vehicle vehicle) async {
    final String vehicleJson = json.encode(vehicle);
    return await _getPrefs()
        .then((prefs) => prefs.setString(_selectedVehicleKey, vehicleJson));
  }

  Future<bool> _saveSelectedZoneToken(MunicipalZone zone) async {
    return await _getPrefs()
        .then((prefs) => prefs.setString(_selectedFareTokenKey, zone.token));
  }

  Future<bool> _saveSelectedFareToken(Fare fare) async {
    return await _getPrefs().then(
        (prefs) => prefs.setString(_selectedFareTokenKey, fare.promiseToken));
  }

  Future<bool> _saveSelectedFares(List<FareCost> selectedFares) async {
    final String selectedFaresJson = json.encode(selectedFares);
    return await _getPrefs().then(
        (prefs) => prefs.setString(_selectedFaresKeys, selectedFaresJson));
  }

  Future<bool> saveParkingSession(
      Vehicle vehicle, MunicipalZone zone, Fare fare) async {
    return Future.wait([
      _saveSelectedVehicle(vehicle),
      _saveSelectedZoneToken(zone),
      _saveSelectedFareToken(fare),
      _saveSelectedFares(fare.getSelectedFares()),
    ]).then((_) => true).catchError(() => false);
  }

  Future<bool> updateSelectedFares() async {
    List<FareCost> selectedFares = await getSelectedFares();

    if (selectedFares == null) {
      return false;
    }

    if (selectedFares.length > 0) {
      selectedFares.removeAt(0);
    } else {
      return await _getPrefs()
          .then((prefs) => prefs.setString(_selectedFaresKeys, null));
    }

    return await _saveSelectedFares(selectedFares);
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

  Future<String> getSelectedFareToken() async =>
      await _getPrefs().then((prefs) => prefs.get(_selectedFareTokenKey));

  Future<List<FareCost>> getSelectedFares() async {
    final String selectedFaresJson =
        await _getPrefs().then((prefs) => prefs.get(_selectedFaresKeys));

    if (selectedFaresJson == null) {
      return null;
    } else {
      return json.decode(selectedFaresJson);
    }
  }
}
