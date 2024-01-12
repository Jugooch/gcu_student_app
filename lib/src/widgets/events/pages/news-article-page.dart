import 'package:flutter/material.dart';

class NewsArticlePage extends StatelessWidget {
  const NewsArticlePage({Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(11),
          child: Container(
            color: const Color(0xFF522498),
          )),
      body: Center(
      ),
    );
  }
}