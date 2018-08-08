import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/auth_token.dart';
import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:http/http.dart' as http;

final network = _Network._internal();

class _Network {
  _Network._internal();

  final baseUrl = 'https://eos.empark.com/api/v1.0';

  final headers = {
    'Content-Type': 'application/json',
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36',
    'X-EOS-CLIENT-TOKEN': '2463bc87-6e92-480e-a56b-4260ff8b6a38'
  };

  Future<AuthToken> login(String email, String password) async {
    final loginUrl = '$baseUrl/auth/accounts';
    final body = json.encode({'username': email, 'password': password});

    final response = await http.post(loginUrl, headers: headers, body: body);

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
        '$baseUrl/parking/sessions?account=$accountToken&session_state=ACTIVE';
    final sessionsHeaders = headers;
    sessionsHeaders["X-EOS-USER-TOKEN"] = authToken.userSessionToken;

    final response = await http.get(sessionsUrl, headers: sessionsHeaders);

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
    final vehiclesUrl = '$baseUrl/accounts/$accountToken/vehicles/';
    final vehiclesHeaders = headers;
    vehiclesHeaders['X-EOS-USER-TOKEN'] = authToken.userSessionToken;

    final response = await http.get(vehiclesUrl, headers: vehiclesHeaders);

    if (response.statusCode == 200) {
      Iterable responseJson = json.decode(response.body);
      return responseJson.map((object) => Vehicle.fromJson(object)).toList();
    } else {
      throw Exception("Couldn't get vehicles");
    }
  }

  Future<List<Municipal>> getMunicipal() async {
    final authToken = await sessionManager.getAuthToken();
    final municipalUrl = '$baseUrl/centers/services?type=MUNICIPAL_CONTEXT';
    final municipalHeaders = headers;
    municipalHeaders['X-EOS-USER-TOKEN'] = authToken.userSessionToken;

    final response = await http.get(municipalUrl, headers: municipalHeaders);

    if (response.statusCode == 200) {
      Iterable responseJson = json.decode(response.body)['result'];
      return responseJson.map((object) => Municipal.fromJson(object)).toList();
    } else {
      throw Exception("Couldn't get municipal");
    }
  }
}
