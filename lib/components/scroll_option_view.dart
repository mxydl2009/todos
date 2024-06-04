import 'package:flutter/widgets.dart';

typedef OptionItemViewBuilder = Widget Function(
    BuildContext context, String option, int index);
typedef OptionChanged = void Function(
    BuildContext context, String option, int index);

class ScrollOptionView extends StatefulWidget {
  final List<String> options;
  final OptionItemViewBuilder? itemBuilder;
  final OptionItemViewBuilder? activeItemBuilder;
  final OptionChanged? onOptionChanged;
  final int activeIndex;

  const ScrollOptionView({
    super.key,
    required this.options,
    this.itemBuilder,
    this.activeItemBuilder,
    this.onOptionChanged,
    this.activeIndex = 0,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ScrollOptionViewState createState() => _ScrollOptionViewState();
}

class _ScrollOptionViewState extends State<ScrollOptionView> {
  int _activeIndex = 0;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _activeIndex = _getSafeActiveIndex(widget.activeIndex);
  }

  @override
  void didUpdateWidget(ScrollOptionView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activeIndex != widget.activeIndex) {
      _activeIndex = _getSafeActiveIndex(widget.activeIndex);
      widget.onOptionChanged!(
          context, widget.options[_activeIndex], _activeIndex);
    }
  }

  int _getSafeActiveIndex(activeIndex) {
    if (activeIndex < 0) {
      return 0;
    }
    if (activeIndex >= widget.options.length) {
      return widget.options.length;
    }
    return activeIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = widget.options;
    return AnimatedList(
      scrollDirection: Axis.horizontal,
      initialItemCount: options.length,
      itemBuilder: (context, index, animation) =>
          _buildRow(context, options[index], index),
    );
  }

  Widget _buildRow(BuildContext context, String option, int index) {
    Widget content;
    if (_activeIndex == index) {
      content = widget.activeItemBuilder!(context, option, index);
    } else {
      content = widget.itemBuilder!(context, option, index);
    }

    return GestureDetector(
      child: content,
      onTap: () {
        setState(() {
          _activeIndex = index;
        });
        widget.onOptionChanged!(context, option, index);
      },
    );
  }
}
