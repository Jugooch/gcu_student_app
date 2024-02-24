import 'package:flutter/material.dart';
import './pages/main.dart';
import '../shared/pages/pages.dart';

class HomeView extends StatefulWidget {

  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String currentPage = 'main';

  final Map<String, Widget> pages = {
    'main': const MainPage(),
    'hours': const HoursPage(),
    'card-accounts': const CardAccountsPage(),
    'chapel': const ChapelPage(),
    'map': MapPage(),
    'schedule': const SchedulePage(),
    'settings': const SettingsPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: pages[currentPage] ?? Container(),
      ),
    );
  }
}
