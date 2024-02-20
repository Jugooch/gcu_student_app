import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class TeamCard extends StatefulWidget {
  //pass in an event object
  final Team team;

  const TeamCard({Key? key, required this.team}) : super(key: key);

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
