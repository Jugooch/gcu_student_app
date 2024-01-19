import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:provider/provider.dart';

class LightDarkToggle extends StatefulWidget {
  @override
  _LightDarkToggleState createState() => _LightDarkToggleState();
}

class _LightDarkToggleState extends State<LightDarkToggle> {
  bool isLightMode = true;

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    if(themeNotifier.currentMode == AppMode.light){
      isLightMode = true;
    }
    else{
      isLightMode = false;
    }

    return GestureDetector(
      onTap: () {
        themeNotifier.toggleMode();
        isLightMode = !isLightMode;

        setState(() {
        });
      },
      child: Container(
        width: 64,
        height: 24,
        decoration: BoxDecoration(
          color: AppStyles.disabled,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
              Icon(Icons.brightness_5, color: isLightMode ? AppStyles.getPrimaryLight(themeNotifier.currentMode) : AppStyles.getInactiveIcon(themeNotifier.currentMode), size: 16),
              Icon(Icons.brightness_2, color: !isLightMode ? AppStyles.getPrimaryLight(themeNotifier.currentMode) : AppStyles.getInactiveIcon(themeNotifier.currentMode), size: 16),
          ],
        ),
      ),
    );
  }
}
