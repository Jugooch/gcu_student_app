import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64, // Set the desired height
      width: double.infinity, // Take up 100% width
      color: const Color(0xFF522498), // Set your desired background color

      child: Center(
        child: Image.asset(
          'assets/images/GCU_Logo.png', // Replace with the path to your logo asset
          height: 37, // Set the desired logo height
          // You can adjust the logo width if needed:
          // width: 100,
        ),
      ),
    );
  }
}