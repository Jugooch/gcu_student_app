import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';

import '../../pages/clubs/edit-event2.dart';

class EditEventCard extends StatefulWidget {
  //pass in an event object
  final Event event;
  final User user;
  final Club club;

  const EditEventCard({Key? key, required this.event, required this.user, required this.club}) : super(key: key);

  @override
  _EventCard createState() => _EventCard();
}

class _EventCard extends State<EditEventCard> {
  ///////////////////////
  //Main Widget
  ///////////////////////
  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return InkWell(
    onTap: () => {
          //logic to open subpage for the Article
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditEventsPage2(user: widget.user, event: widget.event)),
          )
    },
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppStyles.getCardBackground(themeNotifier.currentMode),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppStyles.getBlack(themeNotifier.currentMode).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.event.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppStyles.getTextPrimary(themeNotifier.currentMode)),
            ),
            const SizedBox(height: 8.0),
            Text(
              formatDate(),
              style: TextStyle(
                fontSize: 16,
                color: AppStyles.getTextTertiary(themeNotifier.currentMode),
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 104,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    AppStyles.getPrimaryDark(themeNotifier.currentMode)
                        .withOpacity(0.3), // Adjust opacity as needed
                    BlendMode.srcATop,
                  ),
                  child: Image.network(
                    widget.event.image,
                    fit: BoxFit.cover,
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  ///////////////////////
  //Helper Methods
  ///////////////////////

  //formats the date/time object from the data into a more legible format
  formatDate() {
    String time;
    var day = widget.event.date.weekday.toString();

    switch (day) {
      case "1":
        day = "Monday";
        break;
      case "2":
        day = "Tuesday";
        break;
      case "3":
        day = "Wednesday";
        break;
      case "4":
        day = "Thursday";
        break;
      case "5":
        day = "Friday";
        break;
      case "6":
        day = "Saturday";
        break;
      case "7":
        day = "Sunday";
        break;
      default:
    }

    var date =
        '${widget.event.date.month}/${widget.event.date.day}/${widget.event.date.year}';

    if (widget.event.date.hour > 12) {
      time = '${widget.event.date.hour - 12}:00pm';
    } else if (widget.event.date.hour == 12) {
      time = '${widget.event.date.hour}:00pm';
    } else {
      time = '${widget.event.date.hour}:00am';
    }

    var formattedDate = '$day $date, $time';

    return formattedDate;
  }
}
