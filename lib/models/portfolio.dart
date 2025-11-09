import 'package:finview_lite/models/holding.dart';

class Portfolio {
  final String user;
  final double portfolioValue;
  final double totalGain;
  final List<Holding> holdings;
  final DateTime lastUpdated;

  Portfolio({
    required this.user,
    required this.portfolioValue,
    required this.totalGain,
    required this.holdings,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  double get totalGainPercentage {
    final totalCost = portfolioValue - totalGain;
    return totalCost > 0 ? (totalGain / totalCost) * 100 : 0.0;
  }

  double get calculatedPortfolioValue =>
      holdings.fold(0.0, (sum, holding) => sum + holding.currentValue);

  double get calculatedTotalGain =>
      holdings.fold(0.0, (sum, holding) => sum + holding.gain);

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    final holdingsList = (json['holdings'] as List<dynamic>?)
        ?.map((h) => Holding.fromJson(h as Map<String, dynamic>))
        .toList() ?? [];

    return Portfolio(
      user: json['user'] as String? ?? 'Guest',
      portfolioValue: (json['portfolio_value'] as num?)?.toDouble() ?? 0.0,
      totalGain: (json['total_gain'] as num?)?.toDouble() ?? 0.0,
      holdings: holdingsList,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user,
    'portfolio_value': portfolioValue,
    'total_gain': totalGain,
    'holdings': holdings.map((h) => h.toJson()).toList(),
  };

  Portfolio copyWith({
    String? user,
    double? portfolioValue,
    double? totalGain,
    List<Holding>? holdings,
    DateTime? lastUpdated,
  }) {
    return Portfolio(
      user: user ?? this.user,
      portfolioValue: portfolioValue ?? this.portfolioValue,
      totalGain: totalGain ?? this.totalGain,
      holdings: holdings ?? this.holdings,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
