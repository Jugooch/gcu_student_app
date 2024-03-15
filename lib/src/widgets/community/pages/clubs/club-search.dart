import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/clubs/search-club-card.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/market/business-card.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

import '../../../../services/services.dart';

class ClubSearch extends StatefulWidget {
  String category;
  String searchValue;
  ClubSearch({Key? key, this.category = "All", this.searchValue = ""})
      : super(key: key);

  @override
  _ClubSearch createState() => _ClubSearch();
}

class _ClubSearch extends State<ClubSearch> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  List<Club> clubs = [];
  late Future<List<Club>> clubsFuture;
  String searchQuery = "";
  String selectedCategory = 'All';
  int selectedTabIndex = 0;
  late TextEditingController _searchController;

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (widget.searchValue != "") {
      _searchController.text = widget.searchValue;
    }
    searchQuery = widget.searchValue;
    selectedCategory = widget.category;
    // Initialize data fetching based on the selected tab
    clubsFuture = _fetchItems();
  }

  Future<List<Club>> _fetchItems() async {
    return ClubsService()
        .getFilteredClubs(category: selectedCategory, search: searchQuery);
  }

  void _updateItems() {
    setState(() {
      clubsFuture = _fetchItems();
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      clubsFuture = _fetchItems(); // Fetch data with the updated search query
    });
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      clubsFuture = _fetchItems(); // Fetch data with the updated search query
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
        hintText: 'Search for a club...',
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

  //Builds out the filter buttons widget for the page
  Widget buildFilterButtons(ThemeNotifier themeNotifier) {
    List<String> categories = [
      'All',
      'Technology',
      'Nature',
      'Sports',
      'Entertainment',
      'Creative',
      'Volunteering',
      'Diversity',
      'Hobbies',
      'Professional',
      'Other'
    ];
    List<Widget> categoryButtons = categories.map((category) {
      return ElevatedButton(
        onPressed: () => selectCategory(category),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: selectedCategory == category
                  ? Colors.transparent
                  : AppStyles.getTextTertiary(themeNotifier.currentMode),
              width: 1.0, // Specify the border width
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          backgroundColor: selectedCategory == category
              ? AppStyles.getPrimaryLight(themeNotifier.currentMode)
              : AppStyles.getBackground(themeNotifier.currentMode),
          foregroundColor: selectedCategory == category
              ? Colors.white
              : AppStyles.getTextTertiary(themeNotifier.currentMode),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Text(category),
        ),
      );
    }).toList();

    // Use SideScrollingWidget to display category buttons
    return SideScrollingWidget(
      children: categoryButtons,
    );
  }

  buildResults(themeNotifier, listItems) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: 32.0, right: 32.0, left: 32.0, top: 16.0),
        child: listItems.length != 0
            ? Column(
                children: listItems.map<Widget>((e) {
                  return Column(
                    children: [
                      SearchClubCard(club: e),
                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              )
            : Text("No clubs...",
                style: TextStyle(
                    color:
                        AppStyles.getTextPrimary(themeNotifier.currentMode))));
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
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
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBackButton(),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: buildSearchBar(themeNotifier)),
                    SizedBox(height: 16),
                    buildFilterButtons(themeNotifier),
                    SizedBox(height: 32),
                    FutureBuilder<List<Club>>(
                        future: clubsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Data is still loading
                            return Loading();
                          } else if (snapshot.hasError) {
                            // Handle error state
                            return Center(child: Text("Error loading data"));
                          } else {
                            return buildResults(themeNotifier, snapshot.data!);
                          }
                        })
                  ]),
            )));
  }
}
