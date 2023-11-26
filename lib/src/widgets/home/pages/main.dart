import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/widgets/home/widgets/quick_access_menu.dart';
import '../widgets/student_id.dart';

import '../../../app_styling.dart';
import '../../../current_theme.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: null,
      backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
      body: Center(
        child: ListView(
          children: const [
            StudentId(),
            QuickAccessMenu()
          ],
        ),
      ),
    );
  }
}