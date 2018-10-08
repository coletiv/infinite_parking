import 'dart:async';

import 'package:coletiv_infinite_parking/network/network.dart';

final authClient = _AuthClient._internal();

class _AuthClient {
  _AuthClient._internal();

  Future<bool> login(String email, String password, int provider) async {
    try {
      return await network.login(email, password, provider);
    } catch (e) {
      return false;
    }
  }

  Future<bool> refreshToken() async {
    return await network.refreshToken();
  }
}
