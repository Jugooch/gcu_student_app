import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/market/business-card.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/market/user-business-card.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

import '../../../../services/services.dart';
import '../../widgets/market/condensed-product-card.dart';
import 'market-user.dart';

class EditFeatured extends StatefulWidget {
  List<Business> featured;
  List<Business> businesses;
  EditFeatured({Key? key, required this.featured, required this.businesses}) : super(key: key);

  @override
  _EditFeatured createState() => _EditFeatured();
}

class _EditFeatured extends State<EditFeatured> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  String selectedCategory = 'All';
  late TextEditingController _searchController;
  String searchQuery = "";

  List<Business> filteredBusinesses = [];

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredBusinesses = widget.businesses;
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      if (searchQuery.isEmpty) {
        filteredBusinesses = widget.businesses;
      } else {
        filteredBusinesses = widget.businesses
            .where((business) =>
                business.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredBusinesses = widget.businesses;
      if (selectedCategory != 'ALL') {
        filteredBusinesses = filteredBusinesses
            .where((element) => element.categories.contains(selectedCategory))
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
        hintText: 'Search for a featured business...',
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
      'Clothes',
      'Art',
      'Services',
      'Crafts',
      'Food',
      'Technology',
      'Furniture',
      'Home Supplies',
      'Cosmetics',
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

  buildResults(themeNotifier, List<Business> listItems) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: 32.0, right: 32.0, left: 32.0, top: 16.0),
        child: listItems.length != 0
            ? Column(
                children: listItems.map<Widget>((e) {
                  return Column(
                    children: [
                      Row(children: [
                        Expanded(
                          child: BusinessCard(business: e),
                        ),
                        SizedBox(width: 16),
                        widget.featured.any((element) => element.id == e.id) ?
                        InkWell(
                          onTap: () => {
                            //TODO Implement removing a featured business
                          },
                          child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20,
                              )),
                        ) :                         InkWell(
                          onTap: () => {
                            //TODO Implement removing a featured business
                          },
                          child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: AppStyles.getPrimaryLight(themeNotifier.currentMode)),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              )),
                        )
                      ]),
                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              )
            : Text("No featured businesses...",
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
                    Container(
                        margin: EdgeInsets.all(16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomBackButton(),
                              InkWell(
                                  onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MarketUser()),
                                        )
                                      },
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(user.image),
                                  ))
                            ])),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: buildSearchBar(themeNotifier)),
                    SizedBox(height: 16),
                    buildFilterButtons(themeNotifier),
                    SizedBox(height: 32),
                    buildResults(themeNotifier, filteredBusinesses)
                  ]),
            )));
  }
}
