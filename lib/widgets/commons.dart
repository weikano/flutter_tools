import 'package:flutter/material.dart';

class ReloadButton extends StatelessWidget {
  final VoidCallback _onPressed;
  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
        onPressed: _onPressed,
        icon: Icon(
          Icons.close,
          color: Colors.red,
        ),
        label: Text('RELOAD'));
  }

  ReloadButton({VoidCallback onPressed}) : _onPressed = onPressed;
}
