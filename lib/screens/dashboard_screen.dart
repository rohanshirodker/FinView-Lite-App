import 'package:flutter/material.dart';
import 'package:finview_lite/models/portfolio.dart';
import 'package:finview_lite/services/auth_service.dart';
import 'package:finview_lite/services/portfolio_service.dart' hide SortType;
import 'package:finview_lite/widgets/portfolio_summary_card.dart';
import 'package:finview_lite/widgets/holding_card.dart';
import 'package:finview_lite/widgets/allocation_chart.dart';
import '../services/dashboard_service.dart';
import '../widgets/dashboard_widgets.dart';

class DashboardScreen extends StatefulWidget {
  final bool isDarkMode;
  const DashboardScreen({super.key, required this.isDarkMode});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _authService = AuthService();
  final _portfolioService = PortfolioService();
  final _dashboardService = DashboardService();

  Portfolio? _portfolio;
  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _showPercentage = true;
  SortType _sortType = SortType.value;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFilters();
    _loadPortfolio();
  }

  Future<void> _loadFilters() async {
    final data = await _dashboardService.loadSavedFilters();
    setState(() {
      _sortType = data['sortType'];
      _showPercentage = data['showPercentage'];
    });
  }

  Future<void> _loadPortfolio() async {
    try {
      setState(() => _isLoading = true);
      final portfolio = await _portfolioService.loadPortfolio();
      setState(() {
        _portfolio = portfolio;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshPortfolio() async {
    try {
      setState(() => _isRefreshing = true);
      final portfolio = await _portfolioService.refreshPrices();
      setState(() {
        _portfolio = portfolio;
        _isRefreshing = false;
      });
    } catch (_) {
      setState(() => _isRefreshing = false);
    }
  }

  Future<void> _updateSort(SortType type) async {
    await _dashboardService.saveFilters(type, _showPercentage);
    setState(() => _sortType = type);
  }

  Future<void> _updateShowPercentage(bool show) async {
    await _dashboardService.saveFilters(_sortType, show);
    setState(() => _showPercentage = show);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: _authService.getCurrentUser(),
          builder: (context, snapshot) {
            final name = snapshot.data ?? 'Portfolio';
            return Text('Hello, $name',
                style: const TextStyle(fontWeight: FontWeight.w600));
          },
        ),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshPortfolio,
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _portfolio == null
            ? const Text('No Portfolio Found')
            : SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PortfolioSummaryCard(portfolio: _portfolio!),
                    const SizedBox(height: 24),

                    // ✅ Always center Allocation Chart
                    Center(
                        child:
                        AllocationChart(portfolio: _portfolio!)),
                    const SizedBox(height: 24),

                    DashboardControls(
                      isDarkMode: widget.isDarkMode,
                      showPercentage: _showPercentage,
                      sortType: _sortType,
                      onSortChange: _updateSort,
                      onToggleChange: _updateShowPercentage,
                    ),
                    const SizedBox(height: 16),

                    // ✅ Centered list of holdings
                    Column(
                      children: _dashboardService
                          .sortHoldings(
                          [..._portfolio!.holdings], _sortType)
                          .map((h) => Padding(
                        padding:
                        const EdgeInsets.only(bottom: 8),
                        child: HoldingCard(
                          holding: h,
                          showPercentage: _showPercentage,
                        ),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
