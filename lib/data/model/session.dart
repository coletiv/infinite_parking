class Session {
  final Map<String, dynamic> plate;
  final Map<String, dynamic> dtStart;
  final String positionToken;
  final List<dynamic> coordinates;
  final Map<String, dynamic> costTimePair;

  const Session({
    this.plate,
    this.dtStart,
    this.positionToken,
    this.coordinates,
    this.costTimePair,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      plate: json["plate"],
      dtStart: json['dtstart'],
      positionToken: json["position_token"],
      coordinates: json['coordinates'],
      costTimePair: json['cost_time_pair'],
    );
  }

  Map<String, dynamic> toJson() => {
        'plate': plate,
        'dtstart': dtStart,
        'position_token': positionToken,
        'coordinates': coordinates,
        'cost_time_pair': costTimePair,
      };

  String getPlate() => plate['id'];

  double getLatitude() => coordinates.last;

  double getLongitude() => coordinates.first;

  double getCost() => costTimePair['cost'];

  Duration getDuration() {
    final int durationString = costTimePair['duration_ms'];
    return Duration(milliseconds: durationString);
  }

  DateTime getInitialDate() {
    final dateString = dtStart["date"];
    return DateTime.parse(dateString);
  }

  DateTime getFinalDate() => getInitialDate().add(getDuration());

  Duration getTimeLeft() => getFinalDate().difference(DateTime.now());

  String getFormattedFinalDate() {
    final finalDate = getFinalDate();
    final timeLeft = getTimeLeft();
    return 'Ends: ${finalDate.hour}:${finalDate.minute} Time Left: ${timeLeft.inMinutes} minutes';
  }
}
