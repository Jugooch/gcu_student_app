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

    List<CardAccount> cardAccounts = [];

    // Use Future.forEach to iterate asynchronously
    await Future.forEach(jsonList, (jsonItem) async {
      if (jsonItem['studentId'] == user.id) {
        CardAccount cardAccount = CardAccount.fromJson(jsonItem);
        List<Transaction> userTransactions =
            await getUserTransactions(user, cardAccount);
        cardAccount.initializeBudgetAndBalance(userTransactions);
        cardAccounts.add(cardAccount);
      }
    });

    return cardAccounts;
  } catch (e) {
    print("Error reading JSON file: $e");
    return [
      CardAccount(
          id: "0",
          name: "",
          totalAmount: 0.00,
          totalSpent: 0.00,
          background: "",
          fallRollover: 0.00,
          springRollover: 0,
          summerRollover: 0,
      )
    ];
  }
}



  Future<List<Transaction>> getUserTransactions(User user, CardAccount account) async{
    try {
      // Use rootBundle to access files included with the app
      String jsonString =
          await rootBundle.loadString('assets/data/transactions-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<Transaction> transactions = jsonList
          .where((jsonItem) => jsonItem['studentId'] == user.id)
          .where((jsonItem) => jsonItem['id'] == account.id)
          .map((jsonItem) {
        return Transaction(
          amount: jsonItem['amount'],
          date: DateTime.parse(jsonItem['date']),
          vendor: jsonItem['vendor'],
          image: jsonItem['image']
        );
      }).toList();

      return transactions;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [Transaction(vendor: "", amount: 0.00, date: DateTime(0), image: "")];
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
  final String id;
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
  double spentToday = 0;
  double spentThisWeek = 0;

  // Constructor that initializes dailyBudget and currentBalance
  CardAccount({
    required this.id,
    required this.name,
    required this.totalAmount,
    required this.totalSpent,
    required this.background,
    required this.fallRollover,
    required this.springRollover,
    required this.summerRollover,
  });



  // Helper method to create CardAccount from JSON data
  factory CardAccount.fromJson(Map<String, dynamic> json) {
    return CardAccount(
      id: json['id'],
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
void initializeBudgetAndBalance(List<Transaction> userTransactions) {
  // Assuming monthly budget divided by 30 days:
  dailyBudget = totalAmount / 108; 
  currentBalance = totalAmount - totalSpent;
  totalRollover = springRollover + fallRollover + summerRollover;

  List<Transaction> thisWeeksTransactions = userTransactions
      .where((transaction) =>
          transaction.date.isAfter(DateTime.now().subtract(Duration(days: DateTime.now().weekday))) &&
          transaction.date.isBefore(DateTime.now().add(Duration(days: DateTime.saturday - DateTime.now().weekday + 1))))
      .toList();

  // Calculate the total spent for the week and store it in spentThisWeek
  if (thisWeeksTransactions.length != 0) {
    spentThisWeek = thisWeeksTransactions.fold(
        0, (previous, transaction) => previous + transaction.amount);
  }

  // Pass the userTransactions to this method to use here
  List<Transaction> todaysTransactions = userTransactions
      .where((transaction) =>
          transaction.date.year == DateTime.now().year &&
          transaction.date.month == DateTime.now().month &&
          transaction.date.day == DateTime.now().day)
      .toList();

  // Calculate the total spent for today and store it in spentToday
  if (todaysTransactions.isNotEmpty) {
    spentToday = todaysTransactions.fold(
        0, (previous, transaction) => previous + transaction.amount);
  }
}


}

//Transaction object
class Transaction{
  final String vendor;
  final double amount;
  final DateTime date;
  final String image;

  Transaction({required this.amount, required this.date, required this.vendor, required this.image});
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
