import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import '../widgets/main_article.dart';
import '../../shared/side_scrolling/side_scrolling.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  ///////////////////////
  //Properties
  ///////////////////////
  late Future<List<Article>> articlesFuture;
  List<Article> articles = [];
  late Future<List<Event>> eventsFuture;
  List<Event> events = [];

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  
  ///////////////////////
  //Fetch All Data on Events and Articles
  ///////////////////////
  Future<void> fetchData() async {
    articlesFuture = EventsService().getArticles();
    articles = await articlesFuture;

    eventsFuture = EventsService().getEvents();
    events = await eventsFuture;

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }


///////////////////////
  //Main Widget
///////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Lopes News',
                  style: TextStyle(
                    color: AppStyles.getTextPrimary(ThemeNotifier().currentMode),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SideScrollingWidget(
              children: articles.map((e) => MainArticleButton(article: e)).toList(),
            ),
            const SizedBox(height: 16.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Major Events', 
                      style: TextStyle(
                        color: AppStyles.getTextPrimary(ThemeNotifier().currentMode),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'View Full Calendar', 
                      style: TextStyle(
                        color: AppStyles.getPrimaryLight(ThemeNotifier().currentMode),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                )
              ),
            ),
            //loop through articles and display them in cards in the side scrolling widget
            SideScrollingWidget(
              children: articles.map((e) => MainArticleButton(article: e)).toList(),
            ),
          ],
        )
      );
  }
}
