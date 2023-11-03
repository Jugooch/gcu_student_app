import 'custom_barcode.dart';
import 'package:gcu_student_app/src/widgets/home/widgets/loading_bar.dart';
import 'package:flutter/material.dart';

class StudentId extends StatelessWidget {
  const StudentId({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32.0),
      height: 508.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF391A69),
          width: 8.0,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [

                //1. Student ID Image
                AspectRatio(
                  aspectRatio: 262 / 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      'assets/images/Me.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 8.0),

                //2. Student Name Text Widget
                const Text(
                  'Justice Gooch',
                  style: TextStyle(
                    color: Color(0xFF090410),
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.center,
                ),

                //3. Student Designation
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF26614),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    width: 88.0,
                    child: const Center(
                      child: Text(
                        'Student',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


          const SizedBox(
            height: 80.0, // Specify the desired height for the CustomBarcode
            child: CustomBarcode(),
          ),

          const SizedBox(height: 8.0),

          //5. Custom Loading Bar Widget
          const LoadingBar(),

          const SizedBox(height: 16.0), // Vertical spacing

          // 6. Button
          Container(
            width: 160.0,
            height: 40.0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xFF391A69)),
                minimumSize: MaterialStateProperty.all(
                  const Size(0.5, 0), // 50% width
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white), // Icon
                  SizedBox(width: 8.0), // Spacing
                  Text(
                    'Add to Wallet',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
