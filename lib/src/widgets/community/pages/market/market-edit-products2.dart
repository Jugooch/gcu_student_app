import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/filter_submissions.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditProduct extends StatefulWidget {
  Product product;
  EditProduct({required this.product, Key? key}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String name = '';
  double price = 0;
  List<String> categories = [];
  String description = '';
  String selectedCategory = 'All';
  bool isFeatured = false;
  bool agreementChecked = false;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  final _numberFormat =
      NumberFormat.currency(locale: "en_US", symbol: "\$", decimalDigits: 2);

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
    name = widget.product.name;
    description = widget.product.description;
    isFeatured = widget.product.featured;
    nameController = TextEditingController(text: widget.product.name);
    selectedCategory = widget.product.category;
    descriptionController =
        TextEditingController(text: widget.product.description);
    priceController =
        TextEditingController(text: _numberFormat.format(widget.product.price));

    // Listener to update price variable
    price = widget.product.price;
    priceController.addListener(() {
      final String text = priceController.text.replaceAll(RegExp('[^0-9]'), '');
      final doubleValue = double.tryParse(text) ?? 0;

      // Update the price state variable
      setState(() {
        price = doubleValue / 100;
      });

      // Reformat the input text
      priceController.value = TextEditingValue(
        text: _numberFormat.format(doubleValue / 100),
        selection: TextSelection.collapsed(offset: priceController.text.length),
      );
    });
  }

  allInfoEntered() {
    print(
        "name: ${name}, description: ${description}, price: ${price}, category: ${selectedCategory}, image: ${_image.toString()}");
    if (name.isNotEmpty &&
        description.isNotEmpty &&
        selectedCategory.isNotEmpty &&
        _image != null &&
        agreementChecked == true &&
        price != 0) {
      return true;
    } else {
      return false;
    }
  }

  void updateProductTitle(String input) {
    name = input;
    setState(() {});
  }

  void updateProductDescription(String input) {
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

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  ///////////////////////////////////////////////////////////////////////////
  ///*TODO* Update this method to actually edit a product when connected to a database**
  ///////////////////////////////////////////////////////////////////////////
  updateProduct() {
    Product newProduct = Product(
        name: name,
        description: description,
        image: "",
        id: null,
        price: price,
        businessId: widget.product.businessId,
        category: '',
        business: widget.product.business,
        featured: isFeatured);
    print("user updating product with name: " + newProduct.name);
  }

  ///////////////////////////////////////////////////////////////////////////
  ///*TODO* Update this method to actually delete a product when connected to a database**
  ///////////////////////////////////////////////////////////////////////////
  deleteProduct() {}

  ///////////////////////////////////////////////////////////////////////////
  ///
  void updateCheckbox(bool? newValue) {
    setState(() {
      agreementChecked = newValue ?? false;
    });
  }

  void updateFeatured(bool? newValue) {
    setState(() {
      isFeatured = newValue ?? false;
    });
  }

  Widget buildCategories(ThemeNotifier themeNotifier) {
    List<Widget> categoryButtons = availableCategories.map((category) {
      return ElevatedButton(
        onPressed: () => selectCategory(category),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: selectedCategory == category
                  ? Colors.transparent
                  : AppStyles.getTextTertiary(themeNotifier.currentMode),
              width: 1.0, // Specify the border width
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          backgroundColor: selectedCategory == category
              ? AppStyles.getPrimaryLight(themeNotifier.currentMode)
              : AppStyles.getBackground(themeNotifier.currentMode),
          foregroundColor: selectedCategory == category
              ? Colors.white
              : AppStyles.getTextTertiary(themeNotifier.currentMode),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Text(category),
        ),
      );
    }).toList();

    // Use SideScrollingWidget to display category buttons
    return SideScrollingWidget(
      children: categoryButtons,
    );
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
                  Container(
                      margin: EdgeInsets.all(16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomBackButton(),
                            InkWell(
                                onTap: () => {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Delete Product",
                                                style: TextStyle(
                                                    color: AppStyles
                                                        .getTextPrimary(
                                                            themeNotifier
                                                                .currentMode))),
                                            backgroundColor:
                                                AppStyles.getCardBackground(
                                                    themeNotifier.currentMode),
                                            content: Text(
                                                "Are you sure you want to delete this product?",
                                                style: TextStyle(
                                                    color: AppStyles
                                                        .getTextPrimary(
                                                            themeNotifier
                                                                .currentMode))),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text("Cancel",
                                                    style: TextStyle(
                                                        color: AppStyles
                                                            .getPrimaryLight(
                                                                themeNotifier
                                                                    .currentMode))),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors
                                                      .red, // Red background color
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                  deleteProduct();
                                                },
                                                child: Text(
                                                  "Yes, Delete",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    },
                                child: Icon(Icons.delete_forever,
                                    color: Colors.red, size: 32))
                          ])),
                  SizedBox(height: 16),
                  Padding(
                      padding: EdgeInsets.only(left: 32, right: 32, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Add a product to your business from this page. All information must be entered and passed through the sensitive content checker before adding is completed.",
                              style: TextStyle(
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16)),
                          SizedBox(height: 32),
                          Text("Product Title",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode))),
                          SizedBox(height: 16),
                          TextField(
                            controller: nameController,
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode), // Set text color
                            ),
                            decoration: InputDecoration(
                              hintText: 'Product Title here...',
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
                            onChanged: updateProductTitle,
                          ),
                          SizedBox(height: 32),
                          Text("Product Price",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode))),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: priceController,
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                  themeNotifier.currentMode), // Set text color
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Product Price here...',
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
                            onChanged: (value) {
                              // Handle changed value if needed
                            },
                          ),
                          SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                side: BorderSide(
                                  color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode),
                                  width: 2.0,
                                ),
                                checkColor: Colors.white,
                                activeColor: AppStyles.getPrimaryLight(
                                    themeNotifier.currentMode),
                                value: isFeatured,
                                onChanged: (bool? newValue) {
                                  updateFeatured(newValue);
                                },
                              ),
                              Expanded(
                                child: Text(
                                  "Feature this Product?",
                                  style: TextStyle(
                                    color: AppStyles.getTextPrimary(
                                      themeNotifier.currentMode,
                                    ),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32),
                          Text("Product Image",
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
                          Text("Product Category",
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
                          Text("Product Description",
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
                            onChanged: updateProductDescription,
                          ),
                        ],
                      )),
                  SizedBox(height: 32),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          side: BorderSide(
                            color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode),
                            width: 2.0,
                          ),
                          checkColor: Colors.white,
                          activeColor: AppStyles.getPrimaryLight(
                              themeNotifier.currentMode),
                          value: agreementChecked,
                          onChanged: (bool? newValue) {
                            updateCheckbox(newValue);
                          },
                        ),
                        Expanded(
                          child: Text(
                            "By checking this box, you understand the terms and conditions of posting this product on GCU marketplace. ",
                            style: TextStyle(
                              color: AppStyles.getTextPrimary(
                                themeNotifier.currentMode,
                              ),
                              fontSize: 16,
                            ),
                          ),
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
                              if (ProfanityCheck.containsProfanity(name) ||
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
                                              color: AppStyles.getTextPrimary(
                                                  themeNotifier.currentMode))),
                                      content: Text(
                                          "Please remove any inappropriate content from the product details.",
                                          style: TextStyle(
                                              color: AppStyles.getTextPrimary(
                                                  themeNotifier.currentMode))),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('OK',
                                              style: TextStyle(
                                                  color:
                                                      AppStyles.getPrimaryLight(
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
                                // No inappropriate content found, proceed with updating the product
                                updateProduct();
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
                            'Update Product',
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
}
