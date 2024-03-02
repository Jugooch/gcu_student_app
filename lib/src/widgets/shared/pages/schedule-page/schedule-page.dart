import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/pages/schedule-page/widgets/class-card.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");

  late Future<List<Classes>> futureUserClasses;
  List<Classes> userClasses = [];

  Classes? upcomingClass;

  ///////////////////////
  // Initialize Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    futureUserClasses = ClassService().getUserClasses(user);
    fetchData();
  }

  ///////////////////////
  // Fetch User's Classes
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    userClasses = await futureUserClasses;

    findNextUpcomingClass(userClasses);

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

//sorts the classes by their next class date and picks the first one
  Classes findNextUpcomingClass(List<Classes> classes) {
    classes.sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
    return classes[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(11),
          child: Container(
            color: const Color(0xFF522498),
          ),
        ),
        body: FutureBuilder<List<Classes>>(
            future: futureUserClasses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Data is still loading
                return Loading();
              } else if (snapshot.hasError) {
                // Handle error state
                return Center(child: Text("Error loading data"));
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomBackButton(),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 32.0, right: 32.0, left: 32.0),
                        child: Column(
                          children: userClasses
                              .expand((e) => [
                                    ClassCard(user: user, classes: e),
                                    SizedBox(height: 16),
                                  ])
                              .toList(),
                        ),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
