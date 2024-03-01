import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/pages/market/market-product.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProductCard extends StatefulWidget {
  //pass in an event object
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  _ProductCard createState() => _ProductCard();
}

class _ProductCard extends State<ProductCard> {
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

    return Container(
      width: 240,
      margin: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppStyles.getCardBackground(themeNotifier.currentMode),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color:
                AppStyles.getBlack(themeNotifier.currentMode).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppStyles.getPrimaryDark(themeNotifier.currentMode)),
              padding: EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage:
                            AssetImage(widget.product.business.image),
                      ),
                    ),
                  ),
                  IconButton(
                    iconSize: 24,
                    icon: Icon(Icons.share),
                    color: Colors.white,
                    onPressed: () {
                      //////////////////////////////////////////////////////////////
                      ///UPDATE THIS TO SEND AN ACTUAL IMAGE OF THE PRODUCT
                      /////////////////////////////////////////////////////////////
                      final String image = "https://source.unsplash.com/random";
                      final String subject = 'Check out this product!';
                      final String text =
                          'I found this product on the GCU Student Marketplace: ${image}';
                      Share.share(text, subject: subject);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    iconSize: 24,
                    icon: Icon(Icons.favorite),
                    color: isProductLiked
                        ? AppStyles.getPrimaryLight(themeNotifier.currentMode)
                        : Colors.white,
                    onPressed: () {
                      setState(() {
                        isProductLiked =
                            !isProductLiked; // Toggle liked state and trigger rebuild
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MarketProduct(product: widget.product)),
                );
              },
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      child: Image.asset(
                        widget.product.image,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppStyles.getPrimaryDark(
                              themeNotifier.currentMode),
                          width: 1.0,
                        ),
                      ),
                    ),
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
                                  fontSize: 14,
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
                                  fontSize: 16,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
