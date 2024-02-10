import 'dart:convert';

import 'package:flutter/services.dart';

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

  //Return all th events from the data
  Future<List<Event>> getEvents() async {
    try {
      // Use rootBundle to access files included with the app
      String jsonString =
          await rootBundle.loadString('assets/data/events-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<Event> events = jsonList.map((jsonItem) {
        return Event(
            title: jsonItem['title'],
            date: DateTime.parse(jsonItem['date']),
            description: jsonItem['description'],
            image: jsonItem['image'],
            major: jsonItem['major']);
      }).toList();

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

      // Directly filter and map only major events from the JSON list
      List<Event> majorEvents = jsonList
          .where((jsonItem) => jsonItem['major'] == true)
          .map((jsonItem) {
        return Event(
          title: jsonItem['title'],
          date: DateTime.parse(jsonItem['date']),
          description: jsonItem['description'],
          image: jsonItem['image'],
          major: jsonItem['major'],
        );
      }).toList();

      return majorEvents;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [];
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
}

//Event Object
class Event {
  final String title;
  final DateTime date;
  final String description;
  final String image;
  final bool major;

  Event(
      {required this.title,
      required this.date,
      required this.description,
      required this.image,
      required this.major});
}
