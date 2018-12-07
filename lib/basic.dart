import 'package:flutter/material.dart';

abstract class StateWithFuture<T extends StatefulWidget> extends State<T> {
  Object _lock;
  @override
  void initState() {
    super.initState();
    _lock = Object();
  }

  @override
  void setState(fn) {
    if (_lock != null) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _lock = null;
  }
}
