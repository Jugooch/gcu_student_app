import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';

import '../../pages/market/market-edit-products2.dart';
import '../../pages/market/market-product.dart';

class CondensedProductCard extends StatefulWidget {
  //pass in an event object
  final Product product;
  final bool isEdit;

  const CondensedProductCard(
      {Key? key, required this.product, required this.isEdit})
      : super(key: key);

  @override
  _CondensedProductCard createState() => _CondensedProductCard();
}

class _CondensedProductCard extends State<CondensedProductCard> {
  bool isProductLiked = false;
  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    User user = await UserService().getUser("20692303");
    List<Product> likedProducts = await MarketService().getLikedProducts(user);

    for (var product in likedProducts) {
      if (product.id == widget.product.id) {
        isProductLiked = true;
        break;
      }
    }

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  ///////////////////////
  //Main Widget
  ///////////////////////
  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return InkWell(
        onTap: () {
          if (widget.isEdit) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProduct(product: widget.product)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MarketProduct(product: widget.product)),
            );
          }
        },
        child: Container(
            width: 120,
            margin: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: AppStyles.getCardBackground(themeNotifier.currentMode),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppStyles.getBlack(themeNotifier.currentMode)
                      .withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        child: Container(
                            color: Colors.white,
                            child: Image.asset(
                              widget.product.image,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ))),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: AppStyles.getPrimaryDark(
                                      themeNotifier.currentMode)))),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.category,
                                  style: TextStyle(
                                    color: AppStyles.getPrimaryLight(
                                        themeNotifier.currentMode),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  widget.product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow
                                      .ellipsis, // Ensure text truncates
                                  style: TextStyle(
                                    color: AppStyles.getTextPrimary(
                                        themeNotifier.currentMode),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            "${widget.product.price}",
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppStyles.getPrimary(
                                    themeNotifier.currentMode),
                                width: 2)),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage(widget.product.image),
                          backgroundColor: Colors.white,
                        )))
              ],
            )));
  }
}
