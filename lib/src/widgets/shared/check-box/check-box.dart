import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

class CheckBox extends StatefulWidget {
  bool isChecked = false;
  final Function onCheck;

  @override
  _CheckBoxState createState() => _CheckBoxState();

  CheckBox({required this.onCheck, Key? key}) : super(key: key);
}

class _CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return GestureDetector(
      onTap: () {
        widget.isChecked = !widget.isChecked;

        setState(() {
          // Trigger a rebuild
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: AppStyles.getPrimaryLight(themeNotifier.currentMode),
            width: 1,
          ),
        ),
        child: widget.isChecked
            ? Center(
                child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppStyles.getPrimaryLight(themeNotifier.currentMode),
                ),
              ))
            : null,
      ),
    );
  }
}
