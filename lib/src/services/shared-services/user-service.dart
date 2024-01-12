import 'dart:convert';
import 'package:flutter/services.dart';

class UserService {
///////////////////////
//Getter Methods
///////////////////////

  Future<List<CardAccount>> getUserCardAccounts(User user) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/card-accounts-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<CardAccount> cardAccounts = jsonList
          .where((jsonItem) => jsonItem['studentId'] == user.id)
          .map((jsonItem) {
        return CardAccount.fromJson(jsonItem);
      }).toList();

      return cardAccounts;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [CardAccount(name: "", totalAmount: 0.00, totalSpent: 0.00, background: "", fallRollover: 0.00, springRollover: 0, summerRollover: 0)];
    }
  }

  Future<List<Counselor>> getUserCounselors(User user) async {
    try {
      // Use rootBundle to access files included with the app
      String jsonString =
          await rootBundle.loadString('assets/data/counselor-data.json');
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
      return [Counselor(name: "", id: "", type: "", phone: "", email: "")];
    }
  }

  Future<User> getUser(String id) async {
    try {
      // Use rootBundle to access files included with the app
      String jsonString =
          await rootBundle.loadString('assets/data/user-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<User> users = jsonList.map((jsonItem) {
        return User(
            name: jsonItem['name'],
            id: jsonItem['id'],
            image: jsonItem['image']);
      }).toList();

      var selectedUser = users.where((element) => element.id == id).first;

      return selectedUser;
    } catch (e) {
      print("Error reading JSON file: $e");
      return User(name: '', id: '', image: 'assets/images/Me.png');
    }
  }
}

class CardAccount {
  final String name;
  final String background;
  final double totalAmount;
  final double totalSpent;
  double dailyBudget = 0;
  double currentBalance = 0;
  double totalRollover = 0;
  final double fallRollover;
  final double springRollover;
  final double summerRollover;

  // Constructor that initializes dailyBudget and currentBalance
  CardAccount({
    required this.name,
    required this.totalAmount,
    required this.totalSpent,
    required this.background,
    required this.fallRollover,
    required this.springRollover,
    required this.summerRollover
  }) {
    initializeBudgetAndBalance();
  }

  // Helper method to create CardAccount from JSON data
  factory CardAccount.fromJson(Map<String, dynamic> json) {
    return CardAccount(
      name: json['name'],
      totalAmount: json['totalAmount'],
      totalSpent: json['totalSpent'],
      background: json['background'],
      fallRollover: json['fallRollover'],
      springRollover: json['springRollover'],
      summerRollover: json['summerRollover'],
    );
  }

  // Helper Method to initialize dailyBudget and currentBalance
  void initializeBudgetAndBalance() {
    // You can customize the calculation based on your requirements
    dailyBudget =
        totalAmount / 108; // Assuming monthly budget divided by 30 days
    currentBalance = totalAmount - totalSpent;
    totalRollover = springRollover+fallRollover+summerRollover;
  }

  
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
          "sourceUri": {"uri": "assets/images/GCU_Logo.png"},
          "contentDescription": {
            "defaultValue": {"language": "en-US", "value": "GCU Logo"}
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
class Counselor {
  final String name;
  final String id;
  final String type;
  final String phone;
  final String email;

  Counselor(
      {required this.name,
      required this.id,
      required this.type,
      required this.phone,
      required this.email});
}
