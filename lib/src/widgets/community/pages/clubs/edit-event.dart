import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/clubs/edit-event-card.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:provider/provider.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';

class EditEventsPage extends StatefulWidget {
  final User user;
  final List<Event> events;
  final Club club;
  const EditEventsPage(
      {required this.user, Key? key, required this.events, required this.club})
      : super(key: key);

  @override
  _EditEventsPageState createState() => _EditEventsPageState();
}

class _EditEventsPageState extends State<EditEventsPage> {
  late TextEditingController _searchController;
  String searchQuery = "";

  List<Event> filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredEvents = widget.events;
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      if (searchQuery.isEmpty) {
        filteredEvents = widget.events;
      } else {
        filteredEvents = widget.events
            .where((article) =>
                article.title.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  Widget buildSearchBar(ThemeNotifier themeNotifier) {
    return TextField(
      controller: _searchController,
      style: TextStyle(
        color: AppStyles.getTextPrimary(
            themeNotifier.currentMode), // Set text color
      ),
      decoration: InputDecoration(
        hintText: 'Search for an event...',
        hintStyle: TextStyle(
          color: AppStyles.getInactiveIcon(
              themeNotifier.currentMode), // Set hint text color
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppStyles.getTextPrimary(
              themeNotifier.currentMode), // Set icon color
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppStyles.getTextPrimary(
                themeNotifier.currentMode), // Set border color
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppStyles.getTextPrimary(themeNotifier
                .currentMode), // Set border color when the TextField is focused
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onChanged: updateSearchQuery,
    );
  }

  buildResults(themeNotifier, listItems) {
    return Container(
        child: listItems.length != 0
            ? Column(
                children: listItems.map<Widget>((e) {
                  return Column(
                    children: [
                      EditEventCard(
                          event: e, user: widget.user, club: widget.club),
                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              )
            : Text("No events...",
                style: TextStyle(
                    color:
                        AppStyles.getTextPrimary(themeNotifier.currentMode))));
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
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
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomBackButton(),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSearchBar(themeNotifier),
                    SizedBox(height: 32),
                    buildResults(themeNotifier, filteredEvents)
                  ]),
            ),
          ]),
        ));
  }
}
