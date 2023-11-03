import 'package:flutter/material.dart';

class MainArticleButton extends StatelessWidget {
  const MainArticleButton({super.key});

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
              const Positioned(
                left: 15,
                top: 181,
                child: SizedBox(
                  width: 283,
                  height: 51,
                  child: Text(
                    'Men’s basketball - WAC Champions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
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