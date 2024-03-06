import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  final League league;
  final Team team;
  final bool createTeam;
  const QuizPage(
      {required this.createTeam,
      required this.league,
      required this.team,
      Key? key})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Future<List<QuizQuestion>> questionsFuture;
  List<QuizQuestion> questions = [];
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  Map<int, String> selectedAnswers =
      {}; // Track selected answers by question index

  @override
  void initState() {
    super.initState();
    questionsFuture = IntramuralService().getQuizQuestions(widget.league.sport);
    fetchData();
  }

  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    questions = await questionsFuture;

    setState(() {});
  }

  bool areAllAnswersCorrect() {
    for (int index = 0; index < questions.length; index++) {
      QuizQuestion question = questions[index];
      // Check if the question has been answered and if the answer is correct
      if (selectedAnswers[index] != question.answer) {
        return false; // An incorrect answer or an unanswered question was found
      }
    }
    return true; // All answered questions are correct
  }

  ///////////////////////////////////////////////////////////////////////////
  ///*TODO* Update these methods to actually create and join a team when using real data
  ///////////////////////////////////////////////////////////////////////////
  createTeam() {
    print("user creating team with name:" + widget.team.teamName);
  }

  joinTeam() {
    print("user joining team with name:" + widget.team.teamName);
  }

  ///////////////////////////////////////////////////////////////////////////

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
        body: FutureBuilder<List<QuizQuestion>>(
            future: questionsFuture,
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
                      CustomBackButton(),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            Text("Intramural Rules Quiz",
                                style: TextStyle(
                                    color: AppStyles.getTextPrimary(
                                        themeNotifier.currentMode),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            SizedBox(height: 16),
                            Text(
                                "All members must pass this quiz before they can join/create a team. This quiz is intended to teach each player the basic rules of their intended sport.",
                                style: TextStyle(
                                    color: AppStyles.getTextPrimary(
                                        themeNotifier.currentMode),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 32, right: 32, bottom: 32),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(), // Prevents scrolling within ListView
                            itemCount: questions.length,
                            itemBuilder: (context, index) {
                              QuizQuestion question = questions[index];
                              return Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppStyles.getCardBackground(
                                          themeNotifier.currentMode),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppStyles.getBlack(
                                                  themeNotifier.currentMode)
                                              .withOpacity(0.3),
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
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: selectedAnswers
                                                      .containsKey(index)
                                                  ? selectedAnswers[index] ==
                                                          question.answer
                                                      ? Colors
                                                          .green // Correct Answer
                                                      : Colors
                                                          .red // Wrong Answer
                                                  : AppStyles.getPrimaryDark(
                                                      themeNotifier
                                                          .currentMode), // No Answer Selected
                                            ),
                                            child: Text(
                                              "${index + 1}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Text(question.question,
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode))),
                                              SizedBox(height: 16),
                                              ...question.choices.map((choice) {
                                                bool isSelected =
                                                    selectedAnswers[index] ==
                                                        choice;
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedAnswers[index] =
                                                          choice;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4),
                                                    color: isSelected
                                                        ? Colors.black
                                                            .withOpacity(.1)
                                                        : Colors.transparent,
                                                    child: Row(
                                                      children: [
                                                        Checkbox(
                                                          value: isSelected,
                                                          side: BorderSide(
                                                            color: AppStyles
                                                                .getTextPrimary(
                                                                    themeNotifier
                                                                        .currentMode),
                                                            width: 2.0,
                                                          ),
                                                          checkColor:
                                                              Colors.white,
                                                          activeColor: AppStyles
                                                              .getPrimaryLight(
                                                                  themeNotifier
                                                                      .currentMode),
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              if (value ==
                                                                  true) {
                                                                selectedAnswers[
                                                                        index] =
                                                                    choice;
                                                              } else {
                                                                selectedAnswers
                                                                    .remove(
                                                                        index);
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        SizedBox(width: 8),
                                                        Flexible(
                                                            child: Text(choice,
                                                                style: TextStyle(
                                                                    color: AppStyles.getTextPrimary(
                                                                        themeNotifier
                                                                            .currentMode)))),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16)
                                ],
                              );
                            },
                          )),
                      SizedBox(height: 16),
                      Container(
                        margin:
                            EdgeInsets.only(left: 32.0, right: 32, bottom: 32),
                        height: 80.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: ElevatedButton(
                          onPressed: areAllAnswersCorrect()
                              ? () {
                                  // Logic to proceed after correct answers are correct\

                                  //user is creating team, do this:
                                  //user is joining a team, do this:
                                  widget.createTeam ? createTeam() : joinTeam();
                                }
                              : null, // Button is disabled if not all answers are correct
                          style: ButtonStyle(
                            backgroundColor: areAllAnswersCorrect()
                                ? MaterialStateProperty.all(
                                    AppStyles.getPrimaryDark(
                                        themeNotifier.currentMode),
                                  )
                                : MaterialStateProperty.all(
                                    AppStyles.getPrimaryDark(
                                            themeNotifier.currentMode)
                                        .withOpacity(.3)),
                            minimumSize: MaterialStateProperty.all(
                              const Size(0.5, 0), // 50% width
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Submit Quiz',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
