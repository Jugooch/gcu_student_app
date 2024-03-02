import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/profile/widgets/profile_info.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:provider/provider.dart';

import 'widgets/counselor_dropdown.dart';
import 'widgets/links_menu.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");

  ///////////////////////
  // Initialize Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    userFuture = UserService().getUser("20692303");
    fetchData();
  }

  ///////////////////////
  // Fetch User
  ///////////////////////
  Future<void> fetchData() async {
    user = await userFuture;

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: null,
        backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
        body: FutureBuilder<User>(
            future: userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Data is still loading
                return Loading();
              } else if (snapshot.hasError) {
                // Handle error state
                return Center(child: Text("Error loading data"));
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // First Widget:Profile Information
                        Center(
                          child: ProfileInfo(user: user),
                        ),
                        SizedBox(height: 16.0),

                        // Second Row: Counselor Information Dropdown
                        CounselorDropdown(),
                        SizedBox(height: 16.0),

                        // Third Row: Links Menu
                        LinksMenu(),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
