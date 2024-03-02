import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/community-services/market-service.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/market/product-card.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/expandable-text/expandable_text.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class MarketProduct extends StatefulWidget {
  final Product product;
  const MarketProduct({Key? key, required this.product}) : super(key: key);

  @override
  _MarketProduct createState() => _MarketProduct();
}

class _MarketProduct extends State<MarketProduct> {
  bool isProductLiked = false;
  List<Product> otherProducts = [];
  late Future<List<Product>> futureOtherProducts;

  @override
  void initState() {
    super.initState();
    futureOtherProducts = MarketService().getProducts(widget.product.businessId);
    fetchData();
  }

  fetchData() async {
    User user = await UserService().getUser("20692303");
    List<Product> likedProducts = await MarketService().getLikedProducts(user);
    otherProducts =
        await futureOtherProducts;

    otherProducts.removeWhere((e) => e.id == widget.product.id);

    for (var product in likedProducts) {
      if (product.id == widget.product.id) {
        isProductLiked = true;
        break;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(11),
          child: Container(
            color: const Color(0xFF522498),
          )),
      backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
      body: FutureBuilder<List<Product>>(
        future: futureOtherProducts,
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
            Stack(children: [
              Container(
                height: 240,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      0), // Fixed: Set borderRadius if needed
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppStyles.getPrimaryDark(themeNotifier.currentMode)
                          .withOpacity(0.3),
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      widget.product.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              CustomBackButton(),
            ]),
            Container(
                decoration: BoxDecoration(
                  color: AppStyles.getPrimaryDark(themeNotifier.currentMode),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 32, right: 16, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                            radius: 20,
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
                          final String image =
                              "https://source.unsplash.com/random";
                          final String subject = 'Check out this product!';
                          final String text =
                              'I found this product on the GCU Student Marketplace: $image';
                          Share.share(text, subject: subject);
                        },
                      ),
                      IconButton(
                        iconSize: 24,
                        icon: Icon(Icons.favorite),
                        color: isProductLiked
                            ? AppStyles.getPrimaryLight(
                                themeNotifier.currentMode)
                            : Colors.white,
                        onPressed: () {
                          setState(() {
                            isProductLiked = !isProductLiked;
                          });
                        },
                      ),
                    ],
                  ),
                )),
            Container(
                decoration: BoxDecoration(
                  color: AppStyles.getCardBackground(themeNotifier.currentMode),
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
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.product.name,
                                  style: TextStyle(
                                      color: AppStyles.getTextPrimary(
                                          themeNotifier.currentMode),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              SizedBox(height: 8),
                              Text(
                                widget.product.category,
                                style: TextStyle(
                                  color: AppStyles.getPrimaryLight(
                                      themeNotifier.currentMode),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          "${widget.product.price}",
                          style: TextStyle(
                            color: AppStyles.getPrimaryLight(
                                themeNotifier.currentMode),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    ExpandableText(text: widget.product.description),
                  ],
                )),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Others From This Seller',
                style: TextStyle(
                  color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            SideScrollingWidget(
                children:
                    otherProducts.map((e) => ProductCard(product: e)).toList()),
                    SizedBox(height: 32)
          ],
        ),
      );}})
    );
  }
}
