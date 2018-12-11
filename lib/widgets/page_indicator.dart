import 'package:flutter/material.dart';

class PageIndicator extends StatefulWidget {
  Color unselectedColor = Colors.transparent;
  Color selectedColor = Colors.white;
  final PageController child;

  @override
  State<StatefulWidget> createState() {
    return _PageIndicatorState();
  }

  PageIndicator(
      {@required this.child, this.unselectedColor, this.selectedColor});
}

class _PageIndicatorState extends State<PageIndicator> {
  @override
  void initState() {
    super.initState();
    widget.child.addListener(() {
      print(widget.child.page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
