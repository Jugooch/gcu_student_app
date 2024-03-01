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
  bool _isExpandable = false; // New variable to track if text is expandable

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkExpandability());
  }

  void _checkExpandability() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: TextStyle(fontSize: 16, height: 1.4)), // Match the text style
      maxLines: 2, // Match the maxLines
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 32); // Assuming padding/margin from both sides

    if (textPainter.didExceedMaxLines) {
      setState(() {
        _isExpandable = true; // Text exceeds max lines and is expandable
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: TextStyle(fontSize: 16, height: 1.4, color: AppStyles.getTextPrimary(themeNotifier.currentMode)),
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
          maxLines: _isExpanded ? null : 2,
        ),
        if (_isExpandable) // Only show if text is expandable
          SizedBox(height: 16),
        if (_isExpandable) // Only show if text is expandable
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
                color: AppStyles.getPrimaryLight(themeNotifier.currentMode),
              ),
            ),
          ),
      ],
    );
  }
}
