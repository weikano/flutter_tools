import 'package:flutter/material.dart';

const normalTextStyle = TextStyle();

var baseTextStyle = normalTextStyle.copyWith(fontFamily: 'poet');

var itemTextStyle = baseTextStyle.copyWith(
  fontSize: 16,
  color: Colors.black45,
);

var sectionTextStyle = baseTextStyle.copyWith(
  fontSize: 18,
  color: Colors.white,
);

var headerBackgroundColor = Color.fromRGBO(222, 222, 222, 1);
