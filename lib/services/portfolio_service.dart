import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:finview_lite/models/portfolio.dart';
import 'package:finview_lite/models/holding.dart';

enum SortType { value, gain, name }

class PortfolioService {
  Portfolio? _cachedPortfolio;

  Future<Portfolio> loadPortfolio() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/portfolio.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedPortfolio = Portfolio.fromJson(jsonData);
      return _cachedPortfolio!;
    } catch (e) {
      throw Exception('Failed to load portfolio data: $e');
    }
  }

  Future<Portfolio> refreshPrices() async {
    if (_cachedPortfolio == null) {
      return await loadPortfolio();
    }

    await Future.delayed(const Duration(milliseconds: 800));

    final random = Random();
    final updatedHoldings = _cachedPortfolio!.holdings.map((holding) {
      final changePercent = (random.nextDouble() * 4) - 2;
      final newPrice = holding.currentPrice * (1 + changePercent / 100);
      return holding.copyWith(currentPrice: newPrice);
    }).toList();

    final newPortfolioValue = updatedHoldings.fold(
      0.0,
      (sum, holding) => sum + holding.currentValue,
    );

    final newTotalGain = updatedHoldings.fold(
      0.0,
      (sum, holding) => sum + holding.gain,
    );

    _cachedPortfolio = _cachedPortfolio!.copyWith(
      holdings: updatedHoldings,
      portfolioValue: newPortfolioValue,
      totalGain: newTotalGain,
      lastUpdated: DateTime.now(),
    );

    return _cachedPortfolio!;
  }

  List<Holding> sortHoldings(List<Holding> holdings, SortType sortType, {bool ascending = false}) {
    final sortedList = List<Holding>.from(holdings);
    
    switch (sortType) {
      case SortType.value:
        sortedList.sort((a, b) => ascending 
          ? a.currentValue.compareTo(b.currentValue)
          : b.currentValue.compareTo(a.currentValue));
        break;
      case SortType.gain:
        sortedList.sort((a, b) => ascending
          ? a.gain.compareTo(b.gain)
          : b.gain.compareTo(a.gain));
        break;
      case SortType.name:
        sortedList.sort((a, b) => ascending
          ? a.name.compareTo(b.name)
          : b.name.compareTo(a.name));
        break;
    }
    
    return sortedList;
  }
}
