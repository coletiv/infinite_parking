import 'dart:async';

import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/network.dart';

final vehicle = _VehicleClient._internal();

class _VehicleClient {
  _VehicleClient._internal();

  Future<List<Vehicle>> getVehicles() async {
    try {
      return await network.getVehicles();
    } catch (e) {
      return List<Vehicle>();
    }
  }
}
