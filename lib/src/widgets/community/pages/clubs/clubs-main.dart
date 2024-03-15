import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/clubs/categories-card.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/clubs/club-card.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

import 'club-create.dart';
import 'club-search.dart';

class ClubsPage extends StatefulWidget {
  final User user;
  const ClubsPage({Key? key, required this.user}) : super(key: key);

  @override
  _ClubsPage createState() => _ClubsPage();
}

class _ClubsPage extends State<ClubsPage> {
  late Future<List<Club>> futureJoinedClubs;
  List<Club> joinedClubs = [];

  String searchQuery = ''; // To hold the search query
  late TextEditingController _searchController;

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    futureJoinedClubs = ClubsService().getUserClubs(widget.user);
    fetchData();
  }

  fetchData() async {
    joinedClubs = await futureJoinedClubs;

    setState(() {});
  }

  void submitSearchQuery(BuildContext context) {
    final searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClubSearch(searchValue: searchQuery),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
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
        body: FutureBuilder<List<Club>>(
            future: futureJoinedClubs,
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
                        padding: EdgeInsets.only(right: 32.0, left: 32.0),
                        child: Text("Joined Clubs",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode))),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SideScrollingWidget(
                          children: joinedClubs.map(
                        (e) {
                          return ClubCard(club: e);
                        },
                      ).toList()),
                      Padding(
                          padding: EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Find a Club',
                                style: TextStyle(
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      style: TextStyle(
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier
                                                .currentMode), // Set text color
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Search for a club...',
                                        hintStyle: TextStyle(
                                          color: AppStyles.getInactiveIcon(
                                              themeNotifier
                                                  .currentMode), // Set hint text color
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: AppStyles.getTextPrimary(
                                              themeNotifier
                                                  .currentMode), // Set icon color
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier
                                                    .currentMode), // Set border color
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier
                                                    .currentMode), // Set border color when the TextField is focused
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  InkWell(
                                    onTap: () => submitSearchQuery(context),
                                    child: Container(
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            color: AppStyles.getPrimaryLight(
                                                themeNotifier.currentMode),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Icon(Icons.search,
                                            color: Colors.white)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              CategoriesCard(),
                              SizedBox(height: 32),
                              Text(
                                'Not Finding What You Want?',
                                style: TextStyle(
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                height: 80.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateClub(user: widget.user),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      AppStyles.getPrimaryDark(
                                          themeNotifier.currentMode),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Create Club',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                );
              }
            }));
  }
}
