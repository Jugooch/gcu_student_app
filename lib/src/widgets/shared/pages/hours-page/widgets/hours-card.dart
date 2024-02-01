import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/pages/hours-page/widgets/vendor-details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//Card to display the hours of a vendor
class HoursCard extends StatelessWidget {
  final Vendor vendor;

  HoursCard({
    required this.vendor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    //this method formats the daily hours into a more User-friendly way
    //it returns a rich text widget which allows more control over the text inside
    RichText _formatHours(DailyHours dailyHours) {
      DateTime now = DateTime.now();
      String dayOfWeek = DateFormat('EEEE').format(now);
      if (dailyHours.day == dayOfWeek) {
        DateTime openTime = DateFormat('HH:mm:ss').parse(dailyHours.openTime);
        DateTime closeTime = DateFormat('HH:mm:ss').parse(dailyHours.closeTime);
        DateTime openDateTime = DateTime(
            now.year, now.month, now.day, openTime.hour, openTime.minute);
        DateTime closeDateTime = DateTime(
            now.year, now.month, now.day, closeTime.hour, closeTime.minute);

        //this logic finds whether the vendor is closed or open currently
        //then bolds that and displays when next open or when closing
        if (now.isAfter(openDateTime) && now.isBefore(closeDateTime)) {
          return RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                    text: 'Open Now',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppStyles.getTextPrimary(
                            themeNotifier.currentMode))),
                TextSpan(
                    text:
                        ' until ' + DateFormat('h:mm a').format(closeDateTime),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: AppStyles.getTextPrimary(
                            themeNotifier.currentMode))),
              ],
            ),
          );
        } else {
          return RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                    text: "Closed",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppStyles.getTextPrimary(
                            themeNotifier.currentMode))),
                TextSpan(
                    text: 'until ' + DateFormat('h:mm a').format(openDateTime),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: AppStyles.getTextPrimary(
                            themeNotifier.currentMode))),
              ],
            ),
          );
        }
      }
      //A default return for if the others fail.
      return RichText(
          text: TextSpan(
              text: 'Closed', style: DefaultTextStyle.of(context).style));
    }

    DailyHours todayHours = vendor.hours.days.firstWhere((dailyHours) =>
        dailyHours.day == DateFormat('EEEE').format(DateTime.now()));

    RichText status = _formatHours(todayHours);

    return InkWell(
        onTap: () {
          //logic to open subpage for the card clicked
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VendorDetailsPage(
                    vendor: vendor,
                    status: status),
              ));
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 16.0),
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
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(vendor.image),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendor.name,
                      style: TextStyle(
                          color: AppStyles.getTextPrimary(
                              themeNotifier.currentMode),
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.0),
                  Text(vendor.location,
                      style: TextStyle(
                          color: AppStyles.getTextPrimary(
                              themeNotifier.currentMode),
                          fontSize: 16,
                          fontWeight: FontWeight.w300)),
                  SizedBox(height: 8.0),
                  todayHours != null
                      ? _formatHours(todayHours)
                      : Text('Hours not available'),
                ],
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 24,
                  color: AppStyles.getInactiveIcon(themeNotifier.currentMode)),
            ],
          ),
        ));
  }
}
