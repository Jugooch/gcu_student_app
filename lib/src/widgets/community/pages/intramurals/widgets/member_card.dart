import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/pages/intramurals/intramural-team.dart';
import 'package:provider/provider.dart';

import '../../pages.dart';

class MemberCard extends StatefulWidget {
  //pass in an event object
  final Member member;
  final bool isCaptain;

  const MemberCard({Key? key, required this.member, required this.isCaptain}) : super(key: key);

  @override
  _MemberCard createState() => _MemberCard();
}

class _MemberCard extends State<MemberCard> {
  ///////////////////////
  //Main Widget
  ///////////////////////
  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [         
            // Add CircleAvatar to display the image
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(
                "assets/images/Avatar.png"
              )
            ),
            SizedBox(width: 16),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.member.name,
                    style: TextStyle(
                        color:
                            AppStyles.getTextPrimary(themeNotifier.currentMode),
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 8.0),
                Text(widget.isCaptain ? "Captain" : "Member",
                    style: TextStyle(
                        color:
                            AppStyles.getTextPrimary(themeNotifier.currentMode),
                        fontSize: 16,
                        fontWeight: FontWeight.w300))
              ],
            ),
            ],) 
          ),
        );
  }
}
