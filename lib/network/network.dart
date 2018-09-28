import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/auth_token.dart';
import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';
import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:http/http.dart' as http;

final network = _Network._internal();

DateTime retryDate;

class _Network {
  _Network._internal();

  final _baseUrl = 'https://eos.empark.com/api/v1.0';

  Future<Map<String, String>> _getHeaders() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'User-Agent':
          'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36',
      'X-EOS-CLIENT-TOKEN': '2463bc87-6e92-480e-a56b-4260ff8b6a38'
    };

    final authToken = await sessionManager.getAuthToken();

    if (authToken != null) {
      headers["X-EOS-USER-TOKEN"] = authToken.userSessionToken;
    }

    return headers;
  }

  // AUTHENTICATION

  Future<bool> login(String email, String password) async {
    final loginUrl = '$_baseUrl/auth/accounts';
    final body = json.encode({'username': email, 'password': password});

    final response = await http.post(
      loginUrl,
      headers: await _getHeaders(),
      body: body,
    );

    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      AuthToken authToken = AuthToken.fromJson(json.decode(responseBody));
      return await sessionManager.saveSession(authToken, email, password);
    } else {
      throw Exception("Authentication failed");
    }
  }

  Future<bool> refreshToken() async {
    final loginUrl = '$_baseUrl/auth/accounts';
    final email = await sessionManager.getEmail();
    final password = await sessionManager.getPassword();

    await sessionManager.deleteSession();

    if (email == null || password == null) {
      return false;
    }

    final body = json.encode({'username': email, 'password': password});

    final response = await http.post(
      loginUrl,
      headers: await _getHeaders(),
      body: body,
    );

    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      AuthToken authToken = AuthToken.fromJson(json.decode(responseBody));
      return await sessionManager.saveSession(authToken, email, password);
    } else {
      return false;
    }
  }

  Future<bool> _canRetry(String responseBody) async {
    // Checks if a retry was performed in the last 5 minutes
    if (retryDate != null &&
        DateTime.now().difference(retryDate).inMinutes < 5) {
      return false;
    }

    // Checks if the request failed because of a invalid token
    if (!responseBody.contains("authenticationFailed") ||
        !responseBody.contains("invalid token")) {
      return false;
    }

    retryDate = DateTime.now();

    // Refreshes the user token
    final isLoggedIn = await refreshToken();

    // If the user token was refreshed successfully we can perform a retry
    if (isLoggedIn) {
      return true;
    } else {
      return false;
    }
  }

  // PARKING SESSION

  Future<List<Session>> getSessions() async {
    final authToken = await sessionManager.getAuthToken();
    final accountToken = authToken.accountToken;
    final sessionsUrl =
        '$_baseUrl/parking/sessions?account=$accountToken&session_state=ACTIVE';

    final response = await http.get(
      sessionsUrl,
      headers: await _getHeaders(),
    );

    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      Iterable responseJson = json.decode(responseBody);
      return responseJson.map((object) => Session.fromJson(object)).toList();
    } else if (await _canRetry(responseBody)) {
      return await getSessions();
    } else {
      throw Exception("Couldn't get sessions");
    }
  }

  Future<Session> addSession(
      Vehicle vehicle, MunicipalZone zone, Fare fare) async {
    final AuthToken authToken = await sessionManager.getAuthToken();
    final String accountToken = authToken.accountToken;

    final DateTime selectedTime = await sessionManager.getSelectedTime();
    final List<FareCost> selectedFares = fare.getSelectedFares(selectedTime);

    if (selectedTime == null ||
        DateTime.now().isAfter(selectedTime) ||
        selectedFares.isEmpty) {
      return null;
    }

    final FareCost fareCost = selectedFares.first;

    final body = json.encode({
      'account_token': accountToken,
      'cost_time_pair': {
        'cost': fareCost.cost,
        'charged_duration_ms': fareCost.chargedDuration,
      },
      'plate': {
        'id': vehicle.number,
        'type': vehicle.country,
      },
      'position_token': zone.token,
      'promise_token': fare.promiseToken,
      'type': 'MANAGED'
    });

    final addSessionUrl = '$_baseUrl/parking/sessions/';

    final response = await http.post(
      addSessionUrl,
      headers: await _getHeaders(),
      body: body,
    );

    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return Session.fromJson(json.decode(responseBody));
    } else if (await _canRetry(responseBody)) {
      return await addSession(vehicle, zone, fare);
    } else {
      throw Exception("Couldn't create session");
    }
  }

  Future<Session> refreshSession(Fare fare) async {
    final AuthToken authToken = await sessionManager.getAuthToken();
    final String accountToken = authToken.accountToken;

    final Vehicle vehicle = await sessionManager.getSelectedVehicle();
    final String zoneToken = await sessionManager.getSelectedZoneToken();
    final DateTime selectedTime = await sessionManager.getSelectedTime();
    final List<FareCost> selectedFares = fare.getSelectedFares(selectedTime);

    if (vehicle == null ||
        zoneToken == null ||
        selectedTime == null ||
        DateTime.now().isAfter(selectedTime) ||
        selectedFares.isEmpty) {
      return null;
    }

    final FareCost fareCost = selectedFares.first;

    final body = json.encode({
      'account_token': accountToken,
      'cost_time_pair': {
        'cost': fareCost.cost,
        'charged_duration_ms': fareCost.chargedDuration,
      },
      'plate': {
        'id': vehicle.number,
        'type': vehicle.country,
      },
      'position_token': zoneToken,
      'promise_token': fare.promiseToken,
      'type': 'MANAGED'
    });

    final addSessionUrl = '$_baseUrl/parking/sessions/';

    final response = await http.post(
      addSessionUrl,
      headers: await _getHeaders(),
      body: body,
    );

    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return Session.fromJson(json.decode(responseBody));
    } else if (await _canRetry(responseBody)) {
      return await refreshSession(fare);
    } else {
      throw Exception("Couldn't create session");
    }
  }

  // VEHICLE

  Future<List<Vehicle>> getVehicles() async {
    final authToken = await sessionManager.getAuthToken();
    final accountToken = authToken.accountToken;
    final vehiclesUrl = '$_baseUrl/accounts/$accountToken/vehicles/';

    final response = await http.get(
      vehiclesUrl,
      headers: await _getHeaders(),
    );

    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      Iterable responseJson = json.decode(responseBody);
      return responseJson.map((object) => Vehicle.fromJson(object)).toList();
    } else if (await _canRetry(responseBody)) {
      return await getVehicles();
    } else {
      throw Exception("Couldn't get vehicles");
    }
  }

  // MUNICIPALS

  Future<List<Municipal>> getMunicipals() async {
    final municipalUrl = '$_baseUrl/centers/services?type=MUNICIPAL_CONTEXT';

    final response = await http.get(
      municipalUrl,
      headers: await _getHeaders(),
    );

    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      Iterable responseJson = json.decode(responseBody)['result'];
      return responseJson.map((object) => Municipal.fromJson(object)).toList();
    } else if (await _canRetry(responseBody)) {
      return await getMunicipals();
    } else {
      throw Exception("Couldn't get municipals");
    }
  }

  Future<List<MunicipalZone>> getMunicipalZones(String municipalToken) async {
    final zoneUrl =
        '$_baseUrl/geo/search?context_token=$municipalToken&polygon_info=true';

    final response = await http.get(
      zoneUrl,
      headers: await _getHeaders(),
    );

    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      Iterable responseJson = json.decode(responseBody)['result'];
      return responseJson
          .map((object) => MunicipalZone.fromJson(object))
          .toList();
    } else if (await _canRetry(responseBody)) {
      return await getMunicipalZones(municipalToken);
    } else {
      throw Exception("Couldn't get zones");
    }
  }

  // FARES

  Future<Fare> getFare(Vehicle vehicle, String zoneToken) async {
    final authToken = await sessionManager.getAuthToken();
    final accountToken = authToken.accountToken;
    final fareUrl = '$_baseUrl/parking/fares/table/';

    final body = json.encode({
      'account_token': accountToken,
      'type': 'MANAGED',
      'position_token': zoneToken,
      'dtStart': {'date': DateTime.now().toIso8601String()},
      'plate': {'id': vehicle.number, 'type': 'PT'}
    });

    final response = await http.post(
      fareUrl,
      headers: await _getHeaders(),
      body: body,
    );

    final responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return Fare.fromJson(json.decode(responseBody));
    } else if (await _canRetry(responseBody)) {
      return await getFare(vehicle, zoneToken);
    } else {
      throw Exception("Couldn't get fares");
    }
  }
}
