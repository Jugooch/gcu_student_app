import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';

import 'widgets/chapel-card.dart';

class ChapelPage extends StatefulWidget {
  const ChapelPage({Key? key}) : super(key: key);
  
  @override
  _ChapelPageState createState() => _ChapelPageState();
}

class _ChapelPageState extends State<ChapelPage> {
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");

  late Future<List<Chapel>> futureUserChapels;
  List<Chapel> userChapels = [];

  ///////////////////////
  // Initialize Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  ///////////////////////
  // Fetch User's Classes
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    futureUserChapels = ChapelService().getChapels();
    userChapels = await futureUserChapels;

    userChapels.sort((a, b) => a.date.compareTo(b.date));

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(11),
          child: Container(
            color: const Color(0xFF522498),
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomBackButton(),
            Padding(
              padding: EdgeInsets.only(bottom: 32.0, right: 32.0, left: 32.0),
              child: Column(
                children: userChapels
                    .expand((e) => [
                          ChapelCard(user: user, chapel: e),
                          SizedBox(height: 16),
                        ])
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
