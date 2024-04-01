import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _eventsCollection = 'events';
  final String _newsCollection = 'news';

class EventsService {
///////////////////////
  //Getter Functions
///////////////////////

  //Return all the articles from the data
  Future<List<Article>> getArticles() async {
    try {
      // Use rootBundle to access files included with the app
      String jsonString =
          await rootBundle.loadString('assets/data/articles-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<Article> articles = jsonList.map((jsonItem) {
        return Article(
            title: jsonItem['title'],
            author: jsonItem['author'],
            content: jsonItem['content'],
            image: jsonItem['image'],
            date: DateTime.parse(jsonItem['date']));
      }).toList();

      return articles;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [];
    }
  }

  Future<void> addArticle(Map<String, dynamic> data) async {
    await _db.collection(_newsCollection).add(data);
  }

  // Return all the events from the data
  Future<List<Event>> getEvents() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/events-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Use Event.fromJson factory method
      List<Event> events =
          jsonList.map((jsonItem) => Event.fromJson(jsonItem)).toList();

      return events;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [];
    }
  }

  Future<List<Event>> getMajorEvents() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/events-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      // Directly filter and map only major events using Event.fromJson
      List<Event> majorEvents = jsonList
          .where((jsonItem) => jsonItem['major'] == true)
          .map((jsonItem) => Event.fromJson(jsonItem))
          .toList();

      return majorEvents;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [];
    }
  }

  Future<bool> isUserAdmin(user) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/news-admin-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      if (jsonList.any((e) => e['id'] == user.id)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error reading JSON file: $e");
      return false;
    }
  }


}

//Article Object
class Article {
  final String title;
  final String author;
  final String content;
  final String image;
  final DateTime date;

  Article(
      {required this.title,
      required this.author,
      required this.content,
      required this.image,
      required this.date});

      Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'content': content,
    'image': image,
    // Convert DateTime to a string or timestamp as required
    'date': date.toIso8601String(), // Example using ISO 8601 format
  };
}

//Event Object
class Event {
  String? id;
  final String title;
  final DateTime date;
  final String description;
  final String image;
  final bool major;
  final String location;
  final String clubId;
  bool weekly;

  Event(
      {
      this.id,
      required this.title,
      required this.date,
      required this.description,
      required this.image,
      required this.major,
      required this.location,
      required this.clubId,
      required this.weekly});

       Map<String, dynamic> toJson() => {
    'id': id, // Add id to the JSON output if it's not null
    'title': title,
    'date': date.toIso8601String(), // Serialize DateTime as a string
    'description': description,
    'image': image,
    'major': major,
    'location': location,
    'clubId': clubId,
    'weekly': weekly,
  };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        title: json['title'],
        date: DateTime.parse(json['date']),
        description: json['description'],
        image: json['image'],
        major: json['major'],
        location: json['location'],
        clubId: json['clubId'],
        weekly: json['weekly']);
  }
}
