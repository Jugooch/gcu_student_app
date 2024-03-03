import 'package:flutter/cupertino.dart';
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
import '../../widgets/market/business-info.dart';
import '../../widgets/market/condensed-product-card.dart';
import '../../widgets/market/product-card.dart';

class MarketBusiness extends StatefulWidget {
  final Business business;
  const MarketBusiness({Key? key, required this.business}) : super(key: key);

  @override
  _MarketBusiness createState() => _MarketBusiness();
}

class _MarketBusiness extends State<MarketBusiness> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  List<Product> featuredProducts = [];
  late Future<List<Product>> productsFuture;
  List<Product> products = [];

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    productsFuture = MarketService().getProducts(widget.business.id);
    fetchData();
  }

  ///////////////////////
  //Fetch All Data on Events and Articles
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    products = await productsFuture;

    featuredProducts =
        products.where((element) => element.featured == true).toList();

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: CupertinoNavigationBar(
                  border: null,
                  backgroundColor:
                      AppStyles.getPrimary(themeNotifier.currentMode),
                  middle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/GCU_Logo.png',
                        height: 32.0,
                      ),
                    ],
                  ),
                ),
        backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
        body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Data is still loading
            return Loading();
          } else if (snapshot.hasError) {
            // Handle error state
            return Center(child: Text("Error loading data"));
          } else {
            return SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity,
              color: AppStyles.getCardBackground(themeNotifier.currentMode),
              child: Stack(children: [
                BusinessInfo(business: widget.business),
                CustomBackButton()
              ]),
            ),
            SizedBox(height: 32),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Featured Products',
                  style: TextStyle(
                    color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(height: 16),
            featuredProducts.length != 0
                ? SideScrollingWidget(
                    children: featuredProducts
                        .map((e) => ProductCard(product: e))
                        .toList())
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text("No featured products...",
                        style: TextStyle(
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode)))),
            SizedBox(height: 32),
            Padding(
                padding: EdgeInsets.only(bottom: 32, left: 32, right: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Products',
                      style: TextStyle(
                        color:
                            AppStyles.getTextPrimary(themeNotifier.currentMode),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    //ChatGPT helped me figure out the syntax for accomplishing this layout
                    products.length != 0
                        ? Column(
                            children: List.generate(
                                (products.length / 2).ceil(), (index) {
                              // Check if it is the last row with only one item (in case of odd number of products)
                              bool isLastItemSingle =
                                  products.length % 2 != 0 &&
                                      index == (products.length / 2).ceil() - 1;

                              return Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // This will give a "space-between" effect
                                  children: [
                                    Expanded(
                                      child: CondensedProductCard(
                                          product: products[index *
                                              2]), // First item of the pair
                                    ),
                                    if (!isLastItemSingle)
                                      SizedBox(
                                          width:
                                              16), // Add space only if there's a second item
                                    !isLastItemSingle
                                        ? // Check if there's a second item in this row
                                        Expanded(
                                            child: CondensedProductCard(
                                                product: products[index * 2 +
                                                    1]), // Second item of the pair
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
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode))),
                  ],
                )),
          ]),
        );
          }
        },
      ),
    );
  }
}
