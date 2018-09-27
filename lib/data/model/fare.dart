import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';

class Fare {
  final String promiseToken;
  final List<FareCost> values;
  final List<FareCost> simpleValues;

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

  Duration getMinimumDuration() => simpleValues.first.getChargedDuration();

  List<FareCost> getSelectedFares(DateTime selectedTime) {
    if (selectedTime == null || DateTime.now().isAfter(selectedTime)) {
      return List<FareCost>();
    }

    Duration sessionDuration = selectedTime.difference(DateTime.now());

    Duration durationLeftToCalculate = sessionDuration;

    List<FareCost> selectedFares = List<FareCost>();

    while (durationLeftToCalculate.inMicroseconds > 0) {
      FareCost fare = simpleValues.firstWhere(
          (fareCost) =>
              fareCost.getChargedDuration() >= durationLeftToCalculate,
          orElse: () => simpleValues.last);

      selectedFares.add(fare);
      durationLeftToCalculate -= fare.getChargedDuration();
    }

    return selectedFares;
  }

  double getSessionCost(DateTime selectedTime) {
    double cost = 0.0;

    getSelectedFares(selectedTime).forEach((fareCost) => cost += fareCost.cost);

    return cost;
  }

  String getFormattedSessionCost(DateTime selectedTime) {
    return "${getSessionCost(selectedTime)}€";
  }

  DateTime getSessionExpirationDate(DateTime selectedTime) {
    Duration sessionDuration = Duration();

    getSelectedFares(selectedTime).forEach(
        (fareCost) => sessionDuration += fareCost.getChargedDuration());

    return DateTime.now().add(sessionDuration);
  }

  String getFormattedSessionExpirationTime(DateTime selectedTime) {
    int expirationHour = getSessionExpirationDate(selectedTime).hour;
    int expirationMinute = getSessionExpirationDate(selectedTime).minute;
    return "Expires: $expirationHour:$expirationMinute";
  }
}
