import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/filter_submissions.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class AddEventPage extends StatefulWidget {
  final User user;
  final Club club;
  const AddEventPage({required this.user, Key? key, required this.club})
      : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  String title = "";
  String location = "";
  String description = "";
  bool repeatWeekly = false;
  DateTime date = DateTime.now();
  final ImagePicker _picker = ImagePicker();

  // This is the file that will be used to store the image
  File? _image;

  @override
  void initState() {
    super.initState();
  }

  void updateEventTitle(String input) {
    title = input;
    setState(() {});
  }

  void updateEventDescription(String input) {
    description = input;
    setState(() {});
  }

  void updateEventLocation(String input) {
    location = input;
    setState(() {});
  }

  void updateEventDate(DateTime input) {
    date = input;
    setState(() {});
  }

  void updateWeekly(bool? newValue) {
    repeatWeekly = newValue!;
    setState(() {});
  }

  //Implementing image picker
  void _openImagePicker(
      {required BuildContext context, required ThemeNotifier themeNotifier}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery, themeNotifier, context);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera, themeNotifier, context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  allInfoEntered() {
    if (title.isNotEmpty &&
        description.isNotEmpty &&
        _image != null &&
        date != null) {
      return true;
    } else {
      return false;
    }
  }

  Future getImage(ImageSource source, ThemeNotifier themeNotifier,
      BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      // Crop the selected image
      final croppedFile = await ImageCropper()
          .cropImage(sourcePath: pickedFile.path, aspectRatioPresets: [
        CropAspectRatioPreset.square, // Forces a square crop aspect ratio
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppStyles.getPrimary(themeNotifier.currentMode),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true, // Locks the aspect ratio to the preset
            hideBottomControls: true),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        ),
      ]);

      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
        });
      } else {
        // Handle the case when cropping is canceled or fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image cropping cancelled')),
        );
      }
    } else {
      // Handle the case when image picking is canceled
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image picking cancelled')),
      );
    }
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final DateTime fullDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return DateFormat('MMMM dd, h:mm a').format(fullDateTime);
  }

  Future<void> _selectDate(
      BuildContext context, ThemeNotifier themeNotifier) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppStyles.getPrimaryLight(themeNotifier.currentMode),
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // Combine selectedDate and selectedTime into a single DateTime object
        date = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, ThemeNotifier themeNotifier) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppStyles.getPrimaryLight(
                  themeNotifier.currentMode), // header background color
              onPrimary: AppStyles.getPrimaryLight(
                  themeNotifier.currentMode), // header text color
              surface: AppStyles.getBackground(
                  themeNotifier.currentMode), // picker background color
              onSurface: AppStyles.getTextPrimary(
                  themeNotifier.currentMode), // picker text color
            ),
            dialogBackgroundColor: AppStyles.getBackground(
                themeNotifier.currentMode), // dialog background color
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        // Update the date variable to reflect the new time
        date = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      });
    }
  }

  void createEvent() async {
    try {
      if (_image != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        String fileName = path.basename(_image!.path);

        Reference ref = storage.ref().child("Events/" + fileName);
        UploadTask uploadTask = ref.putFile(_image!);

        // Uploading the selected image with some custom meta data
        TaskSnapshot snapshot = await uploadTask;

        // Awaiting the download URL
        String imageUrl = await snapshot.ref.getDownloadURL();

        // Use the image URL for your event object
        Event newEvent = Event(
            title: title,
            date: date,
            description: description,
            image: imageUrl,
            major: false,
            location: location,
            clubId: widget.club.id!,
            weekly: repeatWeekly);

        await ClubsService().addEvent(newEvent);
      } else {
        print("No image selected for the event");
      }
    } catch (e, stackTrace) {
      print("General error in createEvent: $e");
      print("Stack trace: $stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return GestureDetector(
        onTap: () {
          // Call this method to hide the keyboard when tapping outside of the TextField
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
              Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Event Title",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode))),
                      SizedBox(height: 16),
                      TextField(
                        maxLength: 56,
                        style: TextStyle(
                          color: AppStyles.getTextPrimary(
                              themeNotifier.currentMode), // Set text color
                        ),
                        decoration: InputDecoration(
                          hintText: 'Event title here...',
                          hintStyle: TextStyle(
                            color: AppStyles.getInactiveIcon(themeNotifier
                                .currentMode), // Set hint text color
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.getTextPrimary(themeNotifier
                                  .currentMode), // Set border color
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
                        onChanged: updateEventTitle,
                      ),
                      SizedBox(height: 32),
                      Text("Event Date/Time",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode))),
                      SizedBox(height: 16),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDateTime(selectedDate, selectedTime),
                                style: TextStyle(
                                    color: AppStyles.getTextPrimary(
                                        themeNotifier.currentMode),
                                    fontSize: 16)),
                          ]),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () => _selectDate(context, themeNotifier),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppStyles.getPrimaryLight(
                                        themeNotifier.currentMode)),
                                child: Text('Select date',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              )),
                          InkWell(
                              onTap: () => _selectTime(context, themeNotifier),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppStyles.getPrimaryLight(
                                        themeNotifier.currentMode)),
                                child: Text('Select time',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              )),
                        ],
                      ),
                      SizedBox(height: 32),
                      Text("Event Location",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode))),
                      SizedBox(height: 16),
                      TextField(
                        maxLength: 56,
                        style: TextStyle(
                          color: AppStyles.getTextPrimary(
                              themeNotifier.currentMode), // Set text color
                        ),
                        decoration: InputDecoration(
                          hintText: 'Event location here...',
                          hintStyle: TextStyle(
                            color: AppStyles.getInactiveIcon(themeNotifier
                                .currentMode), // Set hint text color
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.getTextPrimary(themeNotifier
                                  .currentMode), // Set border color
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
                        onChanged: updateEventLocation,
                      ),
                      SizedBox(height: 32),
                      Text("Event Image",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode))),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                _openImagePicker(
                                    context: context,
                                    themeNotifier: themeNotifier);
                              },
                              child: CircleAvatar(
                                  radius: 64,
                                  backgroundColor: AppStyles.getCardBackground(
                                      themeNotifier.currentMode),
                                  child: ClipOval(
                                      child: _image != null
                                          ? Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      colorFilter: ColorFilter.mode(
                                                          AppStyles.getPrimaryDark(
                                                                  themeNotifier
                                                                      .currentMode)
                                                              .withOpacity(0.3),
                                                          BlendMode.srcATop),
                                                      image:
                                                          FileImage(_image!))),
                                              child: Icon(Icons.edit,
                                                  color:
                                                      AppStyles.getPrimaryLight(
                                                          themeNotifier
                                                              .currentMode)))
                                          : Icon(
                                              Icons.add,
                                              color: AppStyles.getTextPrimary(
                                                  themeNotifier.currentMode),
                                            )))),
                          Text("Image set successfully",
                              style: TextStyle(
                                  color: _image != null
                                      ? Colors.green
                                      : Colors.transparent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                      SizedBox(height: 32),
                      Text("Event Description",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode))),
                      SizedBox(height: 16),
                      TextField(
                        maxLines: 3,
                        style: TextStyle(
                          color: AppStyles.getTextPrimary(
                              themeNotifier.currentMode), // Set text color
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter description here...',
                          hintStyle: TextStyle(
                            color: AppStyles.getInactiveIcon(themeNotifier
                                .currentMode), // Set hint text color
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.getTextPrimary(themeNotifier
                                  .currentMode), // Set border color
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: updateEventDescription,
                      ),
                      SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppStyles.getCardBackground(
                            themeNotifier.currentMode,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppStyles.darkBlack.withOpacity(.12),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: const Offset(
                                  0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Repeat Weekly?",
                              style: TextStyle(
                                color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode,
                                ),
                                fontSize: 16,
                              ),
                            ),
                            Checkbox(
                              side: BorderSide(
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
                                width: 2.0,
                              ),
                              checkColor: Colors.white,
                              activeColor: AppStyles.getPrimaryLight(
                                  themeNotifier.currentMode),
                              value: repeatWeekly,
                              onChanged: (bool? newValue) {
                                updateWeekly(newValue);
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      Container(
                        margin: EdgeInsets.only(bottom: 32),
                        height: 80.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: ElevatedButton(
                          onPressed: allInfoEntered()
                              ? () {
                                  if (ProfanityCheck.containsProfanity(title) ||
                                      ProfanityCheck.containsProfanity(
                                          description)) {
                                    // If inappropriate content is found, show a dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor:
                                              AppStyles.getCardBackground(
                                                  themeNotifier.currentMode),
                                          title: Text(
                                              "Inappropriate Content Detected",
                                              style: TextStyle(
                                                  color:
                                                      AppStyles.getTextPrimary(
                                                          themeNotifier
                                                              .currentMode))),
                                          content: Text(
                                              "Please remove any inappropriate content from the product details.",
                                              style: TextStyle(
                                                  color:
                                                      AppStyles.getTextPrimary(
                                                          themeNotifier
                                                              .currentMode))),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('OK',
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getPrimaryLight(
                                                              themeNotifier
                                                                  .currentMode))),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    // Logic to proceed after correct answers are correct\
                                    createEvent();
                                  }
                                }
                              : null, // Button is disabled if not all info has been entered
                          style: ButtonStyle(
                            backgroundColor: allInfoEntered()
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
                                'Create Event',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          )),
        ));
  }
}
