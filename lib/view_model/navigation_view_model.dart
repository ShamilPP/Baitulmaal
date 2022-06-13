import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentBottomNavigator = 2;

  int get currentBottomNavigator => _currentBottomNavigator;

  setCurrentBottomNavigator(int value) {
    _currentBottomNavigator = value;
    notifyListeners();
  }
}
