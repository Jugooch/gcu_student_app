import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/shared/expandable-text/expandable_text.dart';
import 'package:provider/provider.dart';

class IMInfo extends StatefulWidget {
  const IMInfo({Key? key}) : super(key: key);

  @override
  _IMInfoState createState() => _IMInfoState();
}

class _IMInfoState extends State<IMInfo> {
  String im_info = "GCU intramural sports strives to build and operate a program that promotes community on campus and brings glory to God. Students may join an intramural sports team at any point throughout the season and are welcome to participate in one single gender as well as one co-ed team at a time.";
  ///////////////////////
  // Initialize Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
  }

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
                'assets/images/IM-Logo.png',
                fit: BoxFit.cover,
                width: 104,
                height: 104,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ExpandableText(text: im_info)
        ]);
  }
}
