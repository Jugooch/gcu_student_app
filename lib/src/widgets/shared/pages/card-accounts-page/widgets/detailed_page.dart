import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/pages/card-accounts-page/widgets/transactions.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'budget.dart';

class DetailedPage extends StatefulWidget {
  final CardAccount account;
  final User user;

  DetailedPage({required this.user, required this.account, Key? key}) : super(key: key);

  @override
  _DetailedPageState createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  int selectedTabIndex = 0;

  //currency formatter
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
                  border: null,
                  backgroundColor:
                      AppStyles.getPrimary(themeNotifier.currentMode),
                  middle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
        Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.account.background),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBackButton(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.account.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                    SizedBox(height: 8),
                    Text("\$${oCcy.format(widget.account.currentBalance)}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text("Rollover",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                              SizedBox(height: 8),
                              Text("\$${oCcy.format(widget.account.totalRollover)}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal))
                            ],
                          ),
                          Column(
                            children: [
                              Text("Fall",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                              SizedBox(height: 8),
                              Text("\$${oCcy.format(widget.account.fallRollover)}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal))
                            ],
                          ),
                          Column(
                            children: [
                              Text("Spring",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                              SizedBox(height: 8),
                              Text("\$${oCcy.format(widget.account.springRollover)}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal))
                            ],
                          ),
                          Column(
                            children: [
                              Text("Summer",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                              SizedBox(height: 8),
                              Text("\$${oCcy.format(widget.account.summerRollover)}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal))
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )), 
          Container(
              decoration: BoxDecoration(
                color: AppStyles.getCardBackground(themeNotifier.currentMode),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Set the selected tab index to 0 (Transactions)
                        setState(() {
                          selectedTabIndex = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selectedTabIndex == 0
                                  ? AppStyles.getPrimaryLight(themeNotifier.currentMode)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Transactions",
                            style: TextStyle(
                              color: selectedTabIndex == 0
                                  ? AppStyles.getPrimaryLight(themeNotifier.currentMode)
                                  : AppStyles.getTextPrimary(themeNotifier.currentMode),
                              fontSize: 16,
                              fontWeight: selectedTabIndex == 0 ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Set the selected tab index to 1 (Budget)
                        setState(() {
                          selectedTabIndex = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selectedTabIndex == 1
                                  ? AppStyles.getPrimaryLight(themeNotifier.currentMode)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Budget",
                            style: TextStyle(
                              color: selectedTabIndex == 1
                                  ? AppStyles.getPrimaryLight(themeNotifier.currentMode)
                                  : AppStyles.getTextPrimary(themeNotifier.currentMode),
                              fontSize: 16,
                              fontWeight: selectedTabIndex == 1 ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Using a Visibility widget to conditionally show Transactions or Budget
            Visibility(
              visible: selectedTabIndex == 0,
              child: Transactions(account: widget.account, user: widget.user),
            ),
            Visibility(
              visible: selectedTabIndex == 1,
              child: Budget(account: widget.account),
            ),
          ],
        ),
      ),
    );
  }
}