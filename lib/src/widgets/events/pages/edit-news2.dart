import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/filter_submissions.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';

class EditNewsPage2 extends StatefulWidget {
  final User user;
  final Article article;
  const EditNewsPage2({required this.user, Key? key, required this.article})
      : super(key: key);

  @override
  _EditNewsPageState createState() => _EditNewsPageState();
}

class _EditNewsPageState extends State<EditNewsPage2> {
  String title = "";
  String content = "";
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final ImagePicker _picker = ImagePicker();

  // This is the file that will be used to store the image
  File? _image;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article.title);
    _contentController = TextEditingController(text: widget.article.content);
    title = widget.article.title;
    content = widget.article.content;
  }

  void updateArticleTitle(String input) {
    title = input;
    setState(() {});
  }

  void updateArticleContent(String input) {
    content = input;
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
                  getImage(ImageSource.gallery, themeNotifier);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera, themeNotifier);
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
    if (title.isNotEmpty && content.isNotEmpty && _image != null) {
      return true;
    } else {
      return false;
    }
  }

  Future getImage(ImageSource source, ThemeNotifier themeNotifier) async {
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

  createArticle() {
    Article newarticle = Article(
        title: title,
        author: widget.user.name,
        content: content,
        image: "",
        date: widget.article.date);

    print("user editing article with title: " + newarticle.title);
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
                          Text("Article Title",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode))),
                          SizedBox(height: 16),
                          TextField(
                            controller: _titleController,
                            maxLength: 56,
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode), // Set text color
                            ),
                            decoration: InputDecoration(
                              hintText: 'Article title here...',
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
                            onChanged: updateArticleTitle,
                          ),
                          Text("Article Image",
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
                                      backgroundColor:
                                          AppStyles.getCardBackground(
                                              themeNotifier.currentMode),
                                      child: ClipOval(
                                          child: _image != null
                                              ? Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          colorFilter: ColorFilter.mode(
                                                              AppStyles.getPrimaryDark(themeNotifier.currentMode)
                                                                  .withOpacity(
                                                                      0.3),
                                                              BlendMode
                                                                  .srcATop),
                                                          image: FileImage(
                                                              _image!))),
                                                  child: Icon(Icons.edit,
                                                      color:
                                                          AppStyles.getPrimaryLight(
                                                              themeNotifier
                                                                  .currentMode)))
                                              : Icon(
                                                  Icons.add,
                                                  color:
                                                      AppStyles.getTextPrimary(
                                                          themeNotifier
                                                              .currentMode),
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
                          Text("Article Content",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode))),
                          SizedBox(height: 16),
                          TextField(
                            controller: _contentController,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode), // Set text color
                            ),
                            decoration: InputDecoration(
                              hintText: 'Article content here...',
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
                            onChanged: updateArticleTitle,
                          ),
                          SizedBox(height: 32),
                          Container(
                            margin: EdgeInsets.only(
                                left: 32.0, right: 32, bottom: 32),
                            height: 80.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            child: ElevatedButton(
                              onPressed: allInfoEntered()
                                  ? () {
                                      if (ProfanityCheck.containsProfanity(
                                              title) ||
                                          ProfanityCheck.containsProfanity(
                                              content)) {
                                        // If inappropriate content is found, show a dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  AppStyles.getCardBackground(
                                                      themeNotifier
                                                          .currentMode),
                                              title: Text(
                                                  "Inappropriate Content Detected",
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode))),
                                              content: Text(
                                                  "Please remove any inappropriate content from the product details.",
                                                  style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
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
                                        createArticle();
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
                                    'Create Club',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ]))));
  }
}
