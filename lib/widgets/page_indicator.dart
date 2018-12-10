import 'package:flutter/material.dart';

class PageIndicator extends StatefulWidget {
  Color unselectedColor = Colors.transparent;
  Color selectedColor = Colors.white;
  final PageController controller;

  @override
  State<StatefulWidget> createState() {
    return _PageIndicatorState();
  }

  PageIndicator(
      {@required this.controller, this.unselectedColor, this.selectedColor});
}

class _PageIndicatorState extends State<PageIndicator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
