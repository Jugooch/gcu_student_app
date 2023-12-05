import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, size: 24), // Back arrow icon
        onPressed: () {
          Navigator.pop(context); // Pop the current screen off the navigation stack
        },
      ),
    );
  }
}
