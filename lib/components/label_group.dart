import 'package:flutter/material.dart';

class LabelGroup extends StatelessWidget {
  final String labelText;
  final TextStyle? labelStyle;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const LabelGroup({
    super.key,
    required this.labelText,
    this.labelStyle,
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            labelText,
            style:
                labelStyle ?? Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          child
        ],
      ),
    );
  }
}
