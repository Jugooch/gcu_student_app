import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChapelCard extends StatelessWidget {
  final User user;
  final Chapel chapel;

  ChapelCard({
    required this.user,
    required this.chapel,
    Key? key,
  }) : super(key: key);

  _formatDate(DateTime date){
    //format date here to make more user friendly
    return DateFormat('EEEE MM/dd/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
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
                  chapel.speaker,
                  style: TextStyle(
                      color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  chapel.church,
                  style: TextStyle(
                      color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 4),
                Text(
                  _formatDate(chapel.date),
                  style: TextStyle(
                      color: AppStyles.getTextTertiary(themeNotifier.currentMode),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            ///////////////////////////////////////////////////////////////////
            ///Update to show chapels that have been checked into
            ///////////////////////////////////////////////////////////////////
            Icon(Icons.chevron_right_rounded,
                color: AppStyles.getInactiveIcon(themeNotifier.currentMode),
                size: 24)
            ///////////////////////////////////////////////////////////////////
          ],
        ),
    );
  }
}
