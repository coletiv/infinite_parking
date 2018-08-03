import 'dart:async';

import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/network/network.dart';

final sessionClient = _SessionClient._internal();

class _SessionClient {
  _SessionClient._internal();

  Future<List<Session>> getSessions() async {
    try {
      return await network.getSessions();
    } catch (e) {
      return List<Session>();
    }
  }
}
