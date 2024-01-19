import 'custom_barcode.dart';
import 'package:gcu_student_app/src/widgets/home/widgets/loading_bar.dart';
import 'package:flutter/material.dart';
import '../../../app_styling.dart';
import '../../../current_theme.dart';
import '../../../services/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel('wallet_channel');

class StudentId extends StatefulWidget {
  const StudentId({Key? key}) : super(key: key);

  @override
  _StudentIdState createState() => _StudentIdState();
}

class _StudentIdState extends State<StudentId> {
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");

  ///////////////////////
  // Initialize Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  ///////////////////////
  // Fetch User
  ///////////////////////
  Future<void> fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    setState(() {
      // Trigger a rebuild with the fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Container(
      margin: const EdgeInsets.all(32.0),
      height: 508.0,
      decoration: BoxDecoration(
        color: AppStyles.getStudentIdBackground(themeNotifier.currentMode),
        border: Border.all(
          color: AppStyles.getPrimaryDark(themeNotifier.currentMode),
          width: 8.0,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: AppStyles.getBlack(themeNotifier.currentMode).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 1. Student ID Image
                AspectRatio(
                  aspectRatio: 262 / 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.asset(
                      user.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 8.0),

                // 2. Student Name Text Widget
                Text(
                  user.name,
                  style: TextStyle(
                    color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8.0),

                // 3. Student Designation
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

          // 5. Custom Loading Bar Widget
          const LoadingBar(),

          const SizedBox(height: 16.0), // Vertical spacing

          // 6. Add to Wallet Button
          Container(
            width: 160.0,
            height: 40.0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle button press
                _addToWallet();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppStyles.getPrimaryDark(themeNotifier.currentMode)),
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

//helper method to add student id to phone wallet
  _addToWallet(){

  }
}
