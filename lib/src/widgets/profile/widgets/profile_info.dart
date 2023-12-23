import 'package:flutter/material.dart';
import '../../../app_styling.dart';
import '../../../current_theme.dart';
import '../../../services/services.dart';
import 'package:provider/provider.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late Future<User> userFuture;
  User user =
      User(name: "", id: "", image: "assets/images/Me.png");

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

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First Row: Student Image
          Container(
            child: ClipOval(
              child: Image.asset(
                user.image,
                fit: BoxFit.cover,
                width: 104,
                height: 104,
              ),
            ),
          ),
          const SizedBox(height: 16.0), // Adjust the height between rows

          // Second Row: Student Name
          Text(
            user.name,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: AppStyles.getTextPrimary(themeNotifier.currentMode)),
          ),
          const SizedBox(height: 16.0),

          // Third Row: Student ID Number
          Text(
            'ID Number: ${user.id}',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                color: AppStyles.getTextPrimary(themeNotifier.currentMode)),
          ),
        ]);
  }
}
