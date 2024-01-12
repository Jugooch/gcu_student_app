import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import '../../../navbar_pages.dart';
import '../../header/header.dart';
import '../../navbar/navbar.dart';
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
    fetchData();
  }

  ///////////////////////
  // Fetch User
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    futureUserCardAccounts = UserService().getUserCardAccounts(user);
    userCardAccounts = await futureUserCardAccounts;

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  int _selectedIndex = 0;
  final List<Widget> screens = [
    const HomeView(),
    const EventsView(),
    const CommunityView(),
    const ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(11),
          child: Container(
            color: const Color(0xFF522498),
          )),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomBackButton(),
        Padding(
          padding: EdgeInsets.only(bottom: 32.0, right: 32.0, left: 32.0),
          child: Column(
            children: userCardAccounts.map((cardAccount) {
              return CardAccountCard(
                  account: cardAccount,
                  name: cardAccount.name,
                  dailyBudget: cardAccount.dailyBudget,
                  currentBalance: cardAccount.currentBalance,
                  backgroundImage: cardAccount.background);
            }).toList(),
          ),
        )
      ])),
      bottomNavigationBar: null,
    );
  }
}
