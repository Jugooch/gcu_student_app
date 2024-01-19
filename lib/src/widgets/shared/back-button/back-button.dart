import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:provider/provider.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return IconButton(
      padding: EdgeInsets.all(8),
      icon: Icon(
        Icons.arrow_circle_left,
        size: 40,
        color: AppStyles.getInactiveIcon(themeNotifier.currentMode),
      ), // Back arrow icon
      onPressed: () {
        Navigator.pop(
            context); // Pop the current screen off the navigation stack
      },
    );
  }
}
