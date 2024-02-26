import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';


class FeaturedBusinessCard extends StatefulWidget {
  // Pass in a business object
  final Business business;

  const FeaturedBusinessCard({Key? key, required this.business}) : super(key: key);

  @override
  _FeaturedBusinessCardState createState() => _FeaturedBusinessCardState();
}

class _FeaturedBusinessCardState extends State<FeaturedBusinessCard> {
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return InkWell(
      onTap: () {
        // Logic to open subpage for the Business
      },
      child: Container(
        width: 320,
        margin: EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: AppStyles.getCardBackground(themeNotifier.currentMode),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppStyles.getBlack(themeNotifier.currentMode).withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.asset(
                widget.business.image,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.business.name,
                    style: TextStyle(
                      color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(children: [
                    Expanded( child: Text(
                    widget.business.description,
                    maxLines: 2,
                    style: TextStyle(
                      color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )),
                  SizedBox(width: 16.0),
                  // Placeholder for user profile avatar
                  CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      child: Text("A"), // Placeholder text
                    ),
                  ],)
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
