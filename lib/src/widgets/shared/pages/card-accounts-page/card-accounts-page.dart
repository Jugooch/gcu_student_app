import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:provider/provider.dart';
import './widgets/card_account.dart';
import '../../../../services/services.dart';

class CardAccountsPage extends StatefulWidget {
  const CardAccountsPage({Key? key}) : super(key: key);

  @override
  _CardAccountsPageState createState() => _CardAccountsPageState();
}

class _CardAccountsPageState extends State<CardAccountsPage> {
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");

  late Future<List<CardAccount>> futureUserCardAccounts;
  List<CardAccount> userCardAccounts = [];

  ///////////////////////
  // Initialize Data
  ///////////////////////
@override
void initState() {
  super.initState();
  userFuture = UserService().getUser("20692303"); // Assumes this is also async and returns a Future<User>
  // Initialize with an empty list or some initial data that doesn't depend on the user being fetched
  futureUserCardAccounts = Future.value([]); // Placeholder future

  userFuture.then((fetchedUser) {
    // Now that you have the user, you can set the real future for card accounts
    setState(() {
      user = fetchedUser;
      futureUserCardAccounts = UserService().getUserCardAccounts(user);
    });
  });
}

  ///////////////////////
  // Fetch User
  ///////////////////////
  Future<void> fetchData() async {
    userCardAccounts = await futureUserCardAccounts;

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        border: null,
        backgroundColor: AppStyles.getPrimary(themeNotifier.currentMode),
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 32),
            Image.asset(
              'assets/images/GCU_Logo.png',
              height: 32.0,
            ),
          ],
        ),
      ),
      backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
      body: FutureBuilder<List<CardAccount>>(
          future: futureUserCardAccounts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Data is still loading
              return Loading();
            } else if (snapshot.hasError) {
              // Handle error state
              return Center(child: Text("Error loading data"));
            } else {
              return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    CustomBackButton(),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 32.0, right: 32.0, left: 32.0),
                      child: Column(
                        children: (snapshot.data != null) ? snapshot.data!.map((cardAccount) {
                          return CardAccountCard(
                              user: user,
                              account: cardAccount,
                              name: cardAccount.name,
                              dailyBudget: cardAccount.dailyBudget,
                              currentBalance: cardAccount.currentBalance,
                              backgroundImage: cardAccount.background);
                        }).toList() : []
                      ),
                    )
                  ]));
            }
          }),
      bottomNavigationBar: null,
    );
  }
}
