import 'package:flutter/material.dart';
import './widgets/card_account.dart';
import '../../../../services/shared-services/user-service.dart';

class CardAccountsPage extends StatelessWidget {
  const CardAccountsPage({Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {

    final List<CardAccount> userCardAccounts = UserService().getUserCardAccounts();

    return Scaffold(
      appBar: null,
      body: Center(
        child: ListView(
          children: userCardAccounts.map((cardAccount) {
            return CardAccountCard(
              name: cardAccount.name,
              balance: cardAccount.balance,
            );
          }).toList(),
        ),
      ),
    );
  }
}