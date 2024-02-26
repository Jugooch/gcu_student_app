import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../pages/intramurals/intramural-team.dart';

class UpcomingGameCard extends StatefulWidget {
  //pass in an event object
  final Game game;

  const UpcomingGameCard({Key? key, required this.game}) : super(key: key);

  @override
  _UpcomingGameCard createState() => _UpcomingGameCard();
}

class _UpcomingGameCard extends State<UpcomingGameCard> {
  Team homeTeam = Team(
      league: "",
      teamName: "",
      members: [],
      captain: "",
      sportsmanship: -1,
      games: [],
      image: "assets/images/Lopes.jpg",
      autoAcceptMembers: false,
      inviteOnly: true);
  Team awayTeam = Team(
      league: "",
      teamName: "",
      members: [],
      captain: "",
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
    fetchTeams();
  }

  String _formatDate(DateTime dateTime) {
    // Formats a DateTime like "Wednesday - January 01, 2023"
    return DateFormat('EEEE - MMMM dd, yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    // Formats a DateTime like "7:00 PM"
    return DateFormat('h:mm a').format(dateTime);
  }

  fetchTeams() async {
    homeTeam = await IntramuralService().getTeam(widget.game.home);
    awayTeam = await IntramuralService().getTeam(widget.game.away);

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  ///////////////////////
  //Main Widget
  ///////////////////////
  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return InkWell(
        onTap: () => {
              //logic to open subpage for the Team
              // Navigator.push(
              // context,
              // MaterialPageRoute(builder: (context) => EventPage(event: widget.event, otherEvents: widget.otherEvents,)),
              // )
            },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppStyles.getCardBackground(themeNotifier.currentMode),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppStyles.getBlack(themeNotifier.currentMode)
                    .withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: [
            //use the ClipRRect to take more control of the border radiuses
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppStyles.getPrimaryDark(themeNotifier.currentMode),
                ),
                child: Column(
                  children: [
                    Text(
                      homeTeam.league,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _formatDate(widget.game.date),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "${widget.game.location} at ${_formatTime(widget.game.date)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () => {
                            //logic to open subpage for the Team
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IntramuralsTeam(
                                      team: homeTeam, isJoin: false)),
                            )
                          },
                      child: Column(
                        children: [
                          Text("Home",
                              style: TextStyle(
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                  fontSize: 12)),
                          SizedBox(height: 16),
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(homeTeam.image),
                          ),
                          SizedBox(height: 8),
                          Text(homeTeam.teamName,
                              style: TextStyle(
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      )),
                  Text("VS",
                      style: TextStyle(
                          color: AppStyles.getTextPrimary(
                              themeNotifier.currentMode))),
                  InkWell(
                      onTap: () => {
                            //logic to open subpage for the Team
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IntramuralsTeam(
                                      team: awayTeam, isJoin: false)),
                            )
                          },
                      child: Column(
                        children: [
                          Text("Away",
                              style: TextStyle(
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                  fontSize: 12)),
                          SizedBox(height: 16),
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(awayTeam.image),
                          ),
                          SizedBox(height: 8),
                          Text(awayTeam.teamName,
                              style: TextStyle(
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      )),
                ],
              ),
            ),
          ]),
        ));
  }
}
