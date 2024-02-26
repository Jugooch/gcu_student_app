import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';

class TeamInfo extends StatefulWidget {
  final Team team;
  const TeamInfo({required this.team, Key? key}) : super(key: key);

  @override
  _TeamInfoState createState() => _TeamInfoState();
}

class _TeamInfoState extends State<TeamInfo> {

   ///////////////////////
  // Initialize Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
  }

  calcRecord(){
    int gamesWon = 0;
    int gamesLost = 0;

    for (Game game in widget.team.games) {
      if(game.result == "Win"){
        gamesWon++;
      }
      else if(game.result == "Loss"){
        gamesLost++;
      }
    }
    return "Record: ${gamesWon} wins - ${gamesLost} losses";
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First Row: Student Image
          Container(
            child: ClipOval(
              child: Image.asset(
                widget.team.image,
                fit: BoxFit.cover,
                width: 104,
                height: 104,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(widget.team.teamName, style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode), fontWeight: FontWeight.w600, fontSize: 20)),
          SizedBox(height: 16),
          Text(calcRecord(), style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode)))
        ]);
  }
}
