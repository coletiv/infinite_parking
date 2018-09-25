class MunicipalZone {
  final String token;
  final String contextToken;
  final bool parkingAllowed;
  final String parentToken;
  final bool hasChildren;
  final bool isVisible;
  final String name;
  final String color;

  const MunicipalZone({
    this.token,
    this.contextToken,
    this.parkingAllowed,
    this.parentToken,
    this.hasChildren,
    this.isVisible,
    this.name,
    this.color,
  });

  factory MunicipalZone.fromJson(Map<String, dynamic> json) {
    return MunicipalZone(
      token: json['token'],
      contextToken: json['context_token'],
      parkingAllowed: json['parking_allowed'],
      parentToken: json['parent_token'],
      hasChildren: json['has_children'],
      isVisible: json['isVisible'],
      name: json['name'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'context_token': contextToken,
        'parking_allowed': parkingAllowed,
        'parent_token': parentToken,
        'has_children': hasChildren,
        'isVisible': isVisible,
        'name': name,
        'color': color,
      };
}
