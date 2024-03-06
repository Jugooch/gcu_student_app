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

class MarketEditProducts extends StatefulWidget {
  List<Product> products;
  MarketEditProducts({Key? key, required this.products})
      : super(key: key);

  @override
  _MarketEditProducts createState() => _MarketEditProducts();
}

class _MarketEditProducts extends State<MarketEditProducts> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  List<Product> filteredProducts = [];
  String searchQuery = "";
  int selectedTabIndex = 0;

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  List<dynamic> _fetchItems() {
    if(searchQuery != ""){
    filteredProducts = widget.products.where((element) => element.name.contains(searchQuery)).toList();
      return filteredProducts;
    }
      else{
        return widget.products;
      }
  }

  void _updateItems() {
    setState(() {
      _fetchItems();
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      _fetchItems(); // Fetch data with the updated search query
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

  buildResults(themeNotifier, listItems) {
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
                                  index * 2], isEdit: true,), // First item of the pair
                        ),
                        SizedBox(
                            width:
                                16), // Add space only if there's a second item
                        !isLastItemSingle
                            ? // Check if there's a second item in this row
                            Expanded(
                                child: CondensedProductCard(
                                    product: listItems[index * 2 +
                                        1], isEdit: true,), // Second item of the pair
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
                    SizedBox(height: 32),
                    buildResults(themeNotifier, _fetchItems())
                  ]),
            )));
  }
}
