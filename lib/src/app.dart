import 'package:gcu_student_app/src/widgets/shared/header/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

import 'widgets/shared/navbar/navbar.dart';
import 'widgets/home/home_view.dart';
import 'widgets/events/events_view.dart';
import 'widgets/community/community_view.dart';
import 'widgets/profile/profile_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, 
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final List<Widget> screens = [
    const HomeView(),
    const EventsView(),
    const CommunityView(),
    const ProfileView(),
    // Add your Community and Profile screens here
    // For example: CommunityScreen() and ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
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
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: widget.settingsController);
                  case SampleItemDetailsView.routeName:
                    return const SampleItemDetailsView();
                  case SampleItemListView.routeName:
                    return const SampleItemListView();
                  default:
                    return const SampleItemListView();
                }
              },
            );
          },
          home: Scaffold(
            appBar: const PreferredSize(
          preferredSize: Size.fromHeight(64),
          child: Header(),
          ),
            body: screens[_selectedIndex],
            bottomNavigationBar: NavBar(onItemTapped: _onItemTapped),
          ),
        );
      },
    );
  }
}
