import 'package:flutter/material.dart';

class SideScrollingWidget extends StatelessWidget {
  //pass in a list of children to display
  final List<Widget> children;
  final double itemSpacing; // Specify the spacing between items

  const SideScrollingWidget({super.key, required this.children, this.itemSpacing = 16.0});


///////////////////////
  //Main Widget
///////////////////////
@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          //left margin
          SizedBox(width: 32),
          //The ... (spread) operator is used to insert the contents of the children list into a new list
          ...children
              .map((child) => Container(
                    margin: EdgeInsets.only(right: itemSpacing), // Add right margin for spacing
                    child: child,
                  ))
              .toList(),
          //right margin
          SizedBox(width: 16),
        ],
      ),
  );
}

}
