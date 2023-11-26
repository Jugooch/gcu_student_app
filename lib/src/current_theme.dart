import 'package:flutter/material.dart';

import 'app_styling.dart';

class AppModeManager {
  static final AppModeManager _instance = AppModeManager._internal();

  factory AppModeManager() {
    return _instance;
  }

  AppMode _currentMode = AppMode.light;

  AppMode get currentMode => _currentMode;

  set currentMode(AppMode mode) {
    _currentMode = mode;
    // Add any logic you need to handle mode changes globally
  }

  AppModeManager._internal();

  
  void initialize() {
    // Add any initialization logic here if needed
  }
}

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