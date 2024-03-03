import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:provider/provider.dart';

import 'widgets/chapel-card.dart';

class ChapelPage extends StatefulWidget {
  const ChapelPage({Key? key}) : super(key: key);

  @override
  _ChapelPageState createState() => _ChapelPageState();
}

class _ChapelPageState extends State<ChapelPage> {
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");

  late Future<List<Chapel>> futureUserChapels;
  List<Chapel> userChapels = [];

  ///////////////////////
  // Initialize Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    futureUserChapels = ChapelService().getChapels();
    fetchData();
  }

  ///////////////////////
  // Fetch User's Classes
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    userChapels = await futureUserChapels;

    userChapels.sort((a, b) => a.date.compareTo(b.date));

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
        body: FutureBuilder<List<Chapel>>(
            future: futureUserChapels,
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
                          children: userChapels
                              .expand((e) => [
                                    ChapelCard(user: user, chapel: e),
                                    SizedBox(height: 16),
                                  ])
                              .toList(),
                        ),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
