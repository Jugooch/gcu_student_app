import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/market/user-business-card.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/market/user-info.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

import '../../../../services/services.dart';
import '../../widgets/market/product-card.dart';

class MarketUser extends StatefulWidget {
  const MarketUser({Key? key}) : super(key: key);

  @override
  _MarketUser createState() => _MarketUser();
}

class _MarketUser extends State<MarketUser> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  late Future<List<Business>> userBusinessesFuture;
  List<Business> userBusinesses = [];
  late Future<List<Product>> likedProductsFuture;
  List<Product> likedProducts = [];

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    likedProductsFuture = MarketService().getLikedProducts(user);
    fetchData();
  }

  ///////////////////////
  //Fetch All Data on Events and Articles
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    userBusinessesFuture = MarketService().getUserBusinesses(user);
    userBusinesses = await userBusinessesFuture;
    userBusinesses.add(Business(id: -1, name: "Add", description: "", image: "", ownerId: "", categories: []));

    likedProducts = await likedProductsFuture;

    setState(() {
      // Trigger a rebuild with the fetched data
    });
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
        body: FutureBuilder<List<Product>>(
            future: likedProductsFuture,
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
                color: AppStyles.getCardBackground(themeNotifier.currentMode),
                child:
                    Stack(children: [UserInfo(user: user), CustomBackButton()]),
              ),
              SizedBox(height: 32),
              Padding(padding: EdgeInsets.symmetric(horizontal: 32), child: Text(
                    'Your Businesses',
                    style: TextStyle(
                      color:
                          AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  SizedBox(height: 16),
                  SideScrollingWidget(children: userBusinesses.map((e) => UserBusinessCard(business: e)).toList()),
                  SizedBox(height: 32),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 32), child: Text(
                    'Liked Products',
                    style: TextStyle(
                      color:
                          AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  SizedBox(height: 16),
                  SideScrollingWidget(children: likedProducts.map((e) => ProductCard(product: e)).toList()),
                  SizedBox(height: 16)
                ]),
        );}}));
  }
}
