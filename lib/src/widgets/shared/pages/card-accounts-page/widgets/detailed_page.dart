import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:intl/intl.dart';

class DetailedPage extends StatelessWidget {
  final CardAccount account;

  
  //currency formatter
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  DetailedPage({required this.account, Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(11),
          child: Container(
            color: const Color(0xFF522498),
          )),
      body: SingleChildScrollView(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Container(
                  height: 190,
                  width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(account.background),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBackButton(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(account.name, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                        SizedBox(height: 8),
                        Text("\$${oCcy.format(account.currentBalance)}", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),       
                        SizedBox(height: 24),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 32.0), 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Column(children: [
                            Text("Rollover", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal)),
                            SizedBox(height: 8),
                            Text("\$${oCcy.format(account.totalRollover)}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal))
                          ],),
                          Column(children: [
                            Text("Fall", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal)),
                            SizedBox(height: 8),
                            Text("\$${oCcy.format(account.fallRollover)}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal))
                          ],),
                          Column(children: [
                            Text("Spring", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal)),
                            SizedBox(height: 8),
                            Text("\$${oCcy.format(account.springRollover)}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal))
                          ],),
                          Column(children: [
                            Text("Summer", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal)),
                            SizedBox(height: 8),
                            Text("\$${oCcy.format(account.summerRollover)}", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal))
                          ],)
                        ],),
                        ),
                      ],
                    ),
                  ],
                )),
                Padding(
                  padding: EdgeInsets.only(bottom: 32.0, right: 32.0, left: 32.0),
                  child: Column(),
                )
              ]
          )
        ),
    );
  }
}
