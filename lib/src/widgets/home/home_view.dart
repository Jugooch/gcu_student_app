import 'package:flutter/material.dart';
import './widgets/student_id.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          children: [
            StudentId(),
          ],
        ),
      ),
    );
  }
}