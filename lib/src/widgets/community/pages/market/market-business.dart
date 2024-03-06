import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-add-product.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-edit-business.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-edit-products.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';

import '../../../../services/services.dart';
import '../../widgets/market/business-info.dart';
import '../../widgets/market/condensed-product-card.dart';
import '../../widgets/market/product-card.dart';
import 'market-remove-business.dart';

class MarketBusiness extends StatefulWidget {
  final Business business;
  const MarketBusiness({Key? key, required this.business}) : super(key: key);

  @override
  _MarketBusiness createState() => _MarketBusiness();
}

// This is the type used by the menu below.
enum DropdownItem { editBusiness, deleteBusiness }

class _MarketBusiness extends State<MarketBusiness> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  List<Product> featuredProducts = [];
  late Future<List<Product>> productsFuture;
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String searchQuery = '';
  bool isOwner = false;

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    if (widget.business.id == null) {
      // Handle the null case, e.g., show an error or use a default value
      throw Exception("Business ID is null");
    } else {
      productsFuture = MarketService().getProducts(widget.business.id!);
    }
    fetchData();
  }

  ///////////////////////
  //Fetch All Data on Events and Articles
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    if (user.id == widget.business.ownerId) {
      isOwner = true;
    }

    products = await productsFuture;

    featuredProducts =
        products.where((element) => element.featured == true).toList();

    applyFilters();

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  void applyFilters() {
    // Apply search filtering
    setState(() {
      filteredProducts = searchQuery.isEmpty
          ? products
          : products
              .where((product) => product.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
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

  populateMenu(item) {
    switch (item) {
      case "editBusiness":
        return "Edit Business";
      case "deleteBusiness":
        return "Delete Business";
    }
  }

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    DropdownItem? selectedMenu;
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          color: AppStyles.getCardBackground(
                              themeNotifier.currentMode),
                          child: Stack(children: [
                            BusinessInfo(business: widget.business),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomBackButton(),
                                    widget.business.ownerId == user.id ?
                                    MenuAnchor(
                                      builder: (BuildContext context,
                                          MenuController controller,
                                          Widget? child) {
                                        return IconButton(
                                          onPressed: () {
                                            if (controller.isOpen) {
                                              controller.close();
                                            } else {
                                              controller.open();
                                            }
                                          },
                                          icon: Icon(Icons.more_horiz,
                                              color: AppStyles.getInactiveIcon(
                                                  themeNotifier.currentMode),
                                              size: 32),
                                          tooltip: 'Show menu',
                                        );
                                      },
                                      menuChildren:
                                          List<MenuItemButton>.generate(
                                        2,
                                        (int index) => MenuItemButton(
                                          onPressed: () => {
                                            setState(() => selectedMenu =
                                                DropdownItem.values[index]),
                                            if (selectedMenu ==
                                                DropdownItem.values[0])
                                              {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditBusinessPage(
                                                              business: widget
                                                                  .business,
                                                              user: user)),
                                                )
                                              }
                                            else if (selectedMenu ==
                                                DropdownItem.values[1])
                                              {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RemoveBusinessPage(
                                                              business: widget
                                                                  .business,
                                                              user: user)),
                                                )
                                              }
                                          },
                                          child: Text(populateMenu(
                                              DropdownItem.values[index].name)),
                                        ),
                                      ),
                                    ) : InkWell(
                                      onTap: () {
                                        showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: AppStyles.getCardBackground(themeNotifier.currentMode),
                                      title: Text(
                                          "Report This Business", style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode))),
                                      content: Text(
                                          "Are you sure you want to report this business because they are not following our guidelines for the student marketplace?", style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode))),
                                      actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text("Cancel", style: TextStyle(color: AppStyles.getPrimaryLight(themeNotifier.currentMode))),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .red,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                  // Add the report logic here
                                                },
                                                child: Text(
                                                  "Report",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                    );
                                  },
                                );
                                      },
                                      child:Container(padding: EdgeInsets.all(8), child:  Icon(Icons.report, color: Colors.red, size: 32)))
                                  ],
                                )),
                          ]),
                        ),
                        SizedBox(height: 32),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Featured Products',
                              style: TextStyle(
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
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
                            padding: EdgeInsets.only(
                                bottom: 32, left: 32, right: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'All Products',
                                        style: TextStyle(
                                          color: AppStyles.getTextPrimary(
                                              themeNotifier.currentMode),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                      InkWell(
                                          onTap: () => {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddProductPage(
                                                            user: user,
                                                            business:
                                                                widget.business,
                                                          )),
                                                )
                                              },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      AppStyles.getPrimaryLight(
                                                          themeNotifier
                                                              .currentMode)),
                                              padding: EdgeInsets.all(8),
                                              child: Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 16))),
                                      SizedBox(width: 16),
                                      InkWell(
                                          onTap: () => {
                                                //Navigator.push(
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MarketEditProducts(
                                                            products: products,
                                                          )),
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
                                                  size: 20))),
                                    ]),

                                SizedBox(height: 16),
                                buildSearchBar(themeNotifier),
                                SizedBox(height: 16),
                                //ChatGPT helped me figure out the syntax for accomplishing this layout
                                filteredProducts.length != 0
                                    ? Column(
                                        children: List.generate(
                                            (filteredProducts.length / 2)
                                                .ceil(), (index) {
                                          // Check if it is the last row with only one item (in case of odd number of products)
                                          bool isLastItemSingle =
                                              filteredProducts.length % 2 !=
                                                      0 &&
                                                  index ==
                                                      (filteredProducts.length /
                                                                  2)
                                                              .ceil() -
                                                          1;

                                          return Column(children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween, // This will give a "space-between" effect
                                              children: [
                                                Expanded(
                                                  child: CondensedProductCard(
                                                      product: filteredProducts[
                                                          index *
                                                              2], isEdit: false,), // First item of the pair
                                                ),
                                                if (!isLastItemSingle)
                                                  SizedBox(
                                                      width:
                                                          16), // Add space only if there's a second item
                                                !isLastItemSingle
                                                    ? // Check if there's a second item in this row
                                                    Expanded(
                                                        child: CondensedProductCard(
                                                            product:
                                                                filteredProducts[
                                                                    index * 2 +
                                                                        1], isEdit: false,), // Second item of the pair
                                                      )
                                                    : Expanded(
                                                        child: Container())
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
        ));
  }
}
