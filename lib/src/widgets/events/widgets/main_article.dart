import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';

import '../../../app_styling.dart';

class MainArticleButton extends StatefulWidget {
  //pass in an article object
  final Article article;

  const MainArticleButton({Key? key, required this.article}) : super(key: key);

  @override
  _MainArticleButton createState() => _MainArticleButton();
}

class _MainArticleButton extends State<MainArticleButton> {
  ///////////////////////
  //Main Widget
  ///////////////////////
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 320,
          height: 240,
          child: Stack(
            children: [
              // Image with Purple Overlay and Rounded Corners
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppStyles.getPrimaryDark(ThemeNotifier().currentMode).withOpacity(0.3), // Adjust opacity as needed
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      widget.article.image, // Replace with the AssetImage
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Purple Background for Bottom Section with Rounded Bottom Corners
              Positioned(
                left: 0,
                top: 173,
                child: Container(
                  width: 320,
                  height: 67,
                  decoration: ShapeDecoration(
                    color: AppStyles.getPrimary(ThemeNotifier().currentMode),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              // Title Text
              Positioned(
                left: 15,
                top: 181,
                child: SizedBox(
                  width: 283,
                  height: 51,
                  child: Text(
                    widget.article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
