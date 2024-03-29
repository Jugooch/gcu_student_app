import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/events/pages/news-article-page.dart';
import 'package:provider/provider.dart';

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
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return InkWell(
      onTap: () => {
          //logic to open subpage for the Article
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewsArticlePage(article: widget.article)),
          )
      },
      child: Column(
          children: [
            Container(
              width: 320,
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Container(
                          color: Colors.white,
                          child: Image.asset(
                            widget.article.image,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ))),
                          ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppStyles.getPrimaryDark(themeNotifier.currentMode)),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.article.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ));
  }
}
