import 'dart:async';

import 'package:coletiv_infinite_parking/data/model/fare.dart';
import 'package:coletiv_infinite_parking/data/model/municipal.dart';
import 'package:coletiv_infinite_parking/data/model/municipal_zone.dart';
import 'package:coletiv_infinite_parking/data/model/vehicle.dart';
import 'package:coletiv_infinite_parking/network/network.dart';

final municipalClient = _MunicipalClient._internal();

class _MunicipalClient {
  _MunicipalClient._internal();

  Future<List<Municipal>> getMunicipals() async {
    try {
      return await network.getMunicipals();
    } catch (e) {
      return List<Municipal>();
    }
  }

  Future<List<MunicipalZone>> getMunicipalZones(String municipalToken) async {
    try {
      return await network.getMunicipalZones(municipalToken);
    } catch (e) {
      return List<MunicipalZone>();
    }
  }

  Future<Fare> getFare(Vehicle vehicle, MunicipalZone zone) async {
    try {
      return await network.getFares(vehicle, zone);
    } catch (e) {
      return null;
    }
  }
}
