import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/pages/intramurals/intramurals-deleteteam.dart';
import 'package:gcu_student_app/src/widgets/community/pages/intramurals/intramurals-quiz.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../widgets/intramurals/leagueInfo_dropdown.dart';
import '../../widgets/intramurals/member_card.dart';
import '../../widgets/intramurals/team_info.dart';
import '../../widgets/intramurals/upcomingGame_card.dart';

class IntramuralsTeam extends StatefulWidget {
  final Team team;
  final bool isJoin;
  const IntramuralsTeam({required this.isJoin, required this.team, super.key});

  @override
  _IntramuralsTeamState createState() => _IntramuralsTeamState();
}

// This is the type used by the menu below.
enum DropdownItem { removeTeam }

class _IntramuralsTeamState extends State<IntramuralsTeam> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  late Future<League> futureLeague;
  late Member captain;
  League league = League(
      sport: '',
      seasonStart: DateTime.now(),
      league: '',
      seasonEnd: DateTime.now(),
      maxRoster: 0,
      minRoster: 0);

  int selectedTabIndex = 0;

  Team homeTeam = Team(
      league: "",
      teamName: "",
      members: [],
      captain: Member(id: "", name: "", joinDate: DateTime.now()),
      sportsmanship: -1,
      games: [],
      image: "assets/images/Lopes.jpg",
      autoAcceptMembers: false,
      inviteOnly: true);
  Team awayTeam = Team(
      league: "",
      teamName: "",
      members: [],
      captain: Member(id: "", name: "", joinDate: DateTime.now()),
      sportsmanship: -1,
      games: [],
      image: "assets/images/Lopes.jpg",
      autoAcceptMembers: false,
      inviteOnly: true);

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    futureLeague = IntramuralService().getLeague(widget.team.league);
    fetchLeague();
    captain = widget.team.members
        .firstWhere((element) => element.id == widget.team.captain.id);
    setTab();
  }

  fetchLeague() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;
    league = await futureLeague;

    setState(() {});
  }

  setHomeTeam(home) async {
    homeTeam = await IntramuralService().getTeam(home);
  }

  setAwayTeam(away) async {
    awayTeam = await IntramuralService().getTeam(away);
  }

  setTab() {
    if (widget.isJoin) {
      selectedTabIndex = 2;
      setState(() {});
    }
  }

  isUserMember() {
    if (widget.team.members.any((element) => element.id == user.id)) {
      return true;
    } else {
      return false;
    }
  }

  String formatDate(DateTime date) {
    // Example format: Tuesday - 01/01/2023
    return DateFormat('EEEE - MM/dd/yyyy').format(date);
  }

  String formatTime(DateTime date) {
    // Example format: 7:30 PM
    return DateFormat('h:mm a').format(date);
  }

  getUpcomingGame() {
    var today = DateTime.now();
    Game? nextGame;

    for (var game in widget.team.games) {
      // Check if the game is in the future and closer than the currently stored nextGame
      if (game.date.isAfter(today) &&
          (nextGame == null || game.date.isBefore(nextGame.date))) {
        nextGame = game;
      }
    }

    setState(() {});

    if (nextGame == null) {
      return null;
    }

    return nextGame;
  }

  populateMenu(item) {
    switch (item) {
      case "removeTeam":
        return "Delete Team";
    }
  }

///////////////////////
  //Main Widget
///////////////////////
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    Game? upcomingGame = getUpcomingGame();
    int rosterNum = widget.team.members.length;
    int rosterCount = 0;
    int gamesNum = widget.team.games.length;
    int gamesCount = 0;
    DropdownItem? selectedMenu;
    List<Member> roster = widget.team.members
        .where((element) => element.name != widget.team.captain)
        .toList();

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
        body: FutureBuilder<League>(
            future: futureLeague,
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
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBackButton(),
                              captain.id == user.id
                                  ? MenuAnchor(
                                      builder: (BuildContext context,
                                          MenuController controller,
                                          Widget? child) {
                                        return IconButton(
                                          onPressed: () {
                                            if (controller.isOpen) {
                                              controller.close();
                                            } else {
                                              controller.open();
                                            }
                                          },
                                          icon: Icon(Icons.more_horiz,
                                              color: AppStyles.getInactiveIcon(
                                                  themeNotifier.currentMode),
                                              size: 32),
                                          tooltip: 'Show menu',
                                        );
                                      },
                                      menuChildren:
                                          List<MenuItemButton>.generate(
                                        1,
                                        (int index) => MenuItemButton(
                                          onPressed: () => {
                                            setState(() => selectedMenu =
                                                DropdownItem.values[index]),
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RemoveTeamPage(
                                                          team: widget.team,
                                                          user: user)),
                                            )
                                          },
                                          child: Text(populateMenu(
                                              DropdownItem.values[index].name)),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  AppStyles.getCardBackground(
                                                      themeNotifier
                                                          .currentMode),
                                              title: Text("Report This Team",
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode))),
                                              content: Text(
                                                  "Are you sure you want to report this team because they are not following our guidelines for intramural sports?",
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode))),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text("Cancel",
                                                      style: TextStyle(
                                                          color: AppStyles
                                                              .getPrimaryLight(
                                                                  themeNotifier
                                                                      .currentMode))),
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                    // Add the report logic here
                                                  },
                                                  child: Text(
                                                    "Report",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(Icons.report,
                                              color: Colors.red, size: 32)))
                            ],
                          )),

                      // IM Information
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Center(
                          child: TeamInfo(team: widget.team),
                        ),
                      ),

                      SizedBox(height: 16.0),

                      Container(
                        decoration: BoxDecoration(
                          color: AppStyles.getCardBackground(
                              themeNotifier.currentMode),
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
                                      "Team Info",
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
                                      "Schedule",
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
                                      "Roster",
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
                            // Team info
                            Visibility(
                                visible: selectedTabIndex == 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("League Information",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier.currentMode))),
                                    SizedBox(height: 16),
                                    LeagueInfoDropdown(league: league),
                                    SizedBox(height: 32),
                                    Text("Upcoming Game",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier.currentMode))),
                                    SizedBox(height: 16),
                                    if (upcomingGame != null)
                                      UpcomingGameCard(
                                          key: ValueKey(2), game: upcomingGame)
                                    else
                                      Text("No upcoming games..."),
                                  ],
                                )),

                            // Team schedule
                            Visibility(
                              visible: selectedTabIndex == 1,
                              child: Column(
                                children: widget.team.games.map((e) {
                                  // Increment the counter for each game.
                                  gamesCount++;
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(formatDate(e.date),
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16)),
                                              SizedBox(height: 4),
                                              Text(formatTime(e.date),
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                            ],
                                          ),
                                          Text(e.result,
                                              style: TextStyle(
                                                  color:
                                                      AppStyles.getTextPrimary(
                                                          themeNotifier
                                                              .currentMode),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () async {
                                                await setHomeTeam(e
                                                    .home); // Await the asynchronous call
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          IntramuralsTeam(
                                                              team: homeTeam,
                                                              isJoin: false)),
                                                );
                                              },
                                              child: Container(
                                                alignment: Alignment
                                                    .centerLeft, // Align text to the left
                                                child: Text(
                                                  e.home,
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode)),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text("VS",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color:
                                                      AppStyles.getTextPrimary(
                                                          themeNotifier
                                                              .currentMode),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16)),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () async {
                                                await setAwayTeam(e
                                                    .away); // Corrected to setAwayTeam and awaited
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          IntramuralsTeam(
                                                              team: awayTeam,
                                                              isJoin:
                                                                  false)), // Corrected to navigate with awayTeam
                                                );
                                              },
                                              child: Container(
                                                alignment: Alignment
                                                    .centerRight, // Align text to the right
                                                child: Text(
                                                  e.away,
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Check if it's not the last item.
                                      if (gamesCount < gamesNum) ...[
                                        SizedBox(height: 16),
                                        Divider(
                                            height: 1,
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier.currentMode)),
                                        SizedBox(height: 16),
                                      ],
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),

                            // Team Roster
                            Visibility(
                                visible: selectedTabIndex == 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Captain",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier.currentMode))),
                                    SizedBox(height: 16),
                                    MemberCard(
                                        member: widget.team.captain,
                                        isCaptain: true),
                                    if (widget.isJoin)
                                      Container(
                                        height: 80.0,
                                        margin: EdgeInsets.only(top: 32),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            //logic to open subpage for the card clicked
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuizPage(
                                                          createTeam: false,
                                                          league: league,
                                                          team: widget.team)),
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              AppStyles.getPrimaryDark(
                                                  themeNotifier.currentMode),
                                            ),
                                            minimumSize:
                                                MaterialStateProperty.all(
                                              const Size(0.5, 0), // 50% width
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Join Team',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else if (isUserMember() &&
                                        widget.team.members.length > 1)
                                      Container(
                                        height: 80.0,
                                        margin: EdgeInsets.only(top: 32),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (user.id ==
                                                widget.team.captain.id) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Select a new captain",
                                                        style: TextStyle(
                                                            color: AppStyles
                                                                .getTextPrimary(
                                                                    themeNotifier
                                                                        .currentMode))),
                                                    backgroundColor: AppStyles
                                                        .getCardBackground(
                                                            themeNotifier
                                                                .currentMode),
                                                    content: Container(
                                                      // Optionally, set a specific height
                                                      width: double.maxFinite,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: widget.team
                                                            .members.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          if (widget
                                                                  .team
                                                                  .members[
                                                                      index]
                                                                  .id ==
                                                              user.id) {
                                                            return Container(); // Don't show the current user
                                                          }
                                                          return ListTile(
                                                            title: Text(
                                                                widget
                                                                    .team
                                                                    .members[
                                                                        index]
                                                                    .name,
                                                                style: TextStyle(
                                                                    color: AppStyles.getTextPrimary(
                                                                        themeNotifier
                                                                            .currentMode))),
                                                            onTap: () {
                                                              /////////////////////////////////////////////////////////////////
                                                              // *TODO* Implement logic to set the selected member as the new captain
                                                              /////////////////////////////////////////////////////////////////
                                                              ///
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: Text("Cancel",
                                                            style: TextStyle(
                                                                color: AppStyles
                                                                    .getPrimaryLight(
                                                                        themeNotifier
                                                                            .currentMode))),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: AppStyles
                                                        .getCardBackground(
                                                            themeNotifier
                                                                .currentMode),
                                                    title: Text(
                                                        "Leave This Team",
                                                        style: TextStyle(
                                                            color: AppStyles
                                                                .getTextPrimary(
                                                                    themeNotifier
                                                                        .currentMode))),
                                                    content: Text(
                                                        "Are you sure you want to leave this intramural team?",
                                                        style: TextStyle(
                                                            color: AppStyles
                                                                .getTextPrimary(
                                                                    themeNotifier
                                                                        .currentMode))),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child: Text("Cancel",
                                                            style: TextStyle(
                                                                color: AppStyles
                                                                    .getPrimaryLight(
                                                                        themeNotifier
                                                                            .currentMode))),
                                                      ),
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();

                                                          /////////////////////////////////////////////////////////////////
                                                          // *TODO* Implement logic to let a user leave the team
                                                          /////////////////////////////////////////////////////////////////
                                                          print(
                                                              "User tried leaving! Ha!");
                                                        },
                                                        child: Text(
                                                          "Leave",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              AppStyles.getPrimaryDark(
                                                  themeNotifier.currentMode),
                                            ),
                                            minimumSize:
                                                MaterialStateProperty.all(
                                              const Size(0.5, 0), // 50% width
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Leave Team',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 32),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Team Members",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppStyles.getTextPrimary(
                                                    themeNotifier
                                                        .currentMode))),
                                        Text(
                                            "${widget.team.members.length} / ${league.maxRoster}")
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: roster.map<Widget>((e) {
                                        rosterCount++;
                                        return Column(
                                          children: [
                                            MemberCard(
                                                member: e, isCaptain: false),
                                            if (rosterCount != rosterNum)
                                              SizedBox(height: 16)
                                          ],
                                        );
                                      }).toList(),
                                    )
                                  ],
                                )),
                          ])),
                    ],
                  ),
                );
              }
            }));
  }
}
