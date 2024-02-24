import 'package:flutter/material.dart';

class PulsingMarker extends StatefulWidget {
  final Color color;
  final double size;

  const PulsingMarker({Key? key, required this.color, this.size = 24}) : super(key: key);

  @override
  _PulsingMarkerState createState() => _PulsingMarkerState();
}

class _PulsingMarkerState extends State<PulsingMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 2).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(0.5),
            spreadRadius: _animation.value,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Icon(Icons.circle, color: widget.color, size: widget.size),
    );
  }
}
