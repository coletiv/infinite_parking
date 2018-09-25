class FareCost {
  final double cost;
  final double chargedCost;
  final int realDuration;
  final int chargedDuration;

  const FareCost({
    this.cost,
    this.chargedCost,
    this.realDuration,
    this.chargedDuration,
  });

  factory FareCost.fromJson(Map<String, dynamic> json) {
    return FareCost(
      cost: json['cost'],
      chargedCost: json['charged_cost'],
      realDuration: json['real_duration'],
      chargedDuration: json['charged_duration'],
    );
  }

  Map<String, dynamic> toJson() => {
        'cost': cost,
        'charged_cost': chargedCost,
        'real_duration': realDuration,
        'charged_duration': chargedDuration,
      };

  Duration getChargedDuration() => Duration(milliseconds: chargedDuration);
}
