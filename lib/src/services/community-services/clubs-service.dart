import 'package:cloud_firestore/cloud_firestore.dart';
import '../base-service.dart';
import '../services.dart';

final String _eventsCollection = 'events';
final String _clubsCollection = 'clubs';
final BaseFirestoreService _baseService = BaseFirestoreService();

class ClubsService {
  Future<List<Club>> getClubs(user) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _baseService.getCollection(_clubsCollection).get();
    List<Club> clubs =
        querySnapshot.docs.map((doc) => Club.fromJson(doc.data())).toList();
    return clubs
        .where((club) => !club.members.any((member) => member.id == user.id))
        .toList();
  }

  Future<List<Club>> getUserClubs(user) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _baseService.getCollection(_clubsCollection).get();
    List<Club> clubs = querySnapshot.docs.map((doc) {
      // Create a new Club object from the document data
      var club = Club.fromJson(doc.data());
      // Set the document ID
      club.id = doc.id;
      return club;
    }).toList();

    // Now you can use the `id` field in your comparisons or wherever needed
    return clubs
        .where((i) => i.members.any((member) => member.id == user.id))
        .toList();
  }

  Future<List<Event>> getClubEvents(club) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _baseService.getCollection(_eventsCollection).get();
    List<Event> events = querySnapshot.docs
        .map((doc) {
          // Create a new Event object from the document data
          var event = Event.fromJson(doc.data());
          // Set the document ID
          event.id = doc.id;
          return event;
        })
        .where((event) =>
            event.clubId == club.id &&
            (event.date.isAfter(DateTime.now()) ||
                event.date.isAtSameMomentAs(DateTime.now())))
        .toList();
    return events;
  }

  Future<void> addClub(Club club) async {
    await _baseService.addItem(_clubsCollection, club.toJson());
  }

  Future<void> addEvent(Event event) async {
    await _baseService.addItem(_eventsCollection, event.toJson());
  }

  Future<void> removeClub(Club club) async {
    await _baseService.deleteItem(_clubsCollection, club.id!);
  }

  Future<void> removeEvent(Event event) async {
    await _baseService.deleteItem(_eventsCollection, event.id!);
  }

  Future<List<Event>> getAllClubEvents(club) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _baseService.getCollection(_eventsCollection).get();
    List<Event> events = querySnapshot.docs
        .map((doc) => Event.fromJson(doc.data()))
        .where((i) => i.clubId == club.id)
        .toList();
    return events;
  }

  Future<List<Club>> getFilteredClubs(
      {String category = "All", String search = ""}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _baseService.getCollection(_clubsCollection).get();
    List<Club> clubs =
        querySnapshot.docs.map((doc) => Club.fromJson(doc.data())).toList();
    return clubs.where((club) {
      bool matchesCategory =
          club.categories.contains(category) || category == "All";
      bool matchesSearch = search.isEmpty ||
          club.name.toLowerCase().contains(search.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}

class Club {
  String? id;
  String name;
  String image;
  List<Member> members;
  Member owner;
  String description;
  List<String> categories;
  bool autoAccept;

  Club(
      {this.id,
      required this.name,
      required this.image,
      required this.members,
      required this.owner,
      required this.description,
      required this.categories,
      required this.autoAccept});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'members': members.map((member) => member.toJson()).toList(),
        'owner': owner.toJson(),
        'description': description,
        'categories': categories,
        'auto-accept-members': autoAccept,
      };

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
        description: json['description'],
        categories: List<String>.from(json['categories']),
        autoAccept: json['auto-accept-members']);
  }
}
