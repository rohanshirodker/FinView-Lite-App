import 'package:flutter/material.dart';
import 'package:finview_lite/models/holding.dart';
import 'package:intl/intl.dart';

class HoldingCard extends StatelessWidget {
  final Holding holding;
  final bool showPercentage;

  const HoldingCard({
    super.key,
    required this.holding,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1F26) : const Color(0xFFF8FAFC);
    final border = isDark ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final positiveColor = isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
    final negativeColor = isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);
    
    final isPositive = holding.gain >= 0;
    final gainColor = isPositive ? positiveColor : negativeColor;
    
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    final percentFormat = NumberFormat('#,##0.00');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: border, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    holding.symbol.substring(0, 1),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holding.symbol,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      holding.name,
                      style: theme.textTheme.bodySmall?.copyWith(color: textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(holding.currentValue),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    showPercentage
                        ? '${isPositive ? '+' : ''}${percentFormat.format(holding.gainPercentage)}%'
                        : '${isPositive ? '+' : ''}${currencyFormat.format(holding.gain)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: gainColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F1419) : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Units', style: theme.textTheme.bodySmall?.copyWith(color: textSecondary)),
                    const SizedBox(height: 4),
                    Text('${holding.units}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Avg Cost', style: theme.textTheme.bodySmall?.copyWith(color: textSecondary)),
                    const SizedBox(height: 4),
                    Text(currencyFormat.format(holding.avgCost), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current', style: theme.textTheme.bodySmall?.copyWith(color: textSecondary)),
                    const SizedBox(height: 4),
                    Text(currencyFormat.format(holding.currentPrice), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
