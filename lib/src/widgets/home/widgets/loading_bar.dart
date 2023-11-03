import 'package:flutter/material.dart';

class LoadingBar extends StatefulWidget {
  const LoadingBar({super.key});

  @override
  _LoadingBarState createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust the animation duration as needed
    );

    _animation = Tween(begin: 0.1, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true); // Make the animation bounce back and forth
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16.0,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9), // Background color
        borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                width: _animation.value * 0.75 * MediaQuery.of(context).size.width,
                height: 16.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF207B49), // Active state color
                  borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
