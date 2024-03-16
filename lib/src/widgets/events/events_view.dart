import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import './pages/pages.dart';
import 'pages/add-news.dart';
import 'pages/edit-news.dart';
import 'widgets/events_card.dart';
import 'widgets/main_article.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<EventsView> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<List<Article>> articlesFuture;
  List<Article> articles = [];
  late Future<List<Event>> eventsFuture;
  List<Event> events = [];
  bool isUserAdmin = false;
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    eventsFuture = EventsService().getMajorEvents();
    fetchData();
  }

  ///////////////////////
  //Fetch All Data on Events and Articles
  ///////////////////////
  Future<void> fetchData() async {
    articlesFuture = EventsService().getArticles();
    articles = await articlesFuture;
    userFuture = UserService().getUser("20692303");
    user = await userFuture;
    isUserAdmin = await EventsService().isUserAdmin(user);

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
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: null,
        backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
        body: FutureBuilder<List<Event>>(
            future: eventsFuture,
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
                    const SizedBox(height: 16.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Expanded(
                          child: Text(
                            'Lopes News',
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          ),
                          isUserAdmin
                              ? InkWell(
                                  onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddNewsPage(
                                                    user: user,
                                                  )),
                                        )
                                      },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppStyles.getPrimaryLight(
                                              themeNotifier.currentMode)),
                                      padding: EdgeInsets.all(8),
                                      child: Icon(Icons.add,
                                          color: Colors.white, size: 16)))
                              : Container(),
                          isUserAdmin ? SizedBox(width: 16) : Container(),
                          isUserAdmin
                              ? InkWell(
                                  onTap: () => {
                                        //Navigator.push(
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditNewsPage(
                                                    user: user,
                                                    articles: articles,
                                                  )),
                                        )
                                      },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent),
                                      padding: EdgeInsets.all(4),
                                      child: Icon(Icons.edit,
                                          color: AppStyles.getPrimaryLight(
                                              themeNotifier.currentMode),
                                          size: 20)))
                              : Container(),
                        ]),
                      ),
                    ),
                    SideScrollingWidget(
                      children: articles
                          .map((e) => MainArticleButton(article: e))
                          .toList(),
                    ),
                    const SizedBox(height: 24.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Major Events',
                                style: TextStyle(
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //logic to open subpage for the Calendar
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CalendarPage(majorEvents: events)),
                                  );
                                },
                                child: Text(
                                  'View Full Calendar',
                                  style: TextStyle(
                                    color: AppStyles.getPrimaryLight(
                                        themeNotifier.currentMode),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                    //loop through articles and display them in cards in the side scrolling widget
                    SideScrollingWidget(
                      children: events
                          .map((a) => EventCard(
                                event: a,
                                otherEvents: events,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Looking For Student Tickets?',
                          style: TextStyle(
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // 6. Add to Wallet Button
                    Container(
                      height: 80.0,
                      margin: const EdgeInsets.symmetric(horizontal: 32.0),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: ElevatedButton(
                        onPressed: () {
                          _launchURL();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              AppStyles.getPrimaryDark(
                                  themeNotifier.currentMode)),
                          minimumSize: MaterialStateProperty.all(
                            const Size(0.5, 0), // 50% width
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Yours Here!',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32.0),
                  ],
                ));
              }
            }));
  }

  _launchURL() async {
    final Uri url = Uri.parse(
        'https://gcutickets.evenue.net/cgi-bin/ncommerce3/EVExecMacro?linkID=gcu-multi&evm=myac&msgCode=32000&shopperContext=ST&returnURL=/cgi-bin/ncommerce3/SEGetGroupList%3FlinkID%3Dgcu-multi%26groupCode%3D%26RSRC%3D%26RDAT%3D%26shopperContext%3DST&url=/cgi-bin/ncommerce3/SEGetGroupList%3FlinkID%3Dgcu-multi%26groupCode%3D%26RSRC%3D%26RDAT%3D%26shopperContext%3DST');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
