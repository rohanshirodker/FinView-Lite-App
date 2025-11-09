import 'package:shared_preferences/shared_preferences.dart';
import '../models/holding.dart';

enum SortType { value, gain, name }

class DashboardService {

  Future<Map<String, dynamic>> loadSavedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final sortName = prefs.getString('sortType');
    final showPercent = prefs.getBool('showPercentage');

    return {
      'sortType': SortType.values.firstWhere(
            (e) => e.name == sortName,
        orElse: () => SortType.value,
      ),
      'showPercentage': showPercent ?? true,
    };
  }

  Future<void> saveFilters(SortType sortType, bool showPercentage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortType', sortType.name);
    await prefs.setBool('showPercentage', showPercentage);
  }

  List<Holding> sortHoldings(List<Holding> holdings, SortType sortType) {
    switch (sortType) {
      case SortType.value:
        holdings.sort((a, b) => b.currentValue.compareTo(a.currentValue));
        break;
      case SortType.gain:
        holdings.sort((a, b) => b.gainPercentage.compareTo(a.gainPercentage));
        break;
      case SortType.name:
        holdings.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
    return holdings;
  }
}
