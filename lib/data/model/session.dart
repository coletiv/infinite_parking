class Session {
  final Map<String, String> plate;
  final Map<String, String> dtStart;
  final List<double> coordinates;
  final Map<String, double> costTimePair;

  const Session(
      {this.plate, this.dtStart, this.coordinates, this.costTimePair});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      plate: json["plate"],
      dtStart: json['dtstart'],
      coordinates: json['coordinates'],
      costTimePair: json['cost_time_pair'],
    );
  }

  Map<String, dynamic> toJson() => {
        'plate': plate,
        'dtstart': dtStart,
        'coordinates': coordinates,
        'cost_time_pair': costTimePair
      };

  String getPlate() {
    return plate['id'];
  }

  double getLatitude() {
    return coordinates.last;
  }

  double getLongitude() {
    return coordinates.first;
  }

  double getCost() {
    return costTimePair['cost'];
  }

  DateTime getInitialDate() {}
}
