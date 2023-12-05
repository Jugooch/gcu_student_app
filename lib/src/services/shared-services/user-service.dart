import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

///////////////////////
  //Getter Methods
///////////////////////

class UserService {
  List<CardAccount> getUserCardAccounts() {
    return [
      CardAccount(name: 'Card 1', balance: 100.0),
      CardAccount(name: 'Card 2', balance: 200.0),
      CardAccount(name: 'Card 3', balance: 300.0),
    ];
  }

  Future<List<Counselor>> getUserCounselors (User user) async{
    try {
      // Use rootBundle to access files included with the app
      String jsonString = await rootBundle.loadString('assets/data/counselor-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<Counselor> counselors = jsonList.map((jsonItem) {
        return Counselor(
          name: jsonItem['icon'],
          id: jsonItem['id'],
          type: jsonItem['type'],
          email: jsonItem['email'],
          phone: jsonItem['phone'],
        );
      }).toList();

      return counselors;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [];
    }
  }

    Future<User> getUser (String id) async{
    try {
      // Use rootBundle to access files included with the app
      String jsonString = await rootBundle.loadString('assets/data/user-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<User> users = jsonList.map((jsonItem) {
        return User(
          name: jsonItem['name'],
          id: jsonItem['id'],
          counselorId: jsonItem['counselorId'],
          image: jsonItem['image']
        );
      }).toList();

      var selectedUser = users.where((element) => element.id == id).first;

      return selectedUser;
    } catch (e) {
      print("Error reading JSON file: $e");
      return User(name: 'N/A', id: 'N/A', counselorId: 'N/A', image: 'assets/images/Me.png');
    }
  }
}

//Card Account Object
class CardAccount {
  final String name;
  final double balance;

  CardAccount({required this.name, required this.balance});
}

//User Object
class User {
  final String name;
  final String id;
  final String counselorId;
  final String image;

  User({required this.name, required this.id, required this.counselorId, required this.image});
}

//Counselor Object
class Counselor{ 
  final String name;
  final String id;
  final String type;
  final String phone;
  final String email;

  Counselor({required this.name, required this.id, required this.type, required this.phone, required this.email});
}