import 'package:flutter/material.dart';

class LoadingBar extends StatefulWidget {
  // Constructor for the LoadingBar widget
  const LoadingBar({super.key});

  @override
  _LoadingBarState createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Animation controller to manage the animation
  late Animation<double> _animation; // Animation to drive the loading bar animation

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController with a duration of 2 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust the animation duration as needed
    );

    // Create a linear animation from 0.1 to 1.0 with ease-in-out curve
    _animation = Tween(begin: 0.1, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Repeat the animation in both forward and reverse directions to create a bouncing effect
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    // Dispose the AnimationController to free up resources
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
        color: const Color(0xFFD9D9D9), // Background color of the container
        borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              // Container representing the loading bar with active state color
              Container(
                width: _animation.value * 0.75 * MediaQuery.of(context).size.width,
                height: 16.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF207B49), // Active state color of the loading bar
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
