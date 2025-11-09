class Holding {
  final String symbol;
  final String name;
  final int units;
  final double avgCost;
  final double currentPrice;

  Holding({
    required this.symbol,
    required this.name,
    required this.units,
    required this.avgCost,
    required this.currentPrice,
  });

  double get currentValue => units * currentPrice;
  double get totalCost => units * avgCost;
  double get gain => currentValue - totalCost;
  double get gainPercentage => totalCost > 0 ? (gain / totalCost) * 100 : 0.0;

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      units: json['units'] as int? ?? 0,
      avgCost: (json['avg_cost'] as num?)?.toDouble() ?? 0.0,
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'name': name,
    'units': units,
    'avg_cost': avgCost,
    'current_price': currentPrice,
  };

  Holding copyWith({
    String? symbol,
    String? name,
    int? units,
    double? avgCost,
    double? currentPrice,
  }) {
    return Holding(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      units: units ?? this.units,
      avgCost: avgCost ?? this.avgCost,
      currentPrice: currentPrice ?? this.currentPrice,
    );
  }
}
