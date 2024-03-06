import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RemoveBusinessPage extends StatefulWidget {
  final User user;
  Business business;
  RemoveBusinessPage({required this.user, Key? key, required this.business})
      : super(key: key);

  @override
  _RemoveBusinessPageState createState() => _RemoveBusinessPageState();
}

class _RemoveBusinessPageState extends State<RemoveBusinessPage> {
  String name = '';

  @override
  void initState() {
    super.initState();
  }

  allInfoEntered() {
    if (name == widget.business.name) {
      return true;
    } else {
      return false;
    }
  }

  void updateBusinessName(String input) {
    name = input;
    setState(() {});
  }

  ///////////////////////////////////////////////////////////////////////////
  ///*TODO* Update this method to actually remove a business when connected to a database**
  ///////////////////////////////////////////////////////////////////////////
  removeBusiness() {
    print("user removing business with name: " + name);
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBackButton(),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(left: 32, right: 32, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "You are deleting your business: ${widget.business.name} permanently... doing this is irreversible and cannot be undone. If you want to re-open on the student marketplace, you will have to go back through the verification process. Enter your business name below to confirm you want to delete your business",
                        style: TextStyle(
                          color: AppStyles.getTextPrimary(
                              themeNotifier.currentMode),
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        )),
                    SizedBox(height: 32),
                    Text("Business Name",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppStyles.getTextPrimary(
                              themeNotifier.currentMode),
                        )),
                    SizedBox(height: 16),
                    TextField(
                      style: TextStyle(
                        color: AppStyles.getTextPrimary(
                            themeNotifier.currentMode), // Set text color
                      ),
                      decoration: InputDecoration(
                        hintText: 'Business name here...',
                        hintStyle: TextStyle(
                          color: AppStyles.getInactiveIcon(
                              themeNotifier.currentMode), // Set hint text color
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
                      onChanged: updateBusinessName,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Container(
                margin: EdgeInsets.only(left: 32.0, right: 32, bottom: 32),
                height: 80.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: ElevatedButton(
                  onPressed: allInfoEntered()
                      ? () {
                          removeBusiness();
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: allInfoEntered()
                        ? MaterialStateProperty.all(Colors.red)
                        : MaterialStateProperty.all(Colors.red.withOpacity(.3)),
                    minimumSize: MaterialStateProperty.all(
                        Size(double.infinity, 50)), // 100% width
                  ),
                  child: Text(
                    'Remove Business',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
