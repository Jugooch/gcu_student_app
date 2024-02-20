import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../pages.dart';
import '../joining-league/intramurals-joinleague2.dart';

class AddLeagueCard extends StatefulWidget {
  //pass in an event object
  final League league;
  final bool available;

  AddLeagueCard({Key? key, required this.league, required this.available})
      : super(key: key);

  @override
  _AddLeagueCard createState() => _AddLeagueCard();
}

class _AddLeagueCard extends State<AddLeagueCard> {
  String _formatDate(DateTime dateTime) {
    // Formats a DateTime like "Wednesday - January 01, 2023"
    return DateFormat('MMMM dd').format(dateTime);
  }

  ///////////////////////
  //Main Widget
  ///////////////////////
  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return InkWell(
        onTap: () => widget.available
            ? {
                //logic to open subpage for the card clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          IntramuralsJoinLeague2(league: widget.league)),
                )
              }
            : () => {},
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
                      Text(widget.league.league,
                          style: TextStyle(
                              color: widget.available ? AppStyles.getTextPrimary(
                                  themeNotifier.currentMode) : AppStyles.getDisabledText(themeNotifier.currentMode),
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.0),
                      Text(
                          "${_formatDate(widget.league.seasonStart)} - ${_formatDate(widget.league.seasonEnd)}",
                          style: TextStyle(
                              color: widget.available ? AppStyles.getTextPrimary(
                                  themeNotifier.currentMode) : AppStyles.getDisabledText(themeNotifier.currentMode),
                              fontSize: 16,
                              fontWeight: FontWeight.w300))
                    ],
                  ),
                  Icon(Icons.chevron_right_rounded,
                              color: widget.available ? AppStyles.getInactiveIcon(
                                  themeNotifier.currentMode) : Colors.transparent,
                      size: 24)
                ],
              )),
        ));
  }
}
