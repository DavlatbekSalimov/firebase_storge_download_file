import 'package:flutter/material.dart';

class Providerr extends ChangeNotifier {
  int count = 0;

  void addd() {
    count++;
    notifyListeners();
  }

  void removv() {
    count--;
    notifyListeners();
  }
}

class ThemController with ChangeNotifier {
  ThemeMode them = ThemeMode.system;

  void changeGtheme() {
    if (them == ThemeMode.light) {
      them = ThemeMode.dark;
    } else {
      them = ThemeMode.light;
    }
    notifyListeners();
  }
}
