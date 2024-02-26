import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';

class UserInfo extends StatefulWidget {
  final User user;
  const UserInfo({Key? key, required this.user}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppStyles.getCardBackground(themeNotifier.currentMode),
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
        child: Column(
          children: [
            CircleAvatar(backgroundImage: AssetImage(widget.user.image), radius: 52),
            SizedBox(height: 8),
            Text(
              widget.user.name,
              style: TextStyle(
                color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'ID Number: ${widget.user.id}',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: AppStyles.getTextPrimary(themeNotifier.currentMode)),
            ),
          ],
        ));
  }
}
