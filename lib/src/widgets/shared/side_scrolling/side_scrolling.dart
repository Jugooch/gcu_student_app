import 'package:flutter/material.dart';

class SideScrollingWidget extends StatelessWidget {
  final List<Widget> children;
  final double itemSpacing; // Specify the spacing between items

  const SideScrollingWidget({super.key, required this.children, this.itemSpacing = 16.0});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: children
            .map((child) => Container(
                  margin: EdgeInsets.only(right: itemSpacing), // Add right margin for spacing
                  child: child,
                ))
            .toList(),
      ),
    );
  }
}
