import 'package:flutter/material.dart';
import '../../../app_styling.dart';
import '../../../current_theme.dart';
import '../../../services/services.dart';
import 'package:provider/provider.dart';

class CounselorDropdown extends StatefulWidget {
  const CounselorDropdown({Key? key}) : super(key: key);

  @override
  _CounselorDropdownState createState() => _CounselorDropdownState();
}

class _CounselorDropdownState extends State<CounselorDropdown> {
  late Future<User> userFuture;
  User user =
      User(name: "", id: "", image: "assets/images/Me.png");

  late Future<List<Counselor>> counselorsFuture;
  List<Counselor> counselors = [];

  ///////////////////////
  // Initialize Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  ///////////////////////
  // Fetch User
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    counselorsFuture = UserService().getUserCounselors(user);
    counselors = await counselorsFuture;

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppStyles.getCardBackground(themeNotifier.currentMode),
        boxShadow: [
          BoxShadow(
            color: AppStyles.darkBlack.withOpacity(.12),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Counselor Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                ),
              ),
              Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 24,
              ),
            ],
          ),
          )
          ),
          if (isExpanded)
            Column(
              children: counselors.map((counselor) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              counselor.type,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              counselor.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.email,
                                    size: 16,
                                    color: AppStyles.getTextPrimary(
                                        themeNotifier.currentMode)),
                                const SizedBox(width: 8.0),
                                Text(
                                  counselor.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: AppStyles.getTextPrimary(
                                        themeNotifier.currentMode),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Row(children: [
                              Icon(Icons.phone,
                                  size: 16,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode)),
                              const SizedBox(width: 8.0),
                              Text(
                                counselor.phone,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
