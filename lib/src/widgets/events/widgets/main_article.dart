import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/services/services.dart';

class MainArticleButton extends StatefulWidget {
  
  //pass in an article object
  final Article article;

  const MainArticleButton({Key? key, required this.article}) : super(key: key);

  @override
  _MainArticleButton createState() => _MainArticleButton();
}

class _MainArticleButton  extends State<MainArticleButton> {


///////////////////////
  //Main Widget
///////////////////////
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 320,
          height: 240,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 320,
                  height: 240,
                  decoration: ShapeDecoration(
                    color: const Color(0x33391A69),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 173,
                child: Container(
                  width: 320,
                  height: 67,
                  decoration: const ShapeDecoration(
                    color: Color(0xFF391A69),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                top: 181,
                child: SizedBox(
                  width: 283,
                  height: 51,
                  child: Text(
                    widget.article.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
