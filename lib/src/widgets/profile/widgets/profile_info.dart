import 'package:flutter/material.dart';
import '../../../app_styling.dart';
import '../../../current_theme.dart';
import '../../../services/services.dart';
import 'package:provider/provider.dart';

class ProfileInfo extends StatefulWidget {
  final User user;
  const ProfileInfo({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {

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
                widget.user.image,
                fit: BoxFit.cover,
                width: 104,
                height: 104,
              ),
            ),
          ),
          const SizedBox(height: 16.0), // Adjust the height between rows

          // Second Row: Student Name
          Text(
            widget.user.name,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: AppStyles.getTextPrimary(themeNotifier.currentMode)),
          ),
          const SizedBox(height: 16.0),

          // Third Row: Student ID Number
          Text(
            'ID Number: ${widget.user.id}',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: AppStyles.getTextPrimary(themeNotifier.currentMode)),
          ),
        ]);
  }
}
