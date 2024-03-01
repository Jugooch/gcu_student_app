import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/expandable-text/expandable_text.dart';
import 'package:provider/provider.dart';

class BusinessInfo extends StatefulWidget {
  final Business business;
  const BusinessInfo({Key? key, required this.business}) : super(key: key);

  @override
  _BusinessInfoState createState() => _BusinessInfoState();
}

class _BusinessInfoState extends State<BusinessInfo> {
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
       
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
          children: [
            CircleAvatar(backgroundImage: AssetImage(widget.business.image), radius: 52),
            SizedBox(height: 8),
            Text(
              widget.business.name,
              style: TextStyle(
                color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ExpandableText(text: widget.business.description)
          ],
        )));
  }
}
