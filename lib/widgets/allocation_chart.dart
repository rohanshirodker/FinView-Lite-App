import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finview_lite/models/portfolio.dart';

class AllocationChart extends StatefulWidget {
  final Portfolio portfolio;

  const AllocationChart({super.key, required this.portfolio});

  @override
  State<AllocationChart> createState() => _AllocationChartState();
}

class _AllocationChartState extends State<AllocationChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1F26) : const Color(0xFFF8FAFC);
    final border = isDark ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    if (widget.portfolio.holdings.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardBg,
          border: Border.all(color: border, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No holdings to display',
            style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary),
          ),
        ),
      );
    }

    final totalValue = widget.portfolio.portfolioValue;
    final colors = [
      const Color(0xFF06B6D4),
      const Color(0xFF10B981),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFFEC4899),
      const Color(0xFF3B82F6),
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: border, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Allocation',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: List.generate(
                  widget.portfolio.holdings.length,
                  (i) {
                    final holding = widget.portfolio.holdings[i];
                    final percentage = (holding.currentValue / totalValue) * 100;
                    final isTouched = i == touchedIndex;
                    final radius = isTouched ? 65.0 : 55.0;

                    return PieChartSectionData(
                      color: colors[i % colors.length],
                      value: holding.currentValue,
                      title: '${percentage.toStringAsFixed(1)}%',
                      radius: radius,
                      titleStyle: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: List.generate(
              widget.portfolio.holdings.length,
              (i) {
                final holding = widget.portfolio.holdings[i];
                final percentage = (holding.currentValue / totalValue) * 100;
                
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors[i % colors.length],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${holding.symbol} (${percentage.toStringAsFixed(1)}%)',
                      style: theme.textTheme.bodySmall?.copyWith(color: textSecondary),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
