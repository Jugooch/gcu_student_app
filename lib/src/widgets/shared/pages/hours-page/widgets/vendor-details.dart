import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class VendorDetailsPage extends StatefulWidget {
  final Vendor vendor;
  final RichText status;

  const VendorDetailsPage(
      {required this.vendor, required this.status, Key? key})
      : super(key: key);

  @override
  _VendorDetailsPageState createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    // Get current day of the week
    String currentDay = DateFormat('EEEE').format(DateTime.now());

    return GestureDetector(
        onTap: () {
          // Call this method to hide the keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(11),
                child: Container(
                  color: const Color(0xFF522498),
                )),
            backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomBackButton(),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 32.0, right: 32.0, left: 32.0, top: 16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 32.0),
                            decoration: BoxDecoration(
                              color: AppStyles.getCardBackground(
                                  themeNotifier.currentMode),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppStyles.darkBlack.withOpacity(.12),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage:
                                        AssetImage(widget.vendor.image),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.vendor.name,
                                          style: TextStyle(
                                              color: AppStyles.getTextPrimary(
                                                  themeNotifier.currentMode),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(height: 8.0),
                                      Text(widget.vendor.location,
                                          style: TextStyle(
                                              color: AppStyles.getTextPrimary(
                                                  themeNotifier.currentMode),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300)),
                                      SizedBox(height: 8.0),
                                      widget
                                          .status //insert the formatted hours for today created on the last page
                                    ],
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 24,
                                    color: Colors.transparent,
                                  )
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Text(widget.vendor.description,
                                  style: TextStyle(
                                      color: AppStyles.getTextPrimary(
                                          themeNotifier.currentMode),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300))
                            ]),
                          ),
                          Text(
                            'Business Hours',
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(bottom: 32.0),
                              decoration: BoxDecoration(
                                color: AppStyles.getCardBackground(
                                    themeNotifier.currentMode),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppStyles.darkBlack.withOpacity(.12),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: List.generate(
                                    widget.vendor.hours.days.length, (index) {
                                  // Extract the open and close time
                                  String openTimeRaw =
                                      widget.vendor.hours.days[index].openTime;
                                  String closeTimeRaw =
                                      widget.vendor.hours.days[index].closeTime;

                                  // Initialize the timeRange with "Closed" if either time is "00:00:00"
                                  String timeRange;
                                  if (openTimeRaw == "00:00:01" ||
                                      closeTimeRaw == "00:00:01") {
                                    timeRange = "Closed";
                                  } else {
                                    // Format the open and close time to be more readable if not "Closed"
                                    String openTime = DateFormat('h:mm a')
                                        .format(DateFormat('HH:mm:ss')
                                            .parse(openTimeRaw));
                                    String closeTime = DateFormat('h:mm a')
                                        .format(DateFormat('HH:mm:ss')
                                            .parse(closeTimeRaw));
                                    timeRange = "$openTime - $closeTime";
                                  }

                                  // Check if the current day matches the day from the list
                                  bool isToday = currentDay ==
                                      widget.vendor.hours.days[index].day;

                                  return Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Bold the text if it's the current day
                                          Text(
                                            widget.vendor.hours.days[index].day,
                                            style: TextStyle(
                                                fontWeight: isToday
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                          ),
                                          Text(timeRange,
                                              style: TextStyle(
                                                  fontWeight: isToday
                                                      ? FontWeight.bold
                                                      : FontWeight.normal)),
                                        ],
                                      ));
                                }),
                              )),
                          Text(
                            'Location',
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
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
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  8),
                              child: Image.asset(
                                "assets/images/LocationExample.png",
                                fit: BoxFit
                                    .cover,
                              height: 128,
                              ),
                            ),
                          ),
                        ]),
                  )
                ],
              ),
            )));
  }
}
