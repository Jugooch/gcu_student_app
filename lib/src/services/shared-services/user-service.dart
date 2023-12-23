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

Future<List<Counselor>> getUserCounselors(User user) async {
  try {
    // Use rootBundle to access files included with the app
    String jsonString = await rootBundle.loadString('assets/data/counselor-data.json');
    List<dynamic> jsonList = jsonDecode(jsonString);

    List<Counselor> counselors = jsonList
        .where((jsonItem) => jsonItem['studentId'] == user.id)
        .map((jsonItem) {
      return Counselor(
        name: jsonItem['name'],
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
          image: jsonItem['image']
        );
      }).toList();

      var selectedUser = users.where((element) => element.id == id).first;

      return selectedUser;
    } catch (e) {
      print("Error reading JSON file: $e");
      return User(name: 'N/A', id: 'N/A', image: 'assets/images/Me.png');
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
  final String image;

  User({required this.name, required this.id, required this.image});

  
  Map<String, dynamic> toJson() => {
    "id": id, 
    "classId": "ISSUER_ID.GENERIC_CLASS_ID", 
    "logo": {
      "sourceUri": {
        "uri": "assets/images/GCU_Logo.png"
      },
      "contentDescription": {
        "defaultValue": {
          "language": "en-US",
          "value": "GCU Logo"
        }
     }
    },
    "cardTitle": {
      "defaultValue": {
        "language": "en-US",
        "value": "GCU Student ID",
      },
    },
    "subheader": {
    "defaultValue": {
      "language": "en-US",
      "value": "Student",
    },
  },
  "header": {
    "defaultValue": {
      "language": "en-US",
      "value": name,
    },
  },
  "barcode": {
    "type": "CODE_128",
    "value": "https://www.gcu.edu",
    "alternateText": "",
  },
  "hexBackgroundColor": "#ffffff",
  "heroImage": {
    "sourceUri": {
      "uri": image,
    },
    "contentDescription": {
      "defaultValue": {
        "language": "en-US",
        "value": "Student Image",
      },
    },
  },
  };
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