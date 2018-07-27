import 'dart:async';
import 'dart:convert';

import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:http/http.dart' as http;

final network = Network._internal();

class Network {
  Network._internal();

  final _headers = {
    'Content-Type': 'application/json',
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36',
    'X-EOS-CLIENT-TOKEN': '2463bc87-6e92-480e-a56b-4260ff8b6a38'
  };

  Future<Session> login(String email, String password) async {
    final loginUrl = 'https://eos.empark.com/api/v1.0/auth/accounts';
    final body = json.encode({'username': email, 'password': password});

    final response = await http.post(loginUrl, headers: _headers, body: body);

    if (response.statusCode == 200) {
      return Session.fromJson(json.decode(response.body));
    } else {
      throw Exception("Authentication failed");
    }
  }
}
