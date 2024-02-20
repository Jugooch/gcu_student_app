import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/pages/intramurals/widgets/addLeague_card.dart';
import 'package:gcu_student_app/src/widgets/community/pages/intramurals/widgets/im_info.dart';
import 'package:gcu_student_app/src/widgets/profile/widgets/profile_info.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:provider/provider.dart';

class IntramuralsJoinLeague extends StatefulWidget {
  const IntramuralsJoinLeague({Key? key}) : super(key: key);

  @override
  _IntramuralsJoinLeagueState createState() => _IntramuralsJoinLeagueState();
}

class _IntramuralsJoinLeagueState extends State<IntramuralsJoinLeague> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<List<League>> leaguesFuture;
  List<League> leagues = [];
  List<League> leaguesScheduled = [];
  List<League> leaguesCurrent = [];
  List<League> leaguesPast = [];
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  int selectedTabIndex = 0;

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

    leaguesFuture = IntramuralService().getLeagues(user);
    leagues = await leaguesFuture;

    DateTime now = DateTime.now();
    leaguesCurrent = leagues
        .where((league) =>
            league.seasonStart.isBefore(now) && league.seasonEnd.isAfter(now))
        .toList();
    leaguesScheduled =
        leagues.where((league) => league.seasonStart.isAfter(now)).toList();
    leaguesPast =
        leagues.where((league) => league.seasonEnd.isBefore(now)).toList();

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  // Helper method to group leagues by sport
  Map<String, List<League>> groupLeaguesBySport(List<League> leagues) {
    Map<String, List<League>> leaguesBySport = {};
    for (var league in leagues) {
      if (leaguesBySport.containsKey(league.sport)) {
        leaguesBySport[league.sport]!.add(league);
      } else {
        leaguesBySport[league.sport] = [league];
      }
    }
    return leaguesBySport;
  }

  // Helper method to build leagues display for each given sport
  Widget buildLeaguesForSport(
      Map<String, List<League>> leaguesBySport, bool isAvailable) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    List<Widget> list = [];
    leaguesBySport.forEach((sport, leagues) {
      list.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(sport,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppStyles.getTextPrimary(themeNotifier.currentMode))),
      ));
      list.add(buildLeagueCards(leagues, isAvailable));
    });
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }

//helper method to build out the list of each league
  Widget buildLeagueCards(List<League> leagues, bool isAvailable) {
    return Column(
      children: leagues.map((league) {

        //check if the start date is within 2 weeks, if so, open up league for teams to join
        if (league.seasonStart.difference(DateTime.now()).inDays <= 14) {
          isAvailable = true;
        }
        if(league.seasonEnd.isBefore(DateTime.now())){
          isAvailable = false;
        }

        return Column(
          children: [
            AddLeagueCard(league: league, available: isAvailable),
            SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

///////////////////////
  //Main Widget
///////////////////////
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    Map<String, List<League>> leaguesScheduledBySport =
        groupLeaguesBySport(leaguesScheduled);
    Map<String, List<League>> leaguesCurrentBySport =
        groupLeaguesBySport(leaguesCurrent);
    Map<String, List<League>> leaguesPastBySport =
        groupLeaguesBySport(leaguesPast);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(11),
          child: Container(
            color: const Color(0xFF522498),
          ),
        ),
        backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),

              // IM Information
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: IMInfo(),
                ),
              ),

              SizedBox(height: 16.0),

              Container(
                decoration: BoxDecoration(
                  color: AppStyles.getCardBackground(themeNotifier.currentMode),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Set the selected tab index to 0 (Current Leagues)
                          setState(() {
                            selectedTabIndex = 0;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selectedTabIndex == 0
                                    ? AppStyles.getPrimaryLight(
                                        themeNotifier.currentMode)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Current",
                              style: TextStyle(
                                color: selectedTabIndex == 0
                                    ? AppStyles.getPrimaryLight(
                                        themeNotifier.currentMode)
                                    : AppStyles.getTextPrimary(
                                        themeNotifier.currentMode),
                                fontSize: 16,
                                fontWeight: selectedTabIndex == 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Set the selected tab index to 1 (Scheduled Leagues)
                          setState(() {
                            selectedTabIndex = 1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selectedTabIndex == 1
                                    ? AppStyles.getPrimaryLight(
                                        themeNotifier.currentMode)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Scheduled",
                              style: TextStyle(
                                color: selectedTabIndex == 1
                                    ? AppStyles.getPrimaryLight(
                                        themeNotifier.currentMode)
                                    : AppStyles.getTextPrimary(
                                        themeNotifier.currentMode),
                                fontSize: 16,
                                fontWeight: selectedTabIndex == 1
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Set the selected tab index to 1 (Past Leagues)
                          setState(() {
                            selectedTabIndex = 2;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: selectedTabIndex == 2
                                    ? AppStyles.getPrimaryLight(
                                        themeNotifier.currentMode)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Past",
                              style: TextStyle(
                                color: selectedTabIndex == 2
                                    ? AppStyles.getPrimaryLight(
                                        themeNotifier.currentMode)
                                    : AppStyles.getTextPrimary(
                                        themeNotifier.currentMode),
                                fontSize: 16,
                                fontWeight: selectedTabIndex == 2
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: 32.0, right: 32.0, bottom: 16.0, top: 16.0),
                  child: Column(children: [
                    // Current Leagues
                    Visibility(
                      visible: selectedTabIndex == 0,
                      child: buildLeaguesForSport(leaguesCurrentBySport, true),
                    ),

                    // Scheduled Leagues
                    Visibility(
                      visible: selectedTabIndex == 1,
                      child:
                          buildLeaguesForSport(leaguesScheduledBySport, false),
                    ),

                    // Past Leagues
                    Visibility(
                      visible: selectedTabIndex == 2,
                      child: buildLeaguesForSport(leaguesPastBySport, false),
                    ),
                  ])),
            ],
          ),
        ));
  }
}
