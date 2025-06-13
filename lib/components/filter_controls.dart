import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatelessWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final Function(BuildContext, bool) onDateSelected;
  final VoidCallback onClearDates;

  const DateRangePicker({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onDateSelected,
    required this.onClearDates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Flexible(
              child: InkWell(
                onTap: () => onDateSelected(context, true),
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    labelText: 'From Date',
                    labelStyle: TextStyle(color: Colors.blue.shade800),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fromDate != null
                            ? DateFormat.yMMMd().format(fromDate!)
                            : 'Select date',
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                      Icon(Icons.calendar_today, size: 20, color: Colors.blue.shade600),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: InkWell(
                onTap: () => onDateSelected(context, false),
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    labelText: 'To Date',
                    labelStyle: TextStyle(color: Colors.blue.shade800),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        toDate != null
                            ? DateFormat.yMMMd().format(toDate!)
                            : 'Select date',
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                      Icon(Icons.calendar_today, size: 20, color: Colors.blue.shade600),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(Icons.clear, color: Colors.blue.shade300),
              onPressed: onClearDates,
              tooltip: 'Clear date filters',
            ),
          ],
        ),
      ),
    );
  }
}

class AmountRangeFilter extends StatelessWidget {
  final double minAmount;
  final double maxAmount;
  final ValueChanged<String> onMinAmountChanged;
  final ValueChanged<String> onMaxAmountChanged;

  const AmountRangeFilter({
    super.key,
    required this.minAmount,
    required this.maxAmount,
    required this.onMinAmountChanged,
    required this.onMaxAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  labelText: 'Min Amount',
                  labelStyle: TextStyle(color: Colors.blue.shade800),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: onMinAmountChanged,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  labelText: 'Max Amount',
                  labelStyle: TextStyle(color: Colors.blue.shade800),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue.shade300),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: onMaxAmountChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const FilterDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue.shade50,
          labelText: label,
          labelStyle: TextStyle(color: Colors.blue.shade800),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade300),
          ),
        ),
        dropdownColor: Colors.blue.shade50,
        iconEnabledColor: Colors.blue,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

class ResetFiltersButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ResetFiltersButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.refresh),
          label: const Text('Reset Filters'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade100,
            foregroundColor: Colors.blue.shade800,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}