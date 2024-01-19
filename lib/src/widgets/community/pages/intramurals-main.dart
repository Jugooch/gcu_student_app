import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:provider/provider.dart';

class IntramuralsPage extends StatelessWidget {
  const IntramuralsPage({Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(11),
          child: Container(
            color: const Color(0xFF522498),
          )),
        backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
      body: Center(
      ),
    );
  }
}