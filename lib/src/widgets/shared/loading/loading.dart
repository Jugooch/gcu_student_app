import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:provider/provider.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      CircularProgressIndicator.adaptive(),
      Image.asset("assets/images/ErrorImage.png", width: 64)
    ],));
  }
}
