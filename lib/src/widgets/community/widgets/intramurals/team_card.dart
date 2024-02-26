import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/pages/intramurals/intramural-team.dart';
import 'package:provider/provider.dart';

class TeamCard extends StatefulWidget {
  //pass in an event object
  final Team team;
  final bool isJoin;

  const TeamCard({Key? key, required this.team, required this.isJoin}) : super(key: key);

  @override
  _TeamCard createState() => _TeamCard();
}

class _TeamCard extends State<TeamCard> {
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
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IntramuralsTeam(team: widget.team, isJoin: widget.isJoin)),
              )
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [         
            // Add CircleAvatar to display the image
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(
                widget.team.image
              )
            ),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.team.teamName,
                    style: TextStyle(
                        color:
                            AppStyles.getTextPrimary(themeNotifier.currentMode),
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 8.0),
                Text(widget.team.league,
                    style: TextStyle(
                        color:
                            AppStyles.getTextPrimary(themeNotifier.currentMode),
                        fontSize: 16,
                        fontWeight: FontWeight.w300))
              ],
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppStyles.getInactiveIcon(themeNotifier.currentMode),
                size: 24)
            ],) 
          ),
        ));
  }
}
