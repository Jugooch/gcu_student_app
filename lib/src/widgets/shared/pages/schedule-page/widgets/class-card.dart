import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClassCard extends StatelessWidget {
  final User user;
  final Classes classes;

  ClassCard({
    required this.user,
    required this.classes,
    Key? key,
  }) : super(key: key);

  //function to format the dates from the class data to a more readable format
  //uses the helper methods below
  String _formatDates() {
    String daysString = _getShortenedDays(classes.days);
    String startTimeFormatted = _formatTime(classes.startTime);
    String endTimeFormatted = _formatTime(classes.endTime);

    return '$daysString at $startTimeFormatted - $endTimeFormatted';
  }

  //helper function to change the ISO date format to be more readable
  //https://www.flutterbeads.com/format-datetime-in-flutter/#:~:text=To%20DateFormat%20or%20DateTime%20Format%20in%20Flutter%20using,the%20format%20%28%29%20method%20with%20providing%20the%20DateTime.
  String _formatTime(String time) {
    final timeFormat = DateFormat('h:mm a');
    DateTime dateTime = DateTime(2000, 1, 1, int.parse(time.split(':')[0]), int.parse(time.split(':')[1]));

    return timeFormat.format(dateTime);
  }

  //helper function to change the Full day names into shortened versions
  String _getShortenedDays(List<String> days) {
    Map<String, String> dayAbbreviations = {
      'Monday': 'Mon',
      'Tuesday': 'Tue',
      'Wednesday': 'Wed',
      'Thursday': 'Thu',
      'Friday': 'Fri',
      'Saturday': 'Sat',
      'Sunday': 'Sun',
    };

    return days.map((day) => dayAbbreviations[day] ?? day).join('/');
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return InkWell(
      onTap: () {
        // Logic to open subpage for the card clicked
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => DetailedPage(user: user, account: account,)),
        // );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppStyles.getCardBackground(themeNotifier.currentMode),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppStyles.darkBlack.withOpacity(.12),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classes.id,
                  style: TextStyle(
                      color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  classes.name,
                  style: TextStyle(
                      color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 4),
                Text(
                  _formatDates(),
                  style: TextStyle(
                      color: AppStyles.getTextTertiary(themeNotifier.currentMode),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppStyles.getInactiveIcon(themeNotifier.currentMode),
                size: 24)
          ],
        ),
      ),
    );
  }
}
