import 'dart:async';

import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:coletiv_infinite_parking/network/network.dart';

final authClient = _AuthClient._internal();

class _AuthClient {
  _AuthClient._internal();

  Future<bool> login(String email, String password) async {
    try {
      final authToken = await network.login(email, password);
      return sessionManager.saveAuthToken(authToken);
    } catch (e) {
      return false;
    }
  }
}
