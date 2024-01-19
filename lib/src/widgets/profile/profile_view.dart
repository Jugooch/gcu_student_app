import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/profile/widgets/profile_info.dart';
import 'package:provider/provider.dart';

import 'widgets/counselor_dropdown.dart';
import 'widgets/links_menu.dart';

class ProfileView extends StatefulWidget {

  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: null,
        backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // First Widget:Profile Information
                Center(
                  child: ProfileInfo(),
                ),
                SizedBox(height: 16.0),

                // Second Row: Counselor Information Dropdown
                CounselorDropdown(),
                SizedBox(height: 16.0),

                // Third Row: Links Menu
                LinksMenu(),
              ],
            ),
          ),
        ));
  }
}
