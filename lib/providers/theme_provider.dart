
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
    useMaterial3: true,
  );

  ThemeData get themeData => _themeData;

  bool get isLightTheme => _themeData.brightness == Brightness.light;

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}