import 'dart:async';

import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/session.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
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

  Future<Session> addSession(
      Vehicle vehicle, MunicipalZone zone, Fare fare) async {
    try {
      return await network.addSession(vehicle, zone, fare);
    } catch (e) {
      return null;
    }
  }

  Future<Session> refreshSession(Fare fare) async {
    try {
      return await network.refreshSession(fare);
    } catch (e) {
      return null;
    }
  }
}
