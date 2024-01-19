import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';

import 'settings/settings_controller.dart';
import 'widgets/home/home_view.dart';
import 'widgets/events/events_view.dart';
import 'widgets/community/community_view.dart';
import 'widgets/profile/profile_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
    required this.themeNotifier,
    required this.navigationNotifier,
  });

  final SettingsController settingsController;
  final ThemeNotifier themeNotifier;
  final NavigationNotifier navigationNotifier;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    //   // Intentional error for testing error handling
    // String? text = null;
    // print(text!.length);  // This will throw an exception
    return MaterialApp(
      builder: (context, child) {
        // Define the custom error widget with an asset image and text
        Widget error = Container(
          decoration: BoxDecoration(color: AppStyles.getBackground(widget.themeNotifier.currentMode)),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/ErrorImage.png', width: 100),
              const SizedBox(height: 16),
              Text(
                'There was an error,\nPlease Try Again',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppStyles.getTextPrimary(widget.themeNotifier.currentMode),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              )
            ],
          ),
        );

        // Set the global ErrorWidget builder to use the defined error widget
        ErrorWidget.builder = (errorDetails) => error;

        // If the original widget is not null, return it
        if (child != null) return child;

        // If the original widget is null, throw a StateError
        throw StateError('widget is null');
      },
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: widget.settingsController.themeMode,
      home: CupertinoTabScaffold(
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              // Set the context when building the widget
              widget.navigationNotifier.setSubpagesContext(context);

              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  border: null,
                  backgroundColor:
                      AppStyles.getPrimary(widget.themeNotifier.currentMode),
                  middle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 24),
                      Image.asset(
                        'assets/images/GCU_Logo.png',
                        height: 32.0,
                      ),
                    ],
                  ),
                ),
                child: _getPage(index),
              );
            },
          );
        },
        tabBar: CupertinoTabBar(
          currentIndex: widget.navigationNotifier.selectedIndex,
          backgroundColor:
              AppStyles.getPrimary(widget.themeNotifier.currentMode),
          activeColor: AppStyles.getNavIconActive(
              widget.themeNotifier.currentMode),
          inactiveColor: AppStyles.getNavIconInactive(
              widget.themeNotifier.currentMode),
          onTap: (index) {
            widget.navigationNotifier.updateIndex(index);
          },
          items: List.generate(4, (index) {
            return BottomNavigationBarItem(
              icon: Icon(_icons[index]),
              label: _labels[index],
            );
          }),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Listen to changes in selectedIndex and popUntilRoot if needed
    widget.navigationNotifier.addListener(_onNavigationChange);
  }

  @override
  void dispose() {
    // Remove the listener to avoid memory leaks
    widget.navigationNotifier.removeListener(_onNavigationChange);
    super.dispose();
  }

  void _onNavigationChange() {
    widget.navigationNotifier.popUntilRoot();
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return EventsView();
      case 2:
        return CommunityView();
      case 3:
        return ProfileView();
      default:
        return Container();
    }
  }

  // Define your icons and labels for the tabs.
  final List<IconData> _icons = [
    Icons.home,
    Icons.event,
    Icons.group,
    Icons.person
  ];
  final List<String> _labels = ['Home', 'Events', 'Community', 'Profile'];
}
