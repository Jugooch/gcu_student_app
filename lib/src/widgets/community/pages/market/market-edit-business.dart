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

class EditBusinessPage extends StatefulWidget {
  final User user;
  Business business;
  EditBusinessPage({required this.user, Key? key, required this.business})
      : super(key: key);

  @override
  _EditBusinessPageState createState() => _EditBusinessPageState();
}

class _EditBusinessPageState extends State<EditBusinessPage> {
  String name = '';
  List<String> categories = [];
  String description = '';
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  List<String> availableCategories = [
    'Clothes',
    'Art',
    'Services',
    'Crafts',
    'Food',
    'Technology',
    'Furniture',
    'Home Supplies',
    'Cosmetics',
    'Other'
  ];

  // This is the file that will be used to store the image
  File? _image;

  // This is the image picker
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.business.name);
    descriptionController =
        TextEditingController(text: widget.business.description);
    name = widget.business.name;
    categories = List.from(widget.business.categories);
    description = widget.business.description;
  }

  allInfoEntered() {
    print(
        "name: ${name}, description: ${description}, categories length: ${categories.length}, image: ${_image.toString()}");
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        categories.isNotEmpty &&
        _image != null) {
      return true;
    } else {
      return false;
    }
  }

  void updateBusinessName(String input) {
    name = input;
    setState(() {});
  }

  void updateBusinessDescription(String input) {
    description = input;
    setState(() {
      description = input;
    });
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

  ///////////////////////////////////////////////////////////////////////////
  ///*TODO* Update this method to actually edit a business when connected to a database**
  ///////////////////////////////////////////////////////////////////////////
  updateBusiness() {
    Business newBusiness = Business(
        name: name,
        description: description,
        image: "",
        ownerId: widget.user.id,
        categories: categories);
    print("user updating business with name: " + newBusiness.name);
  }
  ///////////////////////////////////////////////////////////////////////////

  Widget buildCategories(ThemeNotifier themeNotifier) {
    List<Widget> categoryButtons = availableCategories.map((category) {
      final isSelected = categories.contains(category);
      return ElevatedButton(
        onPressed: () {
          setState(() {
            if (isSelected) {
              categories.remove(category);
            } else {
              categories.add(category);
            }
          });
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isSelected
                  ? Colors.transparent
                  : AppStyles.getTextTertiary(themeNotifier.currentMode),
              width: 1.0, // Specify the border width
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          backgroundColor: isSelected
              ? AppStyles.getPrimaryLight(themeNotifier.currentMode)
              : AppStyles.getBackground(themeNotifier.currentMode),
          foregroundColor: isSelected
              ? Colors.white
              : AppStyles.getTextTertiary(themeNotifier.currentMode),
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        ),
        child: Text(category),
      );
    }).toList();

    return SideScrollingWidget(children: categoryButtons);
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
                  SizedBox(height: 16),
                  Padding(
                      padding: EdgeInsets.only(left: 32, right: 32, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "You can edit your business information here. Your information will have to be re-approved, so changes may take a while to show on your business page.",
                              style: TextStyle(
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16)),
                          SizedBox(height: 32),
                          Text("Business Name",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode))),
                          SizedBox(height: 16),
                          TextField(
                            controller: nameController,
                            maxLength: 25,
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode), // Set text color
                            ),
                            decoration: InputDecoration(
                              hintText: 'Team name here...',
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
                            onChanged: updateBusinessName,
                          ),
                          SizedBox(height: 32),
                          Text("Business Image",
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
                          Text("Business Categories",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode))),
                        ],
                      )),
                  SizedBox(height: 16),
                  buildCategories(themeNotifier),
                  SizedBox(height: 32),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Business Description",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode))),
                          SizedBox(height: 16),
                          TextField(
                            controller: descriptionController,
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
                            onChanged: updateBusinessDescription,
                          ),
                        ],
                      )),
                  SizedBox(height: 32),
                  Container(
                    margin: EdgeInsets.only(left: 32.0, right: 32, bottom: 32),
                    height: 80.0,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: ElevatedButton(
                      onPressed: allInfoEntered()
                          ? () {
                              // Logic to proceed after correct answers are correct\
                              updateBusiness();
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
                            'Create Business',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
