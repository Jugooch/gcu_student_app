import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/clubs/club-card.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

class ClubsPage extends StatefulWidget {
  final User user;
  const ClubsPage({Key? key, required this.user}) : super(key: key);

  @override
  _ClubsPage createState() => _ClubsPage();
}

class _ClubsPage extends State<ClubsPage> {
  late Future<List<Club>> futureJoinedClubs;
  List<Club> joinedClubs = [];

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    futureJoinedClubs = ClubsService().getUserClubs(widget.user);
    fetchData();
  }

  fetchData() async {
    joinedClubs = await futureJoinedClubs;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
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
        body: FutureBuilder<List<Club>>(
            future: futureJoinedClubs,
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
                            right: 32.0, left: 32.0),
                        child: Text("Joined Clubs",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode))),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SideScrollingWidget(
                          children: joinedClubs.map(
                        (e) {
                          return ClubCard(club: e);
                        },
                      ).toList())
                    ],
                  ),
                );
              }
            }));
  }
}
