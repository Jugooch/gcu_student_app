import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  //currency formatter
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  //date formatter
  String formatDate(DateTime dateTime) {
    //Date formatter
    final DateFormat formatter = DateFormat('MM/dd/yyyy \'at\' h:mma');

    // Apply the format to the DateTime
    return formatter.format(dateTime);
  }

  TransactionCard({
    required this.transaction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppStyles.getCardBackground(themeNotifier.currentMode),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppStyles.darkBlack.withOpacity(.12),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add CircleAvatar to display the image
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(
                transaction.image
              )
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(transaction.vendor,
                  style: TextStyle(
                      color:
                          AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 8.0),
              Text(formatDate(transaction.date),
                  style: TextStyle(
                      color:
                          AppStyles.getTextPrimary(themeNotifier.currentMode),
                      fontSize: 16,
                      fontWeight: FontWeight.w200))
            ]),
            Text("\$${oCcy.format(transaction.amount)}",
                style: TextStyle(
                    color:
                        AppStyles.getTextPrimary(themeNotifier.currentMode),
                    fontSize: 16,
                    fontWeight: FontWeight.normal))
          ],
        ));
  }
}
