import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/services/services.dart';

class CustomBarcode extends StatelessWidget {

  final User user;

  const CustomBarcode({Key? key, required this.user}) : super(key: key);

///////////////////////
  //Main Widget
///////////////////////
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // 16px margin on all sides
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF090410), // Stroke color
          width: 6.0, // Stroke width
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: BarcodeWidget(
          margin: const EdgeInsets.all(8.0),
          barcode: Barcode.code39(),
          data: user.id, // Barcode data
          drawText: false,
          width: double.infinity,
          height: 64.0, // Height of the barcode
          color: const Color(0xFF090410), // Barcode color
        ),
      ),
    );
  }
}
