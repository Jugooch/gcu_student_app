import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/pages/intramurals/intramurals-joinleague.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/intramurals/team_card.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/intramurals/upcomingGame_card.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:provider/provider.dart';

class IntramuralsPage extends StatefulWidget {
  const IntramuralsPage({Key? key}) : super(key: key);

  @override
  _IntramuralsPageState createState() => _IntramuralsPageState();
}

class _IntramuralsPageState extends State<IntramuralsPage> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<List<League>> leaguesFuture;
  List<League> leagues = [];
  late Future<List<Team>> teamsFuture;
  List<Team> teams = [];
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    leaguesFuture = IntramuralService().getLeagues(user);
    fetchData();
  }

  ///////////////////////
  //Fetch All Data on Events and Articles
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    leagues = await leaguesFuture;

    teamsFuture = IntramuralService().getTeams(user);
    teams = await teamsFuture;

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  Game _getUpcomingGame(teams) {
    var today = DateTime.now();
    Game? nextGame;

    for (var team in teams) {
      for (var game in team.games) {
        // Check if the game is in the future and closer than the currently stored nextGame
        if (game.date.isAfter(today) &&
            (nextGame == null || game.date.isBefore(nextGame.date))) {
          nextGame = game;
        }
      }
    }

    if (nextGame == null) {
      throw Exception('No upcoming games found.');
    }

    return nextGame;
  }

///////////////////////
  //Main Widget
///////////////////////
  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(11),
          child: Container(
            color: const Color(0xFF522498),
          ),
        ),
        backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
        body: FutureBuilder<List<League>>(
            future: leaguesFuture,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8)),
                              child: ElevatedButton(
                                onPressed: () {
                                  //logic to open subpage for the card clicked
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            IntramuralsJoinLeague()),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    AppStyles.getPrimaryDark(
                                        themeNotifier.currentMode),
                                  ),
                                  minimumSize: MaterialStateProperty.all(
                                    const Size(0.5, 0), // 50% width
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Join a League',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 32),
                            Text(
                              'Your Teams',
                              style: TextStyle(
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            //the spread (...) operator allows us to directly add the map function to add our cards to the column
                            //expand allows us to add spacing between each card
                            if (teams.isNotEmpty)
                              ...teams.expand((team) {
                                int index = teams.indexOf(team);
                                return [
                                  TeamCard(team: team, isJoin: false),
                                  if (index != teams.length - 1)
                                    SizedBox(height: 16.0),
                                ];
                              }).toList()
                            else
                              Text(
                                  "No teams to show... Try joining one today!"),
                            SizedBox(height: 32),
                            Text(
                              'Upcoming Game',
                              style: TextStyle(
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.0),
                            //this section will show the upcoming game for the user
                            //this should look through all their teams and find the one with the next game
                            if (teams.isNotEmpty)
                              UpcomingGameCard(game: _getUpcomingGame(teams))
                            else
                              Text("No games coming up..."),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
