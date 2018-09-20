import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';

class Fare {
  final String promiseToken;
  final List<FareCost> values;
  final List<FareCost> simpleValues;

  int simpleFareIndex;

  Fare({
    this.promiseToken,
    this.values,
    this.simpleValues,
  });

  factory Fare.fromJson(Map<String, dynamic> json) {
    return Fare(
      promiseToken: json['promise_token'],
      values: json['values']
          .map<FareCost>((object) => FareCost.fromJson(object))
          .toList(),
      simpleValues: json['simple_view']
          .map<FareCost>((object) => FareCost.fromJson(object))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'promise_token': promiseToken,
    'values': values.map((fareCost) => fareCost.toJson()),
    'simple_view': simpleValues.map((fareCost) => fareCost.toJson()),
  };


  void updateSelectedSimpleFare(int simpleFareIndex) {
    this.simpleFareIndex = simpleFareIndex;
  }

  FareCost getSelectedSimpleFare() => simpleValues[simpleFareIndex];
}
