import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-business.dart';
import 'package:provider/provider.dart';

class BusinessCard extends StatefulWidget {
  // Pass in a business object
  final Business business;

  const BusinessCard({Key? key, required this.business}) : super(key: key);

  @override
  _BusinessCardState createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return InkWell(
        onTap: () {
          // Logic to open subpage for the Business
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MarketBusiness(business: widget.business)),
          );
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppStyles.getCardBackground(themeNotifier.currentMode),
            borderRadius: BorderRadius.circular(8),
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
          child: Row(
            children: [
              CircleAvatar(
                  backgroundImage: AssetImage(widget.business.image),
                  radius: 24),
              SizedBox(width: 8),
              Expanded(child: Text(widget.business.name,
              maxLines: 1,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                      color:
                          AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),),
              SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded,
                  size: 24,
                  color: AppStyles.getInactiveIcon(themeNotifier.currentMode)),
            ],
          ),
        ));
  }
}
