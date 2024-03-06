import 'dart:convert';

import 'package:flutter/services.dart';

import '../services.dart';

class IntramuralService {
  Future<List<League>> getLeagues(user) async {
    final String response =
        await rootBundle.loadString('assets/data/intramural-leagues-data.json');
    final data = await json.decode(response);
    List<League> leagues =
        (data as List).map((i) => League.fromJson(i)).toList();

    List<Team> teams = await getTeams(user);

    print(teams.length);

// Filter the leagues to return only those that the user has not joined
    List<League> unjoinedLeagues = leagues.where((league) {
      // Check if the user is in a league of the same sport and division
      for (var team in teams) {
        bool isSameSport = league.sport ==
            team.league.split(
                " - ")[0]; // Assuming league name format is "Sport - Division"
        bool isGenderDivision = (league.league.contains("Men") ||
                league.league.contains("Women")) &&
            (team.league.contains("Men") || team.league.contains("Women"));
        bool isMixedDivision =
            league.league.contains("Mixed") && team.league.contains("Mixed");

        if (isSameSport && (isGenderDivision || isMixedDivision)) {
          return false; // Exclude league
        }
      }
      return true; // Include league if none of the conditions above are met
    }).toList();

    return unjoinedLeagues;
  }

  Future<League> getLeague(leagueName) async {
    final String response =
        await rootBundle.loadString('assets/data/intramural-leagues-data.json');
    final data = await json.decode(response);
    League league = (data as List)
        .map((i) => League.fromJson(i))
        .singleWhere((element) => element.league == leagueName);

    return league;
  }

  Future<List<Team>> getTeams(User user) async {
    final String response =
        await rootBundle.loadString('assets/data/intramural-data.json');
    final data = json.decode(response);

    // Assuming `data` represents a list of teams
    List<Team> teams = (data as List)
        .map((i) => Team.fromJson(i))
        .where((team) => team.members.any((member) => member.id == user.id))
        .toList();

    return teams;
  }

  Future<List<Team>> getLeagueTeams(League league) async {
    final String response =
        await rootBundle.loadString('assets/data/intramural-data.json');
    final data = json.decode(response);

    // find the teams for the specified league that are looking for members
    List<Team> teams = (data as List)
        .map((i) => Team.fromJson(i))
        .where((team) => team.league == league.league && !team.inviteOnly)
        .toList();

    return teams;
  }

  Future<Team> getTeam(String teamName) async {
    final String response =
        await rootBundle.loadString('assets/data/intramural-data.json');
    final data = json.decode(response);

    // Assuming `data` represents a list of teams
    Team? team = (data as List)
        .map<Team>((i) => Team.fromJson(i))
        .firstWhere((team) => team.teamName == teamName);

    return team;
  }

  Future<void> createTeam(Team newTeam) async {
    //here is where the team would be added if the app wasnt using mock data
  }

  Future<List<QuizQuestion>> getQuizQuestions(String sport) async {
    // Load the string from assets
    final String response =
        await rootBundle.loadString('assets/data/intramural-quiz-data.json');
    final data = await json.decode(response);

    // Convert the JSON data to a list of QuizQuestion objects
    List<QuizQuestion> questions =
        (data as List).map((i) => QuizQuestion.fromJson(i)).toList();

    // Filter for generic questions and questions for the specified sport
    List<QuizQuestion> filteredQuestions = questions.where((question) {
      return question.sport == 'generic' ||
          question.sport.toLowerCase() == sport.toLowerCase();
    }).toList();

    // Replace "SPORT" in question text with the specified sport for generic questions
    filteredQuestions.forEach((question) {
      if (question.sport == 'generic') {
        question.question = question.question.replaceAll('SPORT', sport);
      }
    });

    return filteredQuestions;
  }
}

class League {
  final String sport;
  final String league;
  final DateTime seasonStart;
  final DateTime seasonEnd;
  final int? maxTeams;
  final int maxRoster;
  final int minRoster;

  League({
    required this.sport,
    required this.league,
    required this.seasonStart,
    required this.seasonEnd,
    this.maxTeams,
    required this.maxRoster,
    required this.minRoster,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      sport: json['sport'],
      league: json['league'],
      seasonStart: DateTime.parse(json['season-start']),
      seasonEnd: DateTime.parse(json['season-end']),
      maxTeams: json['max-teams'],
      maxRoster: json['max-roster'],
      minRoster: json['min-roster'],
    );
  }
}

class Team {
  String league;
  String teamName;
  List<Member> members;
  Member captain;
  int sportsmanship;
  List<Game> games;
  String image;
  bool autoAcceptMembers;
  bool inviteOnly;

  Team(
      {required this.league,
      required this.teamName,
      required this.members,
      required this.captain,
      required this.sportsmanship,
      required this.games,
      required this.image,
      required this.autoAcceptMembers,
      required this.inviteOnly});

  factory Team.fromJson(Map<String, dynamic> json) {
    //take in list of members from json
    var membersList = json['members'] as List;
    List<Member> members = membersList.map((i) => Member.fromJson(i)).toList();

    var _captain = json['captain'];
    Member captain = Member.fromJson(_captain);

    //take in list of games from json
    var gamesList = json['games'] as List;
    List<Game> games = gamesList.map((i) => Game.fromJson(i)).toList();

    return Team(
        league: json['league'],
        teamName: json['team-name'],
        members: members,
        captain: captain,
        sportsmanship: json['sportsmanship'],
        games: games,
        image: json["image"],
        autoAcceptMembers: json['auto-accept-members'],
        inviteOnly: json['invite-only']);
  }
}

class Member {
  final String id;
  final String name;
  final DateTime joinDate;

  Member({
    required this.id,
    required this.name,
    required this.joinDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      joinDate: DateTime.parse(json['join-date']),
    );
  }
}

class Game {
  final DateTime date;
  final String home;
  final String away;
  final String result;
  final String location;

  Game(
      {required this.date,
      required this.home,
      required this.away,
      required this.result,
      required this.location});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
        date: DateTime.parse(json['date']),
        home: json['home'],
        away: json['away'],
        result: json['result'],
        location: json['location']);
  }
}

class QuizQuestion {
  String sport;
  String question;
  List<String> choices;
  String answer;

  QuizQuestion({
    required this.sport,
    required this.question,
    required this.choices,
    required this.answer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      sport: json['sport'],
      question: json['question'],
      choices: List<String>.from(json['choices']),
      answer: json['answer'],
    );
  }
}
