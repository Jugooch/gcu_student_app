import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import '../../../app_styling.dart';
import 'package:provider/provider.dart';
import '../../../services/home-services/home-service.dart';

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

    fetchData();
    _shakeController = AnimationController(
      duration: Duration(milliseconds: 50),
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
    quickAccessItemsFuture = HomeService().getAllQuickAccessItems();
    quickAccessItems = await quickAccessItemsFuture;
    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

///////////////////////
  //Main Widget
///////////////////////
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: AppStyles.getCardBackground(themeNotifier.currentMode),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: AppStyles.darkBlack.withOpacity(.12),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                      ? Icon(
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
          const SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
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
  double calculateSpacing(double screenWidth) {
    int desiredItemsPerRow = 4;
    double totalSpacing = 16.0 * (desiredItemsPerRow - 1);
    double itemWidth = (screenWidth - totalSpacing) / desiredItemsPerRow;
    return (itemWidth)/4; // Adjust the spacing based on your preference
  }

  Widget _buildQuickAccessItem(
      {required QuickAccessItem item, required themeNotifier}) {
    if (item.icon != Icons.add) {
      return InkWell(
        onTap: () {
          // Handle regular tap (e.g., navigate to a screen)
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
          onTap: () {},
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

  void _showXIconDialog(QuickAccessItem item) {
    setState(() {
      // Start the animation only if it's not already running
      _shakeController.reset();
      _shakeController.forward();
      quickAccessItems.forEach((element) {
        if(element.icon == Icons.add){
          element.isIncluded = false;
        }
        else{
          element.isSelected = true;
        }
      });
      isEditButtonPressed = true;
    });
  }

  void _saveQuickAccessItems(QuickAccessItem item) {
    setState(() {
      quickAccessItems.forEach((element) {
        if(element.icon == Icons.add){
          element.isIncluded = true;
        }
        else{
          element.isSelected = false;
        }
      });
      isEditButtonPressed = false;
    });
  }

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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
          child: Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.close, color: Colors.white, size: 24.0),
              onPressed: () {
                _removeQuickAccessItem(item);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _removeQuickAccessItem(item) {
    setState(() {
      var selectedItem =
          quickAccessItems.firstWhere((element) => element == item);
      if (selectedItem != null) {
        selectedItem.isIncluded = false;
      }
    });
  }

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
}
