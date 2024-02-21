import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class LeagueInfoDropdown extends StatefulWidget {
  final League league;
  const LeagueInfoDropdown({required this.league, Key? key}) : super(key: key);

  @override
  _LeagueInfoDropdownState createState() => _LeagueInfoDropdownState();
}

class _LeagueInfoDropdownState extends State<LeagueInfoDropdown> {

  ///////////////////////
  // Initialize Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
  }

  ///////////////////////
  // Fetch User
  ///////////////////////

  bool isExpanded = false;

  formatDate(date){
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppStyles.getCardBackground(themeNotifier.currentMode),
        boxShadow: [
          BoxShadow(
            color: AppStyles.darkBlack.withOpacity(.12),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.league.league,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                ),
              ),
              Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 24,
                    color: AppStyles.getTextPrimary(themeNotifier.currentMode)
              ),
            ],
          ),
          )
          ),
          if (isExpanded)
            Column(
              children: [
                Container(
                      width: double.infinity,
                      height: 1,
                      color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                    ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                    Row(
                  children: [
                    Text("Season:", style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode), fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text("${formatDate(widget.league.seasonStart)} until ${formatDate(widget.league.seasonEnd)}", style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode)))
                  ],
                  ),
                  SizedBox(height: 16),
                  Row(
                  children: [
                    Text("Minimum Roster:", style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode), fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text("${widget.league.minRoster}", style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode))),
                  ],
                  ),    
                  SizedBox(height: 16),
                  Row(
                  children: [
                    Text("Maximum Roster:", style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode), fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text("${widget.league.maxRoster}", style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode))),
                  ],
                  )
                  ],)
                
                )
              ],
            ),
        ],
      ),
    );
  }
}
