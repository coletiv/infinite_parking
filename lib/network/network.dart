import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/auth_token.dart';
import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:http/http.dart' as http;

final network = _Network._internal();

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

  Future<AuthToken> login(String email, String password) async {
    final loginUrl = '$_baseUrl/auth/accounts';
    final body = json.encode({'username': email, 'password': password});

    final response =
    await http.post(loginUrl, headers: await _getHeaders(), body: body);

    if (response.statusCode == 200) {
      return AuthToken.fromJson(json.decode(response.body));
    } else {
      throw Exception("Authentication failed");
    }
  }

  Future<List<Session>> getSessions() async {
    final authToken = await sessionManager.getAuthToken();
    final accountToken = authToken.accountToken;
    final sessionsUrl =
        '$_baseUrl/parking/sessions?account=$accountToken&session_state=ACTIVE';

    final response = await http.get(sessionsUrl, headers: await _getHeaders());

    if (response.statusCode == 200) {
      Iterable responseJson = json.decode(response.body);
      return responseJson.map((object) => Session.fromJson(object)).toList();
    } else {
      throw Exception("Couldn't get sessions");
    }
  }

  Future<List<Vehicle>> getVehicles() async {
    final authToken = await sessionManager.getAuthToken();
    final accountToken = authToken.accountToken;
    final vehiclesUrl = '$_baseUrl/accounts/$accountToken/vehicles/';

    final response = await http.get(vehiclesUrl, headers: await _getHeaders());

    if (response.statusCode == 200) {
      Iterable responseJson = json.decode(response.body);
      return responseJson.map((object) => Vehicle.fromJson(object)).toList();
    } else {
      throw Exception("Couldn't get vehicles");
    }
  }

  Future<List<Municipal>> getMunicipals() async {
    final municipalUrl = '$_baseUrl/centers/services?type=MUNICIPAL_CONTEXT';

    final response = await http.get(municipalUrl, headers: await _getHeaders());

    if (response.statusCode == 200) {
      Iterable responseJson = json.decode(response.body)['result'];
      return responseJson.map((object) => Municipal.fromJson(object)).toList();
    } else {
      throw Exception("Couldn't get municipals");
    }
  }

  Future<List<MunicipalZone>> getMunicipalZones(String municipalToken) async {
    final zoneUrl =
        '$_baseUrl/geo/search?context_token=$municipalToken&polygon_info=true';

    final response = await http.get(zoneUrl, headers: await _getHeaders());

    if (response.statusCode == 200) {
      Iterable responseJson = json.decode(response.body)['result'];
      return responseJson
          .map((object) => MunicipalZone.fromJson(object))
          .toList();
    } else {
      throw Exception("Couldn't get zones");
    }
  }

  Future<Fare> getFares(Vehicle vehicle, MunicipalZone zone) async {
    final authToken = await sessionManager.getAuthToken();
    final accountToken = authToken.accountToken;
    final fareUrl = '$_baseUrl/parking/fares/table/';

    final body = json.encode({
      'account_token': accountToken,
      'type': 'MANAGED',
      'position_token': zone.token,
      'dtStart': {'date': DateTime.now().toIso8601String()},
      'plate': {'id': vehicle.number, 'type': 'PT'}
    });

    final response =
    await http.post(fareUrl, headers: await _getHeaders(), body: body);

    if (response.statusCode == 200) {
      return Fare.fromJson(json.decode(response.body));
    } else {
      throw Exception("Couldn't get fares");
    }
  }
}
