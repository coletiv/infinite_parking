import 'dart:async';

import 'package:coletiv_infinite_parking/network/network.dart';

final sessionClient = _SessionClient._internal();

class _SessionClient {
  _SessionClient._internal();

  Future<bool> getSessions() async {
    try {
      final response = await network.getSessions();
      return true;
    } catch (e) {
      return false;
    }
  }
}
