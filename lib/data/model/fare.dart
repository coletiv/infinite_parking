import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';

class Fare {
  final List<FareCost> values;
  final String promiseToken;

  const Fare({this.values, this.promiseToken});

  factory Fare.fromJson(Map<String, dynamic> json) {
    return Fare(
      values:
          json['values'].map((object) => FareCost.fromJson(object)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'values': values.map((fareCost) => fareCost.toJson()),
        'promise_token': promiseToken
      };
}
