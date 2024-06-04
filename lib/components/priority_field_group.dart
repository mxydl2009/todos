import 'package:flutter/material.dart';
import 'package:todos/model/todo.dart';

class PriorityFieldGroup extends StatelessWidget {
  final Priority? initialValue;
  final Function(Priority)? onChange;
  final Widget child;
  const PriorityFieldGroup(
      {super.key, this.initialValue, this.onChange, required this.child});

  PopupMenuItem<Priority> _buildPriorityPopupMenuItem(Priority priority) {
    return PopupMenuItem(
      value: priority,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(priority.description),
          Container(
            width: 100,
            height: 5,
            color: priority.color,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Priority>(
      itemBuilder: (BuildContext context) =>
          Priority.values.map(_buildPriorityPopupMenuItem).toList(),
      onSelected: onChange,
      child: child,
    );
  }
}
