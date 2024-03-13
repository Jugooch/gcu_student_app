import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-edit-business.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

import '../../../../services/services.dart';
import '../../widgets/clubs/club-info.dart';
import '../../widgets/market/business-info.dart';
import 'delete-club.dart';
import 'edit-club.dart';

class ClubPage extends StatefulWidget {
  final Club club;
  const ClubPage({Key? key, required this.club}) : super(key: key);

  @override
  _ClubPage createState() => _ClubPage();
}

// This is the type used by the menu below.
enum DropdownItem { editClub, deleteClub }

class _ClubPage extends State<ClubPage> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  late Future<List<Event>> eventsFuture;
  List<Event> events = [];
  bool isOwner = false;

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    eventsFuture = ClubsService().getClubEvents(widget.club);
    fetchData();
  }

  ///////////////////////
  //Fetch All Data on Events and Articles
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    if (user.id == widget.club.owner.id) {
      isOwner = true;
    }

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  populateMenu(item) {
    switch (item) {
      case "editClub":
        return "Edit Club";
      case "deleteClub":
        return "Delete Club";
    }
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    DropdownItem? selectedMenu;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            border: null,
            backgroundColor: AppStyles.getPrimary(themeNotifier.currentMode),
            middle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 32),
                Image.asset(
                  'assets/images/GCU_Logo.png',
                  height: 32.0,
                ),
              ],
            ),
          ),
          backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
          body: FutureBuilder<List<Event>>(
            future: eventsFuture,
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
                        Container(
                          width: double.infinity,
                          color: AppStyles.getCardBackground(
                              themeNotifier.currentMode),
                          child: Stack(children: [
                            ClubInfo(club: widget.club),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomBackButton(),
                                    widget.club.owner.id == user.id
                                        ? MenuAnchor(
                                            builder: (BuildContext context,
                                                MenuController controller,
                                                Widget? child) {
                                              return IconButton(
                                                onPressed: () {
                                                  if (controller.isOpen) {
                                                    controller.close();
                                                  } else {
                                                    controller.open();
                                                  }
                                                },
                                                icon: Icon(Icons.more_horiz,
                                                    color: AppStyles
                                                        .getInactiveIcon(
                                                            themeNotifier
                                                                .currentMode),
                                                    size: 32),
                                                tooltip: 'Show menu',
                                              );
                                            },
                                            menuChildren:
                                                List<MenuItemButton>.generate(
                                              2,
                                              (int index) => MenuItemButton(
                                                onPressed: () => {
                                                  setState(() => selectedMenu =
                                                      DropdownItem
                                                          .values[index]),
                                                  if (selectedMenu ==
                                                      DropdownItem.values[0])
                                                    {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditClubPage(
                                                                    club: widget
                                                                        .club)),
                                                      )
                                                    }
                                                  else if (selectedMenu ==
                                                      DropdownItem.values[1])
                                                    {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DeleteClubPage(
                                                                  club: widget
                                                                      .club,
                                                                )),
                                                      )
                                                    }
                                                },
                                                child: Text(populateMenu(
                                                    DropdownItem
                                                        .values[index].name)),
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: AppStyles
                                                        .getCardBackground(
                                                            themeNotifier
                                                                .currentMode),
                                                    title: Text(
                                                        "Report This Club",
                                                        style: TextStyle(
                                                            color: AppStyles
                                                                .getTextPrimary(
                                                                    themeNotifier
                                                                        .currentMode))),
                                                    content: Text(
                                                        "Are you sure you want to report this club because they are not following GCU guidelines?",
                                                        style: TextStyle(
                                                            color: AppStyles
                                                                .getTextPrimary(
                                                                    themeNotifier
                                                                        .currentMode))),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child: Text("Cancel",
                                                            style: TextStyle(
                                                                color: AppStyles
                                                                    .getPrimaryLight(
                                                                        themeNotifier
                                                                            .currentMode))),
                                                      ),
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                          // Add the report logic here
                                                        },
                                                        child: Text(
                                                          "Report",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(8),
                                                child: Icon(Icons.report,
                                                    color: Colors.red,
                                                    size: 32)))
                                  ],
                                )),
                          ]),
                        ),
                      ]),
                );
              }
            },
          ),
        ));
  }
}
