import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:provider/provider.dart';

import '../widgets/calendar.dart';

class CalendarPage extends StatelessWidget {
  final List<Event> majorEvents;

  const CalendarPage({required this.majorEvents, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: CupertinoNavigationBar(
                  border: null,
                  backgroundColor:
                      AppStyles.getPrimary(themeNotifier.currentMode),
                  middle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
            CustomBackButton(),
            Calendar(majorEvents: majorEvents),
          ]),
        ));
  }
}
