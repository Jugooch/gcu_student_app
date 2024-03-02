import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:provider/provider.dart';

import 'widgets/quick_access_menu.dart';
import 'widgets/student_id.dart';

class HomeView extends StatefulWidget {

  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

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
                return Center(
        child: ListView(
          children: [
            StudentId(user: user),
            QuickAccessMenu()
          ],
        ),
      );}})
    );
  }
}
