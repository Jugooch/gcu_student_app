import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/clubs/condensed-event-card.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/clubs/member_card.dart';
import 'package:gcu_student_app/src/widgets/events/widgets/events_card.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../services/services.dart';
import '../../widgets/clubs/club-info.dart';
import 'add-event.dart';
import 'delete-club.dart';
import 'edit-club.dart';
import 'edit-event.dart';

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
  int selectedTabIndex = 0;

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

    events = await eventsFuture;

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

  ///////////////////////////////////////////////////////////////////////////
  ///*TODO* Update this method to actually add a user to a club in a database
  ///////////////////////////////////////////////////////////////////////////
  joinClub() {
    if (widget.club.autoAccept) {
      print("user joining club");
    } else {
      ///////////////////////////////////////////////////////////////////////////
      ///*TODO* Implement an approval process for club owners/intramural team owners
      ///////////////////////////////////////////////////////////////////////////
      print("Sending request to join club...");
    }
  }

  Event getUpcomingEvent() {
    // Assuming the current date
    DateTime now = DateTime.now();

    // Sort the list of events based on the date in ascending order
    List<Event> sortedEvents = List.from(events)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Find the first event that is on or after the current date
    Event upcomingEvent = sortedEvents.firstWhere(
        (event) => event.date.isAfter(now) || event.date.isAtSameMomentAs(now));

    return upcomingEvent;
  }

  List<Event> getThisWeeksEvents() {
    DateTime now = DateTime.now();
    DateTime oneWeekFromNow = now.add(Duration(days: 7));

    // Sort the list of events based on the date in ascending order
    List<Event> sortedEvents = List.from(events)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Find the events that are within a week of the current day
    List<Event> eventsWithinAWeek = sortedEvents
        .where((event) =>
            event.date.isAfter(now) && event.date.isBefore(oneWeekFromNow))
        .toList();

    return eventsWithinAWeek;
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    int rosterNum = widget.club.members.length;
    int rosterCount = 0;
    List<Member> roster = widget.club.members
        .where((element) => element.name != widget.club.owner.name)
        .toList();
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
                                                                    user: user,
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
                                                                  user: user,
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
                        Container(
                          decoration: BoxDecoration(
                            color: AppStyles.getCardBackground(
                                themeNotifier.currentMode),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Set the selected tab index to 0 (Current Leagues)
                                    setState(() {
                                      selectedTabIndex = 0;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 24),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: selectedTabIndex == 0
                                              ? AppStyles.getPrimaryLight(
                                                  themeNotifier.currentMode)
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Club Info",
                                        style: TextStyle(
                                          color: selectedTabIndex == 0
                                              ? AppStyles.getPrimaryLight(
                                                  themeNotifier.currentMode)
                                              : AppStyles.getTextPrimary(
                                                  themeNotifier.currentMode),
                                          fontSize: 16,
                                          fontWeight: selectedTabIndex == 0
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Set the selected tab index to 1 (Scheduled Leagues)
                                    setState(() {
                                      selectedTabIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 24),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: selectedTabIndex == 1
                                              ? AppStyles.getPrimaryLight(
                                                  themeNotifier.currentMode)
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Events",
                                        style: TextStyle(
                                          color: selectedTabIndex == 1
                                              ? AppStyles.getPrimaryLight(
                                                  themeNotifier.currentMode)
                                              : AppStyles.getTextPrimary(
                                                  themeNotifier.currentMode),
                                          fontSize: 16,
                                          fontWeight: selectedTabIndex == 1
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Set the selected tab index to 1 (Past Leagues)
                                    setState(() {
                                      selectedTabIndex = 2;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 24),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: selectedTabIndex == 2
                                              ? AppStyles.getPrimaryLight(
                                                  themeNotifier.currentMode)
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Members",
                                        style: TextStyle(
                                          color: selectedTabIndex == 2
                                              ? AppStyles.getPrimaryLight(
                                                  themeNotifier.currentMode)
                                              : AppStyles.getTextPrimary(
                                                  themeNotifier.currentMode),
                                          fontSize: 16,
                                          fontWeight: selectedTabIndex == 2
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///////////////
                        ///Club Info
                        ///////////////
                        Visibility(
                            visible: (selectedTabIndex == 0),
                            child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      !(widget.club.members
                                              .any((e) => e.id == user.id))
                                          ? Container(
                                              height: 80.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  joinClub();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    AppStyles.getPrimaryDark(
                                                        themeNotifier
                                                            .currentMode),
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Join Club',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                  "Member since " +
                                                      DateFormat(
                                                              'MMMM dd, yyyy')
                                                          .format(widget
                                                              .club.members
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      user.id)
                                                              .joinDate),
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode)))),
                                      SizedBox(height: 32),
                                      Text(
                                        'Upcoming Event',
                                        style: TextStyle(
                                          color: AppStyles.getTextPrimary(
                                              themeNotifier.currentMode),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      events.isNotEmpty
                                          ? Center(
                                              child: EventCard(
                                                  event: getUpcomingEvent(),
                                                  otherEvents: events
                                                      .where((element) =>
                                                          element !=
                                                          getUpcomingEvent())
                                                      .toList()))
                                          : Text("No events...",
                                              style: TextStyle(
                                                  color:
                                                      AppStyles.getTextPrimary(
                                                          themeNotifier
                                                              .currentMode)))
                                    ]))),

                        ///////////////
                        ///Events
                        ///////////////
                        Visibility(
                            visible: (selectedTabIndex == 1),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 32),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 32),
                                    child: Text(
                                      'Events This Week',
                                      style: TextStyle(
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier.currentMode),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  getThisWeeksEvents().isNotEmpty
                                      ? SideScrollingWidget(
                                          children: getThisWeeksEvents()
                                              .map((e) => EventCard(
                                                  event: e,
                                                  otherEvents: events))
                                              .toList())
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 32),
                                          child: Text("No events...",
                                              style: TextStyle(
                                                  color:
                                                      AppStyles.getTextPrimary(
                                                          themeNotifier
                                                              .currentMode)))),
                                  SizedBox(height: 32),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 32),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'All Events',
                                            style: TextStyle(
                                              color: AppStyles.getTextPrimary(
                                                  themeNotifier.currentMode),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                          isOwner
                                              ? InkWell(
                                                  onTap: () => {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddEventPage(
                                                                      user:
                                                                          user,
                                                                      club: widget
                                                                          .club)),
                                                        )
                                                      },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: AppStyles
                                                              .getPrimaryLight(
                                                                  themeNotifier
                                                                      .currentMode)),
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Icon(Icons.add,
                                                          color: Colors.white,
                                                          size: 16)))
                                              : Container(),
                                          isOwner
                                              ? SizedBox(width: 16)
                                              : Container(),
                                          isOwner
                                              ? InkWell(
                                                  onTap: () => {
                                                        //Navigator.push(
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EditEventsPage(
                                                                    user: user,
                                                                    events:
                                                                        events,
                                                                    club: widget
                                                                        .club,
                                                                  )),
                                                        )
                                                      },
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors
                                                              .transparent),
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      child: Icon(Icons.edit,
                                                          color: AppStyles
                                                              .getPrimaryLight(
                                                                  themeNotifier
                                                                      .currentMode),
                                                          size: 20)))
                                              : Container(),
                                        ]),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 32,
                                          right: 32,
                                          top: 16,
                                          bottom: 16),
                                      child: Column(
                                          children: events
                                              .map((e) => CondensedEventCard(
                                                  event: e,
                                                  otherEvents: events))
                                              .toList()))
                                ])),

                        ///////////////
                        ///Members
                        ///////////////
                        Visibility(
                            visible: (selectedTabIndex == 2),
                            child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Owner",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier.currentMode))),
                                    SizedBox(height: 16),
                                    MemberCard(
                                        member: widget.club.owner,
                                        isOwner: true),
                                    if (!(widget.club.members
                                        .any((e) => e.id == user.id)))
                                      Container(
                                        height: 80.0,
                                        margin: EdgeInsets.only(top: 32),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            joinClub();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              AppStyles.getPrimaryDark(
                                                  themeNotifier.currentMode),
                                            ),
                                            minimumSize:
                                                MaterialStateProperty.all(
                                              const Size(0.5, 0), // 50% width
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Join Club',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        height: 80.0,
                                        margin: EdgeInsets.only(top: 32),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (user.id ==
                                                widget.club.owner.id) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Select a new owner",
                                                        style: TextStyle(
                                                            color: AppStyles
                                                                .getTextPrimary(
                                                                    themeNotifier
                                                                        .currentMode))),
                                                    backgroundColor: AppStyles
                                                        .getCardBackground(
                                                            themeNotifier
                                                                .currentMode),
                                                    content: Container(
                                                      // Optionally, set a specific height
                                                      width: double.maxFinite,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: widget.club
                                                            .members.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          if (widget
                                                                  .club
                                                                  .members[
                                                                      index]
                                                                  .id ==
                                                              user.id) {
                                                            return Container(); // Don't show the current user
                                                          }
                                                          return ListTile(
                                                            title: Text(
                                                                widget
                                                                    .club
                                                                    .members[
                                                                        index]
                                                                    .name,
                                                                style: TextStyle(
                                                                    color: AppStyles.getTextPrimary(
                                                                        themeNotifier
                                                                            .currentMode))),
                                                            onTap: () {
                                                              /////////////////////////////////////////////////////////////////
                                                              // *TODO* Implement logic to set the selected member as the new captain
                                                              /////////////////////////////////////////////////////////////////
                                                              ///
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the dialog
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: Text("Cancel",
                                                            style: TextStyle(
                                                                color: AppStyles
                                                                    .getPrimaryLight(
                                                                        themeNotifier
                                                                            .currentMode))),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
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
                                                        "Leave This Club",
                                                        style: TextStyle(
                                                            color: AppStyles
                                                                .getTextPrimary(
                                                                    themeNotifier
                                                                        .currentMode))),
                                                    content: Text(
                                                        "Are you sure you want to leave this club?",
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
                                                              .pop();

                                                          /////////////////////////////////////////////////////////////////
                                                          // *TODO* Implement logic to let a user leave the team
                                                          /////////////////////////////////////////////////////////////////
                                                          print(
                                                              "User tried leaving! Ha!");
                                                        },
                                                        child: Text(
                                                          "Leave",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              AppStyles.getPrimaryDark(
                                                  themeNotifier.currentMode),
                                            ),
                                            minimumSize:
                                                MaterialStateProperty.all(
                                              const Size(0.5, 0), // 50% width
                                            ),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Leave Club',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 32),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Club Members",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppStyles.getTextPrimary(
                                                    themeNotifier
                                                        .currentMode))),
                                        Text("${widget.club.members.length}")
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: roster.map<Widget>((e) {
                                        rosterCount++;
                                        return Column(
                                          children: [
                                            MemberCard(
                                                member: e, isOwner: false),
                                            if (rosterCount != rosterNum)
                                              SizedBox(height: 16)
                                          ],
                                        );
                                      }).toList(),
                                    )
                                  ],
                                )))
                      ]),
                );
              }
            },
          ),
        ));
  }
}
