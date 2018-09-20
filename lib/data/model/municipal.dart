class Municipal {
  final String token;
  final String name;

  const Municipal({
    this.token,
    this.name,
  });

  factory Municipal.fromJson(Map<String, dynamic> json) {
    return Municipal(
      token: json['token'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {'token': token, 'name': name};
}
