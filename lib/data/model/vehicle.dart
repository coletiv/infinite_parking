class Vehicle {
  final String token;
  final String number;
  final String comment;
  final bool isFavorite;

  const Vehicle({this.token, this.number, this.comment, this.isFavorite});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        token: json['token'],
        number: json['number'],
        comment: json['comment'],
        isFavorite: json['is_favorite']);
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'number': number,
        'comment': comment,
        'is_favorite': isFavorite
      };
}
