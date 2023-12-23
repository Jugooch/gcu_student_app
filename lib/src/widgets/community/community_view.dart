import 'package:flutter/material.dart';
import './pages/pages.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<CommunityView> {


///////////////////////
  //Properties
/////////////////////// 

// Default page identifier
  String currentPage = 'main';
  final Map<String, Widget> pages = {
    'main': const MainPage(),
    'calendar': const ClubsPage(),
    'event': const IntramuralsPage(),
    'article': const MarketPage(),
  };


///////////////////////
  //Main Widget
///////////////////////
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