import 'dart:async';

import 'package:flutter/material.dart';

import 'app_styling.dart';

//Keeps track of the current theme of the app
class ThemeNotifier extends ChangeNotifier {
  AppMode _currentMode = AppMode.light;

  AppMode get currentMode => _currentMode;

  set currentMode(AppMode mode) {
    if (_currentMode != mode) {
      _currentMode = mode;
      notifyListeners(); // Notify listeners when the theme changes
    }
  }

  
  void toggleMode() {
    _currentMode = _currentMode == AppMode.light ? AppMode.dark : AppMode.light;
    notifyListeners();
  }
}

class NavigationNotifier extends ChangeNotifier {
  int _selectedIndex = 0;
  BuildContext? subpagesContext;

  int get selectedIndex => _selectedIndex;

  Future<void> updateIndex(int index) async {
    _selectedIndex = index;
    notifyListeners();
  }

  void setSubpagesContext(BuildContext context) {
    subpagesContext = context;
  }

  Future<void> popUntilRoot() {
    if (subpagesContext != null) {
      final completer = Completer<void>();

      Navigator.of(subpagesContext!).popUntil((route) {
        if (route.isFirst) {
          completer.complete(); // Complete the Future when popping is finished
        }
        return route.isFirst;
      });

      return completer.future;
    }

    return Future.value();
  }
}