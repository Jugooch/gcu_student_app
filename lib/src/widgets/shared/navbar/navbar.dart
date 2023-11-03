import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final Function(int) onItemTapped;

  const NavBar({super.key, required this.onItemTapped});

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  // Define your icons and labels for the tabs.
  final List<IconData> _icons = [Icons.home, Icons.event, Icons.group, Icons.person];
  final List<String> _labels = ['Home', 'Events', 'Community', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      backgroundColor: const Color.fromRGBO(82, 36, 152, 1),
      selectedItemColor: const Color.fromRGBO(255, 255, 255, 1),
      unselectedItemColor: const Color.fromRGBO(213, 189, 239, 1),
      onTap: (index) {
        widget.onItemTapped(index); // Notify the parent about the selection
        setState(() {
          _selectedIndex = index; // Update the selected index locally
        });
      },
      items: List.generate(4, (index) {
        return BottomNavigationBarItem(
          icon: Icon(_icons[index]),
          label: _labels[index],
        );
      }),
    );
  }
}
