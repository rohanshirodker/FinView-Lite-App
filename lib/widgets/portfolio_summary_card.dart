import 'package:flutter/material.dart';
import 'package:finview_lite/models/portfolio.dart';
import 'package:intl/intl.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final Portfolio portfolio;

  const PortfolioSummaryCard({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1F26) : const Color(0xFFF8FAFC);
    final border = isDark ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final positiveColor = isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
    final negativeColor = isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);

    final isPositive = portfolio.totalGain >= 0;
    final gainColor = isPositive ? positiveColor : negativeColor;

    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    final percentFormat = NumberFormat('#,##0.00');

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
          Text('Total Portfolio Value', style: theme.textTheme.bodyMedium?.copyWith(color: textSecondary)),
          const SizedBox(height: 8),

          // 👇 Animated Number Section
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: portfolio.portfolioValue,
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Text(
                currencyFormat.format(value),
                style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              );
            },
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: gainColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '${isPositive ? '+' : ''}${currencyFormat.format(portfolio.totalGain)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: gainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: gainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}${percentFormat.format(portfolio.totalGainPercentage)}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: gainColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Last updated: ${DateFormat('MMM dd, yyyy • hh:mm a').format(portfolio.lastUpdated)}',
            style: theme.textTheme.bodySmall?.copyWith(color: textSecondary),
          ),
        ],
      ),
    );
  }
}
