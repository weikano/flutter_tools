import 'package:flutter/material.dart';

final ThemeData kLightTheme = _buildLightTheme();
final ThemeData kDarkTheme = _buildDarkTheme();

ThemeData _buildDarkTheme() {
  const Color primaryColor = Color(0xFF0175c2);
  const Color secondaryColor = Color(0xFF13B9FD);
  final ThemeData base = ThemeData.dark();
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  return base.copyWith(
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    accentColor: secondaryColor,
    canvasColor: const Color(0xFF202124),
    scaffoldBackgroundColor: const Color(0xFF202124),
    backgroundColor: const Color(0xFF202124),
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

ThemeData _buildLightTheme() {
  const Color primaryColor = Color(0xFF0175c2);
  const Color secondaryColor = Color(0xFF13B9FD);
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    splashColor: Colors.white24,
    splashFactory: InkRipple.splashFactory,
    accentColor: secondaryColor,
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
//		title: base.title.copyWith(
//			fontFamily: 'GoogleSans',
//		),
      );
}
