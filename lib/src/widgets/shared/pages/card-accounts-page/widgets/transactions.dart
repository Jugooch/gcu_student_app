import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/pages/card-accounts-page/widgets/transaction-card.dart';

class Transactions extends StatefulWidget {
  final CardAccount account;
  final User user;

  Transactions({required this.account, required this.user, Key? key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late Future<List<Transaction>> futureUserTransactions;
  List<Transaction> userTransactions = [];

  ///////////////////////
  // Initialize Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  ///////////////////////
  // Fetch User
  ///////////////////////
  Future<void> fetchData() async {
    futureUserTransactions = UserService().getUserTransactions(widget.user, widget.account);
    userTransactions = await futureUserTransactions;
    // Sort transactions by date in descending order
    userTransactions.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 32.0, left: 32.0, top: 32),
      child: Column(
        children: [
          for (var transaction in userTransactions)
            Column(
              children: [
                TransactionCard(transaction: transaction),
                SizedBox(height: 16),
              ],
            ),
        ],
      ),
    );
  }
}
