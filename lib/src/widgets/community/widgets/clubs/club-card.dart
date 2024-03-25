import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';

import '../../pages/clubs/club-page.dart';

class ClubCard extends StatefulWidget {
  // Pass in a business object
  final Club club;

  const ClubCard({Key? key, required this.club}) : super(key: key);

  @override
  _ClubCardState createState() => _ClubCardState();
}

class _ClubCardState extends State<ClubCard> {
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return InkWell(
        onTap: () {
          // Logic to open subpage for the Business
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClubPage(club: widget.club)),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
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
          child: Row(
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(widget.club.image), radius: 24, backgroundColor: Colors.white,),
              SizedBox(width: 8),
              Text(widget.club.name,
                    maxLines: 1,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color:
                            AppStyles.getTextPrimary(themeNotifier.currentMode),
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
              SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded,
                  size: 24,
                  color: AppStyles.getInactiveIcon(themeNotifier.currentMode)),
            ],
          ),
        ));
  }
}
