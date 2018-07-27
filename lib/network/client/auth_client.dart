import 'dart:async';

import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:coletiv_infinite_parking/network/network.dart';

final authClient = AuthClient._internal();

class AuthClient {
  AuthClient._internal();

  Future<bool> login(String email, String password) async {
    try {
      final authToken = await network.login(email, password);
      return sessionManager.saveAuthToken(authToken);
    } catch (e) {
      return false;
    }
  }
}
