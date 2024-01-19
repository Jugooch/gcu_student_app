import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:provider/provider.dart';
import './pages/pages.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

    static CommunityView newInstance() {
      return const CommunityView();
    }

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
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: null,
      backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
      body: Center(
        child: pages[currentPage] ?? Container(), // Display the current page
      ),
    );
  }
}