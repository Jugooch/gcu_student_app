import 'package:flutter/material.dart';
import './pages/main.dart';
import '../shared/pages/pages.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  String currentPage = 'main'; // Default page identifier
  final Map<String, Widget> pages = {
    'main': const MainPage(),
    'hours': const HoursPage(),
    'card-accounts': const CardAccountsPage(),
    'chapel': const ChapelPage(),
    'map': const MapPage(),
    'schedule': const SchedulePage(),
    'settings': const SettingsPage()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: pages[currentPage] ?? Container(), // Display the current page
      ),
    );
  }
}