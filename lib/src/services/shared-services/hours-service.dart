import 'dart:convert';
import 'package:flutter/services.dart';

class HoursService {
  Future<List<Vendor>> getVendors() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/hours-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<Vendor> vendors = jsonList.map((jsonItem) {
        return Vendor.fromJson(jsonItem);
      }).toList();

      print(vendors.length);
      return vendors;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [];
    }
  }
}

class Vendor {
  String id;
  String name;
  String location;
  Hours hours;
  String image;
  String category;
  String description;

  Vendor({
    required this.id,
    required this.name,
    required this.location,
    required this.hours,
    required this.image,
    required this.category,
    required this.description
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      hours: Hours.fromJson(json['hours']),
      image: json['image'],
      category: json['category'],
      description: json['description']
    );
  }
}


//Class Objects
class Hours {
  List<DailyHours> days;

  Hours({required this.days});

  factory Hours.fromJson(Map<String, dynamic> json) {
    var list = json['days'] as List;
    List<DailyHours> daysList = list.map((i) => DailyHours.fromJson(i)).toList();
    return Hours(days: daysList);
  }
}

class DailyHours {
  String day;
  String openTime;
  String closeTime;

  DailyHours({
    required this.day,
    required this.openTime,
    required this.closeTime,
  });

  factory DailyHours.fromJson(Map<String, dynamic> json) {
    return DailyHours(
      day: json['day'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
    );
  }
}
