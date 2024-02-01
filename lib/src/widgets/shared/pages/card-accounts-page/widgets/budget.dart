import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Budget extends StatefulWidget {
  final CardAccount account;

  Budget({required this.account, Key? key}) : super(key: key);

  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  bool dailyIsExpanded = false;
  bool weeklyIsExpanded = false;
  bool summaryIsExpanded = false;
  
  // Currency formatter
  final oCcy = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Padding(
      padding: EdgeInsets.only(right: 32.0, left: 32.0, top: 32),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppStyles.getCardBackground(themeNotifier.currentMode),
                boxShadow: [
                  BoxShadow(
                    color: AppStyles.darkBlack.withOpacity(.12),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            dailyIsExpanded = !dailyIsExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Daily Budget',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                ),
                              ),
                              Icon(
                                dailyIsExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 24,
                                color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                              ),
                            ],
                          ),
                        )),
                    if (dailyIsExpanded)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.green, width: 4.0),
                                ),
                                child: Center(
                                  child: Text(
                                    '100%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppStyles.getTextPrimary(
                                          themeNotifier.currentMode),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "\$${oCcy.format(widget.account.dailyBudget - widget.account.spentToday)}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier.currentMode),
                                      ),
                                    ),
                                    Text(
                                      "Remaining",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier.currentMode),
                                      ),
                                    ),
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "\$${oCcy.format(widget.account.spentToday)}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier.currentMode),
                                      ),
                                    ),
                                    Text(
                                      "Spent",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier.currentMode),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                  ])),
          SizedBox(height: 32),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppStyles.getCardBackground(themeNotifier.currentMode),
                boxShadow: [
                  BoxShadow(
                    color: AppStyles.darkBlack.withOpacity(.12),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            weeklyIsExpanded = !weeklyIsExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Weekly Budget',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                ),
                              ),
                              Icon(
                                weeklyIsExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 24,
                                color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                              ),
                            ],
                          ),
                        )),
                    if (weeklyIsExpanded)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.green, width: 4.0),
                                ),
                                child: Center(
                                  child: Text(
                                    '100%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppStyles.getTextPrimary(
                                          themeNotifier.currentMode),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "\$${oCcy.format(widget.account.dailyBudget * 7 - widget.account.spentThisWeek)}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier.currentMode),
                                      ),
                                    ),
                                    Text(
                                      "Remaining",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier.currentMode),
                                      ),
                                    ),
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "\$${oCcy.format(widget.account.spentThisWeek)}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier.currentMode),
                                      ),
                                    ),
                                    Text(
                                      "Spent",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier.currentMode),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                  ])),
          SizedBox(height: 32),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppStyles.getCardBackground(themeNotifier.currentMode),
                boxShadow: [
                  BoxShadow(
                    color: AppStyles.darkBlack.withOpacity(.12),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            summaryIsExpanded = !summaryIsExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Transaction Summary',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                ),
                              ),
                              Icon(
                                weeklyIsExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 24,
                                color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                              ),
                            ],
                          ),
                        )),
                    if (summaryIsExpanded)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                          ),
                          const SizedBox(height: 16),
                              Text("Based on your average spending of \$10.50 per day, this account will have no balance on 04/16/2024, which is 12 days before the end of the semester. If you use the suggested budget, your remaining balance will be \$0.00 at the end of the semester",
                              style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode), fontSize: 16)),
                          const SizedBox(height: 16),
                        ],
                      )
                  ])),
        ],
      ),
    );
  }
}
