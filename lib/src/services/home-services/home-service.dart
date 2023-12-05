import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class HomeService {
  
///////////////////////
  //Getter Functions
///////////////////////


  //this getter gathers all the quick access items from the json data
  Future<List<QuickAccessItem>> getAllQuickAccessItems() async {
    try {
      // Use rootBundle to access files included with the app
      String jsonString = await rootBundle.loadString('assets/data/quick-access-data.json');
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<QuickAccessItem> quickAccessItems = jsonList.map((jsonItem) {
        return QuickAccessItem(
          icon: _getIconData(jsonItem['icon']),
          label: jsonItem['label'],
          isSelected: jsonItem['isSelected'] ?? false,
          isIncluded: jsonItem['isIncluded'] ?? false,
        );
      }).toList();

      return quickAccessItems;
    } catch (e) {
      print("Error reading JSON file: $e");
      return [];
    }
  }

///////////////////////
  //Helper Functions
///////////////////////

//this function takes in the stored icon names and converts them into IconDate to be used by the quick access items
  IconData _getIconData(String iconName) {
  Map<String, IconData> iconMap = {
    'calendar_today_outlined': Icons.calendar_today_outlined,
    'hourglass_empty_outlined': Icons.hourglass_empty_outlined,
    'map_outlined': Icons.map_outlined,
    'add_to_home_screen_outlined': Icons.add_to_home_screen_outlined,
    'church_outlined': Icons.church_outlined,
    'account_balance_wallet': Icons.account_balance_wallet,
    'qr_code_2_outlined': Icons.qr_code_2_outlined,
    'settings_outlined': Icons.settings_outlined,
    'add': Icons.add,
    // Add more mappings as needed
  };

  return iconMap[iconName] ?? Icons.error; // Return error icon if not found
}
}


///////////////////////
  //Quick Access Item Object
///////////////////////
class QuickAccessItem {
  final IconData icon;
  final String label;
  bool isSelected;
  bool isIncluded;

  QuickAccessItem(
      {required this.icon,
      required this.label,
      this.isSelected = false,
      this.isIncluded = false});
}