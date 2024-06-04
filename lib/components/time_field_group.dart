import 'package:flutter/material.dart';

class TimeFieldGroup extends StatelessWidget {
  final TimeOfDay initialTime;
  final Widget child;
  final Function(TimeOfDay?)? onSelect;

  const TimeFieldGroup({
    super.key,
    required this.initialTime,
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
        TimeOfDay? timeOfDay = await showTimePicker(
          context: context,
          initialTime: initialTime,
        );
        if (onSelect != null) {
          onSelect!(timeOfDay);
        }
      },
    );
  }
}
