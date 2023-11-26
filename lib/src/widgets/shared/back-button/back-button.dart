import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, size: 24),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}