import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/pages/hours-page/widgets/hours-card.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

class HoursPage extends StatefulWidget {
  const HoursPage({Key? key}) : super(key: key);

  @override
  _HoursPageState createState() => _HoursPageState();
}

class _HoursPageState extends State<HoursPage> {
  late Future<List<Vendor>> futureVendors;
  List<Vendor> vendors = [];
  List<Vendor> filteredVendors = []; // To hold the filtered list of vendors
  String searchQuery = ''; // To hold the search query
  String selectedCategory = 'All'; // To hold the selected category

  @override
  void initState() {
    super.initState();
    futureVendors = HoursService().getVendors();
    fetchData();
  }

  Future<void> fetchData() async {
    vendors = await futureVendors;
    applyFilters();
  }

  //Method for the filter buttons to use
  //Filters by a specific category
  void applyFilters() {
    List<Vendor> tempVendors = vendors;
    // Filter by category if not 'All'
    if (selectedCategory != 'All') {
      tempVendors = tempVendors
          .where((vendor) => vendor.category == selectedCategory)
          .toList();
    }
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      tempVendors = tempVendors
          .where((vendor) =>
              vendor.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredVendors = tempVendors;
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      applyFilters();
    });
  }

//Builds out the search bar widget for the page
  Widget buildSearchBar(ThemeNotifier themeNotifier) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 32.0, right: 32.0, top: 16.0, bottom: 16.0),
      child: TextField(
        style: TextStyle(
          color: AppStyles.getTextPrimary(
              themeNotifier.currentMode), // Set text color
        ),
        decoration: InputDecoration(
          hintText: 'Search for a business...',
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
      ),
    );
  }

//Builds out the filter buttons widget for the page
  Widget buildFilterButtons(ThemeNotifier themeNotifier) {
    List<String> categories = ['All', 'Food', 'Gyms', 'Other'];
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

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return GestureDetector(
        onTap: () {
          // Call this method to hide the keyboard when tapping outside
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
            body: FutureBuilder<List<Vendor>>(
                future: futureVendors,
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
                          buildSearchBar(
                              themeNotifier), // Insert the search bar
                          buildFilterButtons(
                              themeNotifier), // Insert the filter buttons
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 32.0,
                                right: 32.0,
                                left: 32.0,
                                top: 16.0),
                            child: Column(
                              children: filteredVendors.map((vendor) {
                                // Use filteredVendors here
                                return HoursCard(vendor: vendor);
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                })));
  }
}
