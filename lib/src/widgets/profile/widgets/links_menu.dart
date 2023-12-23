import 'package:flutter/material.dart';
import '../../../app_styling.dart';
import '../../../current_theme.dart';
import '../../../services/services.dart';
import 'package:provider/provider.dart';

class LinksMenu extends StatefulWidget {
  const LinksMenu({Key? key}) : super(key: key);

  @override
  _LinksMenuState createState() => _LinksMenuState();
}

class _LinksMenuState extends State<LinksMenu> {
  ///////////////////////
  // Initialize Data
  ///////////////////////
  late Future<List<QuickAccessItem>> quickAccessItemsFuture;
  List<QuickAccessItem> quickAccessItems = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  ///////////////////////
  //Fetch Quick Access Items
  ///////////////////////
  Future<void> fetchData() async {
    quickAccessItemsFuture = HomeService().getAllQuickAccessItems();
    quickAccessItems = await quickAccessItemsFuture;
    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppStyles.getCardBackground(themeNotifier.currentMode),
      ),
      child: Column(
        children: quickAccessItems
            .where((element) => element.icon != Icons.add)
            .map((e) {
              final index = quickAccessItems.indexOf(e);
              final isLastItem = index == quickAccessItems.length - 2;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              e.icon,
                              color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                              size: 24,
                            ),
                            const SizedBox(width: 32.0), // Spacing between icon and label
                            Text(
                              e.label,
                              style: TextStyle(
                                color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppStyles.getInactiveIcon(themeNotifier.currentMode),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  if (!isLastItem)
                    Container(
                      height: 1,
                      color: AppStyles.getInactiveIcon(themeNotifier.currentMode),
                      width: double.infinity,
                    ),
                ],
              );
            })
            .toList(),
      ),
    );
  }
}