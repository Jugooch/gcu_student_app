import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../services.dart';

class ClassService {
  Future<List<Classes>> getUserClasses(User user) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/classes-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<Classes> classes = jsonList.map((jsonItem) {
        Classes classInstance = Classes(
          id: jsonItem['id'],
          name: jsonItem['name'],
          days: List<String>.from(jsonItem['days']),
          startTime: jsonItem['startTime'],
          endTime: jsonItem['endTime'],
        );

        // Call the method to update the next occurrence
        classInstance.updateNextOccurrence();

        return classInstance;
      }).toList();

      return classes;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [
        Classes(id: "", name: "", days: [''], startTime: "", endTime: "")
      ];
    }
  }
}

//Class Object
class Classes {
  String id;
  String name;
  List<String> days;
  String startTime;
  String endTime;
  DateTime nextOccurrence = DateTime.now();

  Classes({
    required this.id,
    required this.name,
    required this.days,
    required this.startTime,
    required this.endTime,
  });

  // Update the return type of the method
  DateTime updateNextOccurrence() {
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);

    DateTime mostRecentOccurrence = DateTime(2000, 1, 1);

    // Replace the existing code block
    for (String day in days) {
      int targetWeekday = parseWeekday(day);
      int daysUntilNextOccurrence =
          (targetWeekday - currentDate.weekday + 7) % 7;

      if (daysUntilNextOccurrence == 0) {
        DateTime classStartTime = parseTime(startTime);
        DateTime occurrence =
            currentDate.add(Duration(days: daysUntilNextOccurrence));
        if (classStartTime.isAfter(now) &&
            occurrence.isAfter(mostRecentOccurrence)) {
          mostRecentOccurrence = occurrence;
        }
      } else {
        DateTime occurrence =
            currentDate.add(Duration(days: daysUntilNextOccurrence));
        DateTime classStartTime = parseTime(startTime);
        if (occurrence.isAfter(mostRecentOccurrence)) {
          mostRecentOccurrence = occurrence;
        }

        // Update the time components of mostRecentOccurrence
        mostRecentOccurrence = DateTime(
          mostRecentOccurrence.year,
          mostRecentOccurrence.month,
          mostRecentOccurrence.day,
          classStartTime.hour,
          classStartTime.minute,
          classStartTime.second,
        );
      }
    }

    nextOccurrence = mostRecentOccurrence;

    return mostRecentOccurrence;
  }

  // Helper function to create a map with the days and their respective weekday ints
  int parseWeekday(String day) {
    // Map weekdays to corresponding integers (Monday = 1, Tuesday = 2, ..., Sunday = 7)
    Map<String, int> weekdayMap = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };
    return weekdayMap[day]!;
  }

  // Helper function to parse time
  DateTime parseTime(String time) {
    final timeFormat = DateFormat.Hms(); // 24-hour format
    DateTime dateTime = timeFormat.parse(time);
    return DateTime(
        2000, 1, 1, dateTime.hour, dateTime.minute, dateTime.second);
  }
}
