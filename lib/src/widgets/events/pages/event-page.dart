import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/expandable-text/expandable_text.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../services/services.dart';
import '../widgets/events_card.dart';

class EventPage extends StatelessWidget {
  final Event event;
  final List<Event> otherEvents;
  const EventPage({required this.event, required this.otherEvents, Key? key})
      : super(key: key);

  _formatDate(DateTime dateTime) {
    //Date formatter
    final DateFormat formatter = DateFormat('EEEE, MM/dd/yyyy \'at\' h:mma');

    // Apply the format to the DateTime
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        border: null,
        backgroundColor: AppStyles.getPrimary(themeNotifier.currentMode),
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 32),
            Image.asset(
              'assets/images/GCU_Logo.png',
              height: 32.0,
            ),
          ],
        ),
      ),
        backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Container(
                height: 240,
                width: double.infinity,
                child: ClipRRect(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppStyles.getPrimaryDark(themeNotifier.currentMode)
                          .withOpacity(0.3),
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      event.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              CustomBackButton(),
            ]),
            Container(
                decoration: BoxDecoration(
                  color: AppStyles.getCardBackground(themeNotifier.currentMode),
                  boxShadow: [
                    BoxShadow(
                      color: AppStyles.getBlack(themeNotifier.currentMode)
                          .withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title,
                        style: TextStyle(
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                    SizedBox(height: 16),
                    Text(_formatDate(event.date),
                        style: TextStyle(
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                            fontSize: 14,
                            fontWeight: FontWeight.w300)),
                    SizedBox(height: 16),
                    ExpandableText(text: event.description),
                  ],
                )),
            SizedBox(height: 32),
            Container(padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Other Events',
              style: TextStyle(
                color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ),        
            SizedBox(height: 8),  
            SideScrollingWidget(
              children: otherEvents
                  // Filter out the current event
                  .where((e) => e != event)
                  .map((e) => EventCard(
                        event: e,
                        otherEvents: otherEvents,
                      ))
                  // Convert the result to a list
                  .toList(),
            )
          ],
        )));
  }
}
