import 'package:gcu_student_app/src/widgets/events/widgets/main_article.dart';
import '../shared/side_scrolling/side_scrolling.dart';
import 'package:flutter/material.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<EventsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null,
      body:
        SideScrollingWidget(
          children: [
            MainArticleButton(),
            MainArticleButton(),
            MainArticleButton(),
          ],
      ),
    );
  }
}