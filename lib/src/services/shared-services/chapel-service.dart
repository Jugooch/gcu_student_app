import 'dart:convert';
import 'package:flutter/services.dart';

class ChapelService {
  Future<List<Chapel>> getChapels() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/chapel-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<Chapel> chapels = jsonList.map((jsonItem) {
        return Chapel.fromJson(jsonItem);
      }).toList();

      return chapels;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [];
    }
  }
}

class Chapel {
  String id;
  String speaker;
  String church;
  DateTime date;

  Chapel({
    required this.id,
    required this.speaker,
    required this.church,
    required this.date,
  });

  factory Chapel.fromJson(Map<String, dynamic> json) {
    return Chapel(
      id: json['id'],
      speaker: json['speaker'],
      church: json['church'],
      date: DateTime.parse(json['date']),
    );
  }
}
