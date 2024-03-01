import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-user.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

import '../../../../services/services.dart';
import '../../widgets/market/categories-card.dart';
import '../../widgets/market/featured-business-card.dart';

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
  List<Business> featuredLopes = [];
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  String searchQuery = ''; // To hold the search query

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  ///////////////////////
  //Fetch All Data on Events and Articles
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    businessesFuture = MarketService().getBusinesses();
    businesses = await businessesFuture;

    featuredLopes = await MarketService().getFeaturedBusinesses();

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  List<Widget> buildFeaturedCards() {
    List<Widget> featured =
        featuredLopes.map((e) => InkWell(onTap: () {
          
        }, child: FeaturedBusinessCard(business: e))).toList();
    return featured;
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(11),
            child: Container(
              color: const Color(0xFF522498),
            )),
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
                                        builder: (context) => MarketUser()),
                                  )
                                },
                            child: CircleAvatar(
                              backgroundImage: AssetImage(user.image),
                            ))
                      ])),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Featured Lopes',
                    style: TextStyle(
                      color:
                          AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: featuredLopes.isNotEmpty
                    ? SideScrollingWidget(children: buildFeaturedCards())
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
                      TextField(
                        style: TextStyle(
                          color: AppStyles.getTextPrimary(
                              themeNotifier.currentMode), // Set text color
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search for a business...',
                          hintStyle: TextStyle(
                            color: AppStyles.getInactiveIcon(themeNotifier
                                .currentMode), // Set hint text color
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode), // Set icon color
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.getTextPrimary(themeNotifier
                                  .currentMode), // Set border color
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
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 16),
                      CategoriesCard()
                    ],
                  )),
            ],
          ),
        ));
  }
}
