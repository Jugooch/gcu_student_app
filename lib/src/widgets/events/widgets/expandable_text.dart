import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:provider/provider.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: TextStyle(
            fontSize: 16,
            height: 1.4, // Line height
          ),
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
          maxLines: _isExpanded ? null : 2,
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle expanded state
            });
          },
          child: Text(
            _isExpanded ? 'See Less...' : 'See More...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppStyles.getPrimaryLight(themeNotifier.currentMode), // Change as per your app's theme
            ),
          ),
        ),
      ],
    );
  }
}
