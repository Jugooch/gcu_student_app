import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-user.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

import '../../../../services/services.dart';
import '../../widgets/market/categories-card.dart';
import '../../widgets/market/featured-business-card.dart';
import 'edit-featured.dart';
import 'market-search.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  _MarketPage createState() => _MarketPage();
}

class _MarketPage extends State<MarketPage> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<List<Business>> businessesFuture;
  List<Business> businesses = [];
  late Future<List<Business>> featuredLopesfuture;
  late Future<List<Business>> futureFeaturedLopes;
  List<Business> featuredLopes = [];
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  String searchQuery = ''; // To hold the search query
  late TextEditingController _searchController;
  bool isAdmin = false;

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    futureFeaturedLopes = MarketService().getFeaturedBusinesses();
    businessesFuture = MarketService().getBusinesses();
    fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ///////////////////////
  //Fetch All Data on Events and Articles
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    businesses = await businessesFuture;

    featuredLopes = await MarketService().getFeaturedBusinesses();

    isAdmin = await MarketService().isUserAdmin(user);

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  List<Widget> buildFeaturedCards() {
    List<Widget> featured = featuredLopes
        .map((e) =>
            InkWell(onTap: () {}, child: FeaturedBusinessCard(business: e)))
        .toList();
    return featured;
  }

  void submitSearchQuery(BuildContext context) {
    final searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarketSearch(searchValue: searchQuery),
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
        body: FutureBuilder<List<Business>>(
            future: businessesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Data is still loading
                return Loading();
              } else if (snapshot.hasError) {
                // Handle error state
                return Center(child: Text("Error loading data"));
              } else {
                return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.all(16),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          backgroundImage:
                                              AssetImage(user.image),
                                        ))
                                  ])),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32),
                              child: Row(children: [
                                Expanded(
                                    child: Text(
                                  'Featured Lopes',
                                  style: TextStyle(
                                    color: AppStyles.getTextPrimary(
                                        themeNotifier.currentMode),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                                isAdmin
                                    ? InkWell(
                                        onTap: () => {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditFeatured(
                                                            featured:
                                                                featuredLopes, businesses: businesses)),
                                              )
                                            },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.transparent),
                                            padding: EdgeInsets.all(4),
                                            child: Icon(Icons.edit,
                                                color:
                                                    AppStyles.getPrimaryLight(
                                                        themeNotifier
                                                            .currentMode),
                                                size: 20)))
                                    : Container()
                              ])),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: featuredLopes.isNotEmpty
                                ? SideScrollingWidget(
                                    children: buildFeaturedCards())
                                : Text("No featured business to show..."),
                          ),
                          Padding(
                              padding: EdgeInsets.all(32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Find a Business',
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
                                            hintText:
                                                'Search for a business...',
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
                                                color:
                                                    AppStyles.getPrimaryLight(
                                                        themeNotifier
                                                            .currentMode),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Icon(Icons.search,
                                                color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  CategoriesCard()
                                ],
                              )),
                        ],
                      ),
                    ));
              }
            }));
  }
}
