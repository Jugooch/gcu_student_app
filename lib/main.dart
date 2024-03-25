import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import './src/current_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  final ThemeNotifier themeNotifier = ThemeNotifier();
  final NavigationNotifier navigationNotifier = NavigationNotifier();


  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // themeNotifier for changes
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeNotifier),
        ChangeNotifierProvider(create: (context) => NavigationNotifier()),
      ],
      child: MyApp(
        settingsController: settingsController,
        themeNotifier: themeNotifier,
        navigationNotifier: navigationNotifier,
      ),
    ),
  );
}