import 'dart:async';

import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/network.dart';
import 'package:coletiv_infinite_parking/data/session_manager.dart';

final fareClient = _FareClient._internal();

class _FareClient {
  _FareClient._internal();

  Future<Fare> getFare(Vehicle vehicle, MunicipalZone zone) async {
    try {
      return await network.getFare(vehicle, zone.token);
    } catch (e) {
      return null;
    }
  }

  Future<Fare> getSelectedFare() async {
    Vehicle selectedVehicle = await sessionManager.getSelectedVehicle();
    String selectedZoneToken = await sessionManager.getSelectedZoneToken();

    try {
      return await network.getFare(selectedVehicle, selectedZoneToken);
    } catch (e) {
      return null;
    }
  }
}
