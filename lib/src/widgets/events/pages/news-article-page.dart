import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../services/services.dart';

class NewsArticlePage extends StatelessWidget {
  final Article article;
  const NewsArticlePage({required this.article, Key? key}) : super(key: key);

  _formatDate(DateTime date) {
    //format date here to make more user friendly
    return DateFormat('EEEE, MM/dd/yyyy').format(date);
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
          children: [
            Stack(children: [
              Container(
                height: 240,
                width: double.infinity,
                child: ClipRRect(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppStyles.getPrimaryDark(themeNotifier.currentMode)
                          .withOpacity(0.3),
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      article.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              CustomBackButton(),
            ]),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(article.title,
                        style: TextStyle(
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                    SizedBox(height: 16),
                    Text("By: ${article.author}",
                        style: TextStyle(
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                            fontSize: 14)),
                    SizedBox(height: 16),
                    Text(_formatDate(article.date),
                        style: TextStyle(
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                            fontSize: 14,
                            fontWeight: FontWeight.w300)),
                  ],
                )),
            Container(
                padding: EdgeInsets.all(32),
                child: Text(article.content,
                    style: TextStyle(
                        color:
                            AppStyles.getTextPrimary(themeNotifier.currentMode),
                        fontSize: 16,
                        height: 1.4)))
          ],
        )));
  }
}
