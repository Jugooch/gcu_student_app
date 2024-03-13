import 'dart:convert';

import 'package:flutter/services.dart';

import '../services.dart';

class ClubsService {
  Future<List<Club>> getClubs(user) async {
    // Filter the clubs to return only those that the user has not joined
        final String response =
        await rootBundle.loadString('assets/data/clubs-data.json');
    final data = json.decode(response);

    // Assuming `data` represents a list of teams
    List<Club> clubs = (data as List)
        .map((i) => Club.fromJson(i))
        .where((club) => !club.members.any((member) => member.id == user.id))
        .toList();

    return clubs;
  }

  Future<List<Club>> getUserClubs(user) async {
    // Filter the clubs to return only those that the user has not joined
        final String response =
        await rootBundle.loadString('assets/data/clubs-data.json');
    final data = json.decode(response);

    // Assuming `data` represents a list of teams
    List<Club> clubs = (data as List)
        .map((i) => Club.fromJson(i))
        .where((i) => i.members.any((member) => member.id == user.id))
        .toList();

    return clubs;
  }

  Future<List<Event>> getClubEvents(club) async {
// Filter the clubs to return only those that the user has not joined
        final String response =
        await rootBundle.loadString('assets/data/club-events-data.json');
    final data = json.decode(response);

    // Assuming `data` represents a list of teams
    List<Event> events = (data as List)
        .map((i) => Event.fromJson(i))
        .where((i) => i.clubId == club.id)
        .toList();

    return events;
  }
}


class Club {
  int id;
  String name;
  String image;
  List<Member> members;
  Member owner;
  String description;

  Club({
    required this.id,
    required this.name,
    required this.image,
    required this.members,
    required this.owner,
    required this.description
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    //take in list of members from json
    var membersList = json['members'] as List;
    List<Member> members = membersList.map((i) => Member.fromJson(i)).toList();

    var _owner = json['owner'];
    Member owner = Member.fromJson(_owner);
    return Club(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      members: members,
      owner: owner,
      description: json['description']
    );
  }
}