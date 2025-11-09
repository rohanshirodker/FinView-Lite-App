import 'package:flutter/material.dart';

class FilterPopup extends StatefulWidget {
  final bool isDarkMode;
  final String initialSort;
  final bool initialShowPercentage;
  final void Function(String sort, bool showPercentage) onChanged;

  const FilterPopup({
    super.key,
    required this.isDarkMode,
    required this.initialSort,
    required this.initialShowPercentage,
    required this.onChanged,
  });

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  late String _sortType;
  late bool _showPercentage;

  @override
  void initState() {
    super.initState();
    _sortType = widget.initialSort;
    _showPercentage = widget.initialShowPercentage;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sort By",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildSortOption("Value"),
            _buildSortOption("Gain"),
            _buildSortOption("Name"),
            const Divider(height: 24),
            _buildPercentageSwitch(),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onChanged(_sortType, _showPercentage);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check),
                label: const Text("Apply"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String option) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(option),
      leading: Radio<String>(
        value: option,
        groupValue: _sortType,
        onChanged: (value) => setState(() => _sortType = value!),
      ),
    );
  }

  Widget _buildPercentageSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Show %"),
        Switch(
          value: _showPercentage,
          onChanged: (val) => setState(() => _showPercentage = val),
        ),
      ],
    );
  }
}
