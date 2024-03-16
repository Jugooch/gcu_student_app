import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/filter_submissions.dart';
import 'package:gcu_student_app/src/widgets/events/widgets/edit-news-card.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:provider/provider.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';

class EditNewsPage extends StatefulWidget {
  final User user;
  final List<Article> articles;
  const EditNewsPage({required this.user, Key? key, required this.articles})
      : super(key: key);

  @override
  _EditNewsPageState createState() => _EditNewsPageState();
}

class _EditNewsPageState extends State<EditNewsPage> {
  late TextEditingController _searchController;
  String searchQuery = "";

  List<Article> filteredArticles = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredArticles = widget.articles;
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      if (searchQuery.isEmpty) {
        filteredArticles = widget.articles;
      } else {
        filteredArticles = widget.articles
            .where((article) =>
                article.title.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  Widget buildSearchBar(ThemeNotifier themeNotifier) {
    return TextField(
      controller: _searchController,
      style: TextStyle(
        color: AppStyles.getTextPrimary(
            themeNotifier.currentMode), // Set text color
      ),
      decoration: InputDecoration(
        hintText: 'Search for an article...',
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
    return Container(
        child: listItems.length != 0
            ? Column(
                children: listItems.map<Widget>((e) {
                  return Column(
                    children: [
                      EditNewsCard(article: e, user: widget.user),
                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              )
            : Text("No articles...",
                style: TextStyle(
                    color:
                        AppStyles.getTextPrimary(themeNotifier.currentMode))));
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomBackButton(),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSearchBar(themeNotifier),
                    SizedBox(height: 32),
                    buildResults(themeNotifier, filteredArticles)
                  ]),
            ),
          ]),
        ));
  }
}
