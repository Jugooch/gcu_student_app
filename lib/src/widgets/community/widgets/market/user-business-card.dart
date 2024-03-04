import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-add-business.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-business.dart';
import 'package:provider/provider.dart';

class UserBusinessCard extends StatefulWidget {
  // Pass in a business object
  final Business business;
  final User user;

  const UserBusinessCard({Key? key, required this.business, required this.user}) : super(key: key);

  @override
  _UserBusinessCardState createState() => _UserBusinessCardState();
}

class _UserBusinessCardState extends State<UserBusinessCard> {
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
        child: (widget.business.id != -1)
            ? Container(
                margin: EdgeInsets.only(bottom: 4),
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
                    Text(widget.business.name,
                        style: TextStyle(
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                            fontSize: 20,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            : InkWell(onTap: () => {
              Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddBusinessPage(user: widget.user)),
          )
            },
            child: Container(
                margin: EdgeInsets.only(bottom: 4),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppStyles.getPrimaryDark(themeNotifier.currentMode),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                    child: Icon(Icons.add, color: Colors.white, size: 24)))));
  }
}
