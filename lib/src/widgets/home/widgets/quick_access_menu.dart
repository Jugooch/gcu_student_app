import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/user-preferences.dart';
import 'package:gcu_student_app/src/widgets/shared/pages/pages.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_styling.dart';
import 'package:provider/provider.dart';
import '../../../services/home-services/home-service.dart';
import 'package:camera/camera.dart';

class QuickAccessMenu extends StatefulWidget {
  const QuickAccessMenu({Key? key}) : super(key: key);

  @override
  _QuickAccessMenuState createState() => _QuickAccessMenuState();
}

class _QuickAccessMenuState extends State<QuickAccessMenu> with TickerProviderStateMixin {
  
///////////////////////
  //Properties
///////////////////////
  bool isEditButtonPressed = false;
  late Future<List<QuickAccessItem>> quickAccessItemsFuture;
  List<QuickAccessItem> quickAccessItems = [];
  
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;


///////////////////////
  //Initialize Animations and Data
///////////////////////
  @override
  void initState() {
    super.initState();

    quickAccessItemsFuture = HomeService().getAllQuickAccessItems();

    fetchData();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    _shakeAnimation =
        Tween<double>(begin: -2.0, end: 2.0).animate(_shakeController);

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        // Reverse the animation and start again
        _shakeController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
  
  
///////////////////////
  //Fetch Quick Access Items
///////////////////////
  Future<void> fetchData() async {
    quickAccessItems = await quickAccessItemsFuture;
    setState(() {});
  }

///////////////////////
  //Main Widget
///////////////////////
  @override
  Widget build(BuildContext context) {
    //global styling file
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    //Main Container
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(right: 32.0, left: 32.0, bottom: 32.0),
      decoration: BoxDecoration(
        color: AppStyles.getCardBackground(themeNotifier.currentMode),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: AppStyles.getBlack(themeNotifier.currentMode).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quick Access',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isEditButtonPressed = !isEditButtonPressed;
                    });
                    if (isEditButtonPressed) {
                      // Handle the button press logic when it's pressed
                      _showXIconDialog(quickAccessItems.first);
                    } else {
                      // Handle the button press logic when it's released
                      _saveQuickAccessItems(quickAccessItems.first);
                    }
                  },
                  icon: isEditButtonPressed
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : Icon(Icons.edit,
                          color: AppStyles.getTextTertiary(
                              themeNotifier.currentMode)),
                  color: AppStyles.getTextTertiary(themeNotifier.currentMode),
                  iconSize: 20,
                )
              ],
            ),
          ),

          //spacing
          const SizedBox(height: 8.0),

          //Build out the quick access items
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: calculateSpacing(MediaQuery.of(context).size.width),
                runSpacing: 16.0,
                children: quickAccessItems
                    .where((item) => item.isIncluded)
                    .map((item) => _buildQuickAccessItem(
                        item: item, themeNotifier: themeNotifier))
                    .toList(),
              ),
            )
          ),
        ],
      ),
    );
  }


///////////////////////
  //Helper Methods
///////////////////////

//decides width of container based on screen size
  double calculateSpacing(double screenWidth) {
    int desiredItemsPerRow = 4;
    double totalSpacing = 16.0 * (desiredItemsPerRow - 1);
    double itemWidth = (screenWidth - totalSpacing) / desiredItemsPerRow;
    return (itemWidth)/4; // Adjust the spacing based on your preference
  }

  //Puts together each individual quick access item
  Widget _buildQuickAccessItem(
      {required QuickAccessItem item, required themeNotifier}) {
    if (item.icon != Icons.add) {
      return InkWell(
        onTap: () {
          // Handle regular tap (e.g., navigate to a screen)
          _linkToPage(item);
        },
        onLongPress: () {
          // Show X icon and handle removal
          _showXIconDialog(item);
        },
        child: SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            children: [
              // Main icon circle
              Positioned(
                left: (64 - 40) / 2, // Center horizontally
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppStyles.getPrimaryDark(themeNotifier.currentMode),
                  ),
                  child: Center(
                    child: Icon(item.icon, size: 24, color: Colors.white),
                  ),
                ),
              ),
              // Label
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color:
                          AppStyles.getTextTertiary(themeNotifier.currentMode),
                    ),
                  ),
                ),
              ),
              // X icon circle
              if (item.isSelected) _buildShakingXIcon(item),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
          onTap: () {
            _showAddMenu(context, themeNotifier);
          },
          child: SizedBox(
            width: 64,
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        AppStyles.getButtonTertiary(themeNotifier.currentMode),
                  ),
                  child: Center(
                    child: Icon(item.icon,
                        size: 24,
                        color: AppStyles.getTextTertiary(
                            themeNotifier.currentMode)),
                  ),
                ),
              ],
            ),
          ));
    }
  }

  //shows the delete button on the items
  void _showXIconDialog(QuickAccessItem item) {
    setState(() {
      // Start the animation
      _shakeController.reset();
      _shakeController.forward();
      for (var element in quickAccessItems) {
        if(element.icon == Icons.add){
          element.isIncluded = false;
        }
        else{
          element.isSelected = true;
        }
      }
      isEditButtonPressed = true;
    });
  }

  //saves the current state of the menu
  void _saveQuickAccessItems(QuickAccessItem item) {
    setState(() {
      for (var element in quickAccessItems) {
        if(element.icon == Icons.add){
          element.isIncluded = true;
        }
        else{
          element.isSelected = false;
        }
      }
      HomeService().saveQuickAccessItems(quickAccessItems);
      isEditButtonPressed = false;
    });
  }

  //builds the x that shakes when being edited
  Widget _buildShakingXIcon(item) {
    return Positioned(
      top: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0.0),
            child: child,
          );
        },
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.close, color: Colors.white, size: 24.0),
              onPressed: () {
                _removeQuickAccessItem(item);
              },
            ),
          ),
        ),
      ),
    );
  }

//removes an item from the quick access list
  void _removeQuickAccessItem(item) {
    setState(() {
      var totalItems = quickAccessItems.map((e) => e.isIncluded == true);
      var selectedItem =
          quickAccessItems.firstWhere((element) => element == item);
      selectedItem.isIncluded = false;
          if(totalItems.length != quickAccessItems.length){
        var addButton = quickAccessItems.firstWhere((element) => element.label == '');
        addButton.isIncluded = true;
      }
      HomeService().saveQuickAccessItems(quickAccessItems);
    });
  }

  // Add an item to the quick access list
  void _addQuickAccessItem(QuickAccessItem item) {
    setState(() {
      var totalItems = quickAccessItems.where((e) => e.isIncluded == true);
      var selectedItem =
          quickAccessItems.firstWhere((element) => element == item);
      selectedItem.isIncluded = true;
          if(totalItems.length == quickAccessItems.length){
        var addButton = quickAccessItems.firstWhere((element) => element.label == '');
        addButton.isIncluded = false;
      }
      HomeService().saveQuickAccessItems(quickAccessItems);
    });
  }

// Show the Add Menu
void _showAddMenu(BuildContext context, ThemeNotifier themeNotifier) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppStyles.getCardBackground(themeNotifier.currentMode),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      // Filter out items where isIncluded is false
      List<QuickAccessItem> includedItems = quickAccessItems.where((item) => !item.isIncluded).toList();

      return Column(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: SizedBox(
              height: 55.0, // Set the desired height
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.getInactiveIcon(themeNotifier.currentMode),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                  ),
                ),
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: includedItems.length * 65.0, // Adjust the height based on your item size (assuming 65.0 is the item height)
              child: ListView.builder(
                itemCount: includedItems.length * 2 - 1, // Double the itemCount to include separators
                itemBuilder: (BuildContext context, int index) {
                  if (index.isEven) {
                    QuickAccessItem item = includedItems[index ~/ 2];
                    return _buildQuickAccessMenuItem(item, context, themeNotifier);
                  } else {
                    return Container(height: 1.0, color: AppStyles.getTextPrimary(themeNotifier.currentMode));
                  }
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}




// Builds each menu item in the add menu
Widget _buildQuickAccessMenuItem(
  QuickAccessItem item, BuildContext context, ThemeNotifier themeNotifier,
) {
  return ListTile(
    onTap: () {
      Navigator.pop(context); // Close the menu
      _addQuickAccessItem(item);
    },
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(item.icon, color: AppStyles.getTextPrimary(themeNotifier.currentMode)),
            const SizedBox(width: 12.0),
            Text(item.label, style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode))),
          ],
        ),
        Icon(Icons.keyboard_arrow_right, color: AppStyles.getTextTertiary(themeNotifier.currentMode)),
      ],
    ),
  );
}

  //builds the add button for the menu
  Widget _buildAddButton({required IconData icon, required themeNotifier}) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppStyles.getButtonTertiary(themeNotifier.currentMode),
            ),
            child: Center(
              child: Icon(icon,
                  size: 24,
                  color: AppStyles.getTextTertiary(themeNotifier.currentMode)),
            ),
          ),
        ],
      ),
    );
  }

  
  _linkToPage(QuickAccessItem quickAccessItem) {
    switch (quickAccessItem.label) {
      case "Schedule":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SchedulePage()),
        );
        break;
      case "Hours":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HoursPage()),
        );
        break;
      case "Map":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapPage()),
        );
        break;
      case "Portal":
        _launchURL();
        break;
      case "Chapel":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChapelPage()),
        );
        break;
      case "Budget":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CardAccountsPage()),
        );
        break;
      case "Event QR":
      _launchDeviceCamera();
        break;
      case "Settings":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
      default:
    }
  }

  _launchURL() async {
   final Uri url = Uri.parse('https://gcuportal.gcu.edu/');
   if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
    }
}

  _launchDeviceCamera() async {
    await availableCameras().then((value) => Navigator.push(context,
                MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
  }
}
