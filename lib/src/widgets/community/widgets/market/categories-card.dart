import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-search.dart';
import 'package:provider/provider.dart';

class CategoriesCard extends StatefulWidget {
  const CategoriesCard({Key? key}) : super(key: key);

  @override
  _CategoriesCardState createState() => _CategoriesCardState();
}

class _CategoriesCardState extends State<CategoriesCard> {
  final List<Map<String, dynamic>> categories = [
    {"name": "Clothes", "icon": Icons.checkroom},
    {"name": "Art", "icon": Icons.brush},
    {"name": "Services", "icon": Icons.room_service},
    {"name": "Crafts", "icon": Icons.cut_sharp},
    {"name": "Food", "icon": Icons.fastfood},
    {"name": "Technology", "icon": Icons.computer},
    {"name": "Furniture", "icon": Icons.chair},
    {"name": "Home Supplies", "icon": Icons.light},
    {"name": "Cosmetics", "icon": Icons.palette},
    {"name": "Other", "icon": Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppStyles.getCardBackground(themeNotifier.currentMode),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color:
                AppStyles.getBlack(themeNotifier.currentMode).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200, // Adjust based on your layout needs
          childAspectRatio: 3 /
              2, // Adjust the size ratio of width to height based on your content needs
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MarketSearch(category: categories[index]["name"])),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: index < categories.length - 2
                        ? AppStyles.getTextPrimary(themeNotifier.currentMode)
                        : Colors.transparent,
                  ),
                  left: index % 2 == 1
                      ? BorderSide(
                          color: AppStyles.getTextPrimary(
                              themeNotifier.currentMode))
                      : BorderSide.none,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(categories[index]["icon"],
                      color:
                          AppStyles.getTextPrimary(themeNotifier.currentMode)),
                  const SizedBox(height: 8),
                  Text(
                    categories[index]["name"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          AppStyles.getTextPrimary(themeNotifier.currentMode),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
