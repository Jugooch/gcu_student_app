import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/market/user-business-card.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/market/user-info.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

import '../../../../services/services.dart';

class MarketUser extends StatefulWidget {
  const MarketUser({Key? key}) : super(key: key);

  @override
  _MarketUser createState() => _MarketUser();
}

class _MarketUser extends State<MarketUser> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  late Future<List<Business>> userBusinessesFuture;
  List<Business> userBusinesses = [];

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  ///////////////////////
  //Fetch All Data on Events and Articles
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    userBusinessesFuture = MarketService().getUserBusinesses(user);
    userBusinesses = await userBusinessesFuture;

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(11),
            child: Container(
              color: const Color(0xFF522498),
            )),
        backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: AppStyles.getCardBackground(themeNotifier.currentMode),
                child:
                    Stack(children: [UserInfo(user: user), CustomBackButton()]),
              ),
              SizedBox(height: 32),
              Padding(padding: EdgeInsets.symmetric(horizontal: 32), child: Text(
                    'Your Businesses',
                    style: TextStyle(
                      color:
                          AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  SizedBox(height: 16),
                  SideScrollingWidget(children: userBusinesses.map((e) => UserBusinessCard(business: e)).toList())
                ]),
        ));
  }
}
