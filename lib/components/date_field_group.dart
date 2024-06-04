import 'package:flutter/material.dart';

class DateFieldGroup extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime startDate;
  final DateTime endDate;
  final DatePickerMode initialDatePickerMode;
  final Widget child;
  final Function(DateTime)? onSelect;

  const DateFieldGroup({
    super.key,
    this.initialDate,
    required this.startDate,
    required this.endDate,
    this.initialDatePickerMode = DatePickerMode.day,
    required this.child,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AbsorbPointer(
        child: child,
      ),
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: startDate,
            lastDate: endDate,
            initialDatePickerMode: initialDatePickerMode);
        if (selectedDate != null && onSelect != null) {
          onSelect!(selectedDate);
        }
      },
    );
  }
}
