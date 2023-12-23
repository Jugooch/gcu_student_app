import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      width: double.infinity, // Take up 100% width
      color: const Color(0xFF522498), // Set your desired background color
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Image.asset(
            'assets/images/GCU_Logo.png',
            height: 32, // Set the desired logo height
          ),
        ),
      ),
    );
  }
}
