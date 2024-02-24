import 'dart:convert';
import 'package:flutter/services.dart';

class MapService{
  Future<List<MapBuilding>> getBuildings() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/buildings-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<MapBuilding> buildings = jsonList.map((jsonItem) {
        return MapBuilding.fromJson(jsonItem);
      }).toList();

      return buildings;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [];
    }
  }
}

class MapBuilding {
  String id;
  String name;
  String description;
  List<String> includes;
  double latitude;
  double longitude;
  List<String> type;

  // Constructor
  MapBuilding({
    required this.id,
    required this.name,
    required this.description,
    required this.includes,
    required this.latitude,
    required this.longitude,
    required this.type
  });

  // fromJson constructor
  factory MapBuilding.fromJson(Map<String, dynamic> json) {
    return MapBuilding(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      includes: List<String>.from(json['includes']),
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      type: List<String>.from(json['type'])
    );
  }
}
