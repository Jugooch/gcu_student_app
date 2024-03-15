import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/events/pages/event-page.dart';
import 'package:provider/provider.dart';

class CondensedEventCard extends StatefulWidget {
  //pass in an event object
  final Event event;
  final List<Event> otherEvents;

  const CondensedEventCard({Key? key, required this.event, required this.otherEvents})
      : super(key: key);

  @override
  _CondensedEventCard createState() => _CondensedEventCard();
}

class _CondensedEventCard extends State<CondensedEventCard> {
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
                MaterialPageRoute(
                    builder: (context) => EventPage(
                          event: widget.event,
                          otherEvents: widget.otherEvents,
                        )),
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
                color: AppStyles.getBlack(themeNotifier.currentMode)
                    .withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(widget.event.image)),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode)),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        formatDate(),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppStyles.getTextTertiary(
                              themeNotifier.currentMode),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ],
              )),
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
