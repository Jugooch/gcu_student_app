import 'package:flutter/material.dart';
import './pages/pages.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<EventsView> {


///////////////////////
  //Properties
/////////////////////// 

// Default page identifier
  String currentPage = 'main';
  final Map<String, Widget> pages = {
    'main': const MainPage(),
    'calendar': const CalendarPage(),
    'event': const EventPage(),
    'article': const NewsArticlePage(),
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