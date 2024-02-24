import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/widgets/shared/pages/pages.dart';
import 'package:url_launcher/url_launcher.dart';
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
              InkWell(
                onTap: () {
                  _linkToPage(e);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            e.icon,
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                            size: 24,
                          ),
                          const SizedBox(
                              width: 32.0), // Spacing between icon and label
                          Text(
                            e.label,
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppStyles.getInactiveIcon(
                            themeNotifier.currentMode),
                        size: 24,
                      ),
                    ],
                  ),
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
        }).toList(),
      ),
    );
  }

  _linkToPage(QuickAccessItem quickAccessItem) {
    switch (quickAccessItem.label) {
      case "Schedule":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SchedulePage()),
        );
        break;
      case "Hours":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HoursPage()),
        );
        break;
      case "Map":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapPage()),
        );
        break;
      case "Portal":
        _launchURL();
        break;
      case "Chapel":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChapelPage()),
        );
        break;
      case "Budget":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CardAccountsPage()),
        );
        break;
      case "Event QR":
      _launchDeviceCamera();
        break;
      case "Settings":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
      default:
    }
  }

  _launchURL() async {
   final Uri url = Uri.parse('https://gcuportal.gcu.edu/');
   if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
    }
}

  _launchDeviceCamera() async {
    await availableCameras().then((value) => Navigator.push(context,
                MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
  }
}
