import 'dart:async';

import 'package:coletiv_infinite_parking/data/model/municipal.dart';
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
}
