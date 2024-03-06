import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class MarketSearch extends StatefulWidget {
  String category;
  String searchValue;
  MarketSearch({Key? key, this.category = "All", this.searchValue = ""})
      : super(key: key);

  @override
  _MarketSearch createState() => _MarketSearch();
}

class _MarketSearch extends State<MarketSearch> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  List<Product> products = [];
  List<Business> businesses = [];
  late Future<List<dynamic>> itemsFuture;
  String searchQuery = "";
  String selectedCategory = 'All';
  int selectedTabIndex = 0;

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    searchQuery = widget.searchValue;
    selectedCategory = widget.category;
    // Initialize data fetching based on the selected tab
    itemsFuture = _fetchItems();
  }

  Future<List<dynamic>> _fetchItems() async {
    // Assuming MarketService has a method that can fetch both products and businesses based on parameters
    if (selectedTabIndex == 0) {
      return MarketService()
          .getFilteredProducts(category: selectedCategory, search: searchQuery);
    } else {
      return MarketService().getFilteredBusinesses(
          category: selectedCategory, search: searchQuery);
    }
  }

  void _updateItems() {
    setState(() {
      itemsFuture = _fetchItems();
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      itemsFuture = _fetchItems(); // Fetch data with the updated search query
    });
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      itemsFuture = _fetchItems(); // Fetch data with the updated search query
    });
  }

  Widget buildSearchBar(ThemeNotifier themeNotifier) {
    return TextField(
      style: TextStyle(
        color: AppStyles.getTextPrimary(
            themeNotifier.currentMode), // Set text color
      ),
      decoration: InputDecoration(
        hintText: 'Search for a product...',
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

  buildResults(themeNotifier, listItems) {
    if (selectedTabIndex == 0) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: 32.0, right: 32.0, left: 32.0, top: 16.0),
        child: listItems.length != 0
            ? Column(
                children: List.generate((listItems.length / 2).ceil(), (index) {
                  // Check if it is the last row with only one item (in case of odd number of products)
                  bool isLastItemSingle = listItems.length % 2 != 0 &&
                      index == (listItems.length / 2).ceil() - 1;

                  return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // This will give a "space-between" effect
                      children: [
                        Expanded(
                          child: CondensedProductCard(
                              product: listItems[
                                  index * 2], isEdit: false,), // First item of the pair
                        ),
                        SizedBox(
                            width:
                                16), // Add space only if there's a second item
                        !isLastItemSingle
                            ? // Check if there's a second item in this row
                            Expanded(
                                child: CondensedProductCard(
                                    product: listItems[index * 2 +
                                        1], isEdit: false,), // Second item of the pair
                              )
                            : Expanded(child: Container())
                      ],
                    ),
                    SizedBox(height: 16)
                  ]);
                }),
              )
            : Text("No products...",
                style: TextStyle(
                    color:
                        AppStyles.getTextPrimary(themeNotifier.currentMode))),
      );
    } else {
      return Padding(
          padding:
              EdgeInsets.only(bottom: 32.0, right: 32.0, left: 32.0, top: 16.0),
          child: listItems.length != 0
              ? Column(
                  children: listItems.map<Widget>((e) {
                    return Column(
                      children: [
                        BusinessCard(business: e),
                        SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                )
              : Text("No businesses...",
                  style: TextStyle(
                      color: AppStyles.getTextPrimary(
                          themeNotifier.currentMode))));
    }
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
                                // Set the selected tab index to 0 (Products)
                                selectedTabIndex = 0;
                                itemsFuture = _fetchItems();
                                setState(() {
                                  //update UI
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
                                    "Products",
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
                                // Set the selected tab index to 1 (Businesses)
                                selectedTabIndex = 1;
                                itemsFuture = _fetchItems();
                                setState(() {
                                  //update UI
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
                                    "Business",
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
                        ],
                      ),
                    ),
                    FutureBuilder<List<dynamic>>(
                        future: itemsFuture,
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
