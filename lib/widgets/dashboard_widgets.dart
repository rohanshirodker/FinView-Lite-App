import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';


typedef SortCallback = Future<void> Function(SortType type);
typedef ToggleCallback = Future<void> Function(bool showPercentage);

class DashboardControls extends StatelessWidget {
  final bool isDarkMode;
  final bool showPercentage;
  final SortType sortType;
  final SortCallback onSortChange;
  final ToggleCallback onToggleChange;

  const DashboardControls({
    super.key,
    required this.isDarkMode,
    required this.showPercentage,
    required this.sortType,
    required this.onSortChange,
    required this.onToggleChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = isDarkMode ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Holdings',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: border),
              ),
            ),
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                backgroundColor: isDarkMode ? const Color(0xFF1E252D) : Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        Text(
                          'Sort by',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildSortChip(context, "Value", SortType.value),
                            _buildSortChip(context, "Gain", SortType.gain),
                            _buildSortChip(context, "Name", SortType.name),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 20),
                        Text(
                          'Show Returns As',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            ChoiceChip(
                              label: const Text('%'),
                              selected: showPercentage,
                              onSelected: (selected) async {
                                await onToggleChange(true);
                                Navigator.pop(context);
                              },
                            ),
                            ChoiceChip(
                              label: const Text('₹'),
                              selected: !showPercentage,
                              onSelected: (selected) async {
                                await onToggleChange(false);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_list, size: 18),
            label: Text(
              'Filter',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(BuildContext context, String label, SortType type) {
    final theme = Theme.of(context);
    final isSelected = sortType == type;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) async {
        if (selected) {
          await onSortChange(type);
          Navigator.pop(context);
        }
      },
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      backgroundColor: isDarkMode ? const Color(0xFF0F1419) : Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected
            ? theme.colorScheme.primary
            : (isDarkMode ? const Color(0xFF2A3340) : const Color(0xFFE8EDF2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
