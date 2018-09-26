import 'package:coletiv_infinite_parking/data/model/fare_cost.dart';

class Fare {
  final String promiseToken;
  final List<FareCost> values;
  final List<FareCost> simpleValues;

  DateTime selectedTime;

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

  List<FareCost> getSelectedFares() {
    if (selectedTime == null) {
      return null;
    }

    DateTime currentDate = DateTime.now();
    Duration sessionDuration = selectedTime.difference(currentDate);

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

  double getSessionCost() {
    if (selectedTime == null) {
      return null;
    }

    double cost = 0.0;

    getSelectedFares().forEach((fareCost) => cost += fareCost.cost);

    return cost;
  }

  String getFormattedSessionCost() {
    if (selectedTime == null) {
      return null;
    }

    return "${getSessionCost()}€";
  }

  DateTime getSessionExpirationDate() {
    if (selectedTime == null) {
      return null;
    }

    Duration sessionDuration = Duration();

    getSelectedFares().forEach(
        (fareCost) => sessionDuration += fareCost.getChargedDuration());

    return DateTime.now().add(sessionDuration);
  }

  String getFormattedSessionExpirationTime() {
    if (selectedTime == null) {
      return null;
    }

    int expirationHour = getSessionExpirationDate().hour;
    int expirationMinute = getSessionExpirationDate().minute;
    return "Expires: $expirationHour:$expirationMinute";
  }
}
