import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';

import 'events_card.dart';

class Calendar extends StatefulWidget {
  final List<Event> majorEvents;
  const Calendar({required this.majorEvents, Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDate = DateTime.now();
  DateTime _calendarDate = DateTime.now();
  List<Event> _eventsForSelectedDay = [];

  @override
  void initState() {
    super.initState();
    // This populates the event box with todays events
    _updateEventsForSelectedDay();
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFF391A69),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${_monthFromNum(_calendarDate.month)}, ${_calendarDate.year}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => {_decrementMonth()},
                          child: Icon(Icons.arrow_left,
                              color: Colors.white, size: 48.0),
                        ),
                        GestureDetector(
                          onTap: () => {_incrementMonth()},
                          child: Icon(Icons.arrow_right,
                              color: Colors.white, size: 48.0),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                      .map((day) => Text(day,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500)))
                      .toList(),
                ),
                Divider(color: Colors.white),
                // I used ChatGPT to help me learn how to use Grids for the Calendar
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // And this one
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                  ),
                  itemCount: _totalCellsCount(_calendarDate),
                  itemBuilder: (context, index) {
                    // Calculate the date for the current cell
                    final date = _dateForCell(index);
                    final isSelected = _isSameDay(_selectedDate, date);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                          // This will trigger the update to show the events for the selected day in the bottom of the page
                          _updateEventsForSelectedDay();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: isSelected
                                ? AppStyles.getPrimary(
                                    themeNotifier.currentMode)
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Inside your Calendar widget's build method, after the GridView...
              ],
            ),
          ),
          SizedBox(height: 32),
          Text(
            'Events',
            style: TextStyle(
              color: AppStyles.getTextPrimary(themeNotifier.currentMode),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          _eventsForSelectedDay.isEmpty
              ? Text(
                  'No events on this day..',
                  style: TextStyle(
                      color:
                          AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                )
              : Column(
                  children: _eventsForSelectedDay
                      .map((e) =>
                          EventCard(event: e, otherEvents: widget.majorEvents))
                      .toList(),
                ),
        ]));
  }

  // Add this method in your _CalendarState
  void _updateEventsForSelectedDay() async {
    List<Event> allEvents = await EventsService().getEvents();
    setState(() {
      _eventsForSelectedDay = allEvents
          .where((event) => _isSameDay(event.date, _selectedDate))
          .toList();
    });
  }

  int _totalCellsCount(DateTime currentDate) {
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    final daysInMonth = lastDayOfMonth.day;
    final trailingDaysOfPrevMonth = (firstDayOfMonth.weekday %
        7); // Assuming week starts on Sunday and weekday is 1-based
    final totalDays = daysInMonth + trailingDaysOfPrevMonth;

    // To ensure we fill the rows of the grid, calculate the remainder of totalDays/7 and subtract from 7 if not 0
    final leadingDaysToNextMonth = totalDays % 7 == 0 ? 0 : 7 - (totalDays % 7);

    return totalDays + leadingDaysToNextMonth;
  }

  DateTime _dateForCell(int index) {
    final firstDayOfMonth =
        DateTime(_calendarDate.year, _calendarDate.month, 1);
    // Adjust based on the start day of the week; this example assumes it starts on Sunday
    int weekDayOfFirstDay = firstDayOfMonth.weekday;
    int startOffset = weekDayOfFirstDay -
        1; // Calculate the offset for the first day of the month
    // Correct for cases where the week starts on Sunday and the first day is Sunday
    startOffset = (weekDayOfFirstDay == 7) ? 0 : startOffset;

    final date = firstDayOfMonth
        .subtract(Duration(days: startOffset))
        .add(Duration(days: index));
    return date;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _monthFromNum(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "Invalid Month";
    }
  }

  _incrementMonth() {
    if (_calendarDate.month != 12) {
      _calendarDate = DateTime(_calendarDate.year, _calendarDate.month + 1);
    } else {
      _calendarDate = DateTime(_calendarDate.year + 1, 1);
    }

    setState(() {});
  }

  _decrementMonth() {
    if (_calendarDate.month != 1) {
      _calendarDate = DateTime(_calendarDate.year, _calendarDate.month - 1);
    } else {
      _calendarDate = DateTime(_calendarDate.year - 1, 12);
    }

    setState(() {});
  }
}
