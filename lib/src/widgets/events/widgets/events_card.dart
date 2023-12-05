import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';

class EventCard extends StatefulWidget {
  
  //pass in an event object
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  _EventCard createState() => _EventCard();
}

class _EventCard  extends State<EventCard> {

///////////////////////
  //Main Widget
///////////////////////
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(widget.event.title, style: TextStyle(),),
          Text(formatDate(), style: TextStyle(fontSize: 16, color: AppStyles.getTextTertiary(ThemeNotifier().currentMode), fontWeight: FontWeight.w200),),
        ],
      )
    );
  }
  
///////////////////////
  //Helper Methods
///////////////////////

//formats the date/time object from the data into a more legible format
  formatDate () {
    var time;
    var day = widget.event.date.weekday.toString();
    var date = '${widget.event.date.month}/${widget.event.date.day}/${widget.event.date.year}';

    if(widget.event.date.hour > 12){
      time = '${widget.event.date.hour-12}:00pm';
    }
    else if(widget.event.date.hour == 12){
      time = '${widget.event.date.hour}:00pm';
    }
    else{
      time = '${widget.event.date.hour}:00am';
    }

    var formattedDate = '$day $date ' + time; 

    return formattedDate;
  }
}
