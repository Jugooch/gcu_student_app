import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/check-box/check-box.dart';
import 'package:gcu_student_app/src/widgets/shared/pages/settings-page/widgets/light-dark-toggle.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:app_settings/app_settings.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool locationAllowed = false;
  bool chapelCheckinAllowed = false;
  bool bluetoothAllowed = false;
  bool pushNotificationsAllowed = false;

    ///////////////////////
  // Initialize Checkbox states
  ///////////////////////
  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }


  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(11),
          child: Container(
            color: const Color(0xFF522498),
          )),
      backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomBackButton(),
        Padding(
          padding: EdgeInsets.only(bottom: 32.0, right: 32.0, left: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "App Theme",
                style: TextStyle(
                  color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppStyles.getCardBackground(
                    themeNotifier.currentMode,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppStyles.darkBlack.withOpacity(.12),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Light/Dark theme",
                      style: TextStyle(
                        color: AppStyles.getTextPrimary(
                          themeNotifier.currentMode,
                        ),
                        fontSize: 16,
                      ),
                    ),
                    LightDarkToggle(),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Chapel Check-in",
                style: TextStyle(
                  color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppStyles.getCardBackground(
                    themeNotifier.currentMode,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppStyles.darkBlack.withOpacity(.12),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Automatic Chapel Check-in",
                      style: TextStyle(
                        color: AppStyles.getTextPrimary(
                          themeNotifier.currentMode,
                        ),
                        fontSize: 16,
                      ),
                    ),
                    CheckBox(onCheck: _automaticChapelCheckin)
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Location",
                style: TextStyle(
                  color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ), 
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppStyles.getCardBackground(
                    themeNotifier.currentMode,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppStyles.darkBlack.withOpacity(.12),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Location Access",
                      style: TextStyle(
                        color: AppStyles.getTextPrimary(
                          themeNotifier.currentMode,
                        ),
                        fontSize: 16,
                      ),
                    ),
                    CheckBox(onCheck: _locationAccess)
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Bluetooth",
                style: TextStyle(
                  color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppStyles.getCardBackground(
                    themeNotifier.currentMode,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppStyles.darkBlack.withOpacity(.12),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Bluetooth Access",
                      style: TextStyle(
                        color: AppStyles.getTextPrimary(
                          themeNotifier.currentMode,
                        ),
                        fontSize: 16,
                      ),
                    ),
                    CheckBox(onCheck: _bluetoothAccess)
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Notifications",
                style: TextStyle(
                  color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppStyles.getCardBackground(
                    themeNotifier.currentMode,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppStyles.darkBlack.withOpacity(.12),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Allow Push Notifications",
                      style: TextStyle(
                        color: AppStyles.getTextPrimary(
                          themeNotifier.currentMode,
                        ),
                        fontSize: 16,
                      ),
                    ),
                    CheckBox(onCheck: _pushNotifications)
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Logout",
                style: TextStyle(
                  color: AppStyles.getTextPrimary(themeNotifier.currentMode),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 80.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: ElevatedButton(
                  onPressed: () {
                    _logoutUser();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        AppStyles.getPrimaryDark(themeNotifier.currentMode)),
                    minimumSize: MaterialStateProperty.all(
                      const Size(0.5, 0), // 50% width
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Logout Justice Gooch',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ])),
      bottomNavigationBar: null,
    );
  }

  _initializeSettings(){

  }

  _automaticChapelCheckin(isChecked) {
    print("Check-in to chapel!");

    return;
  }

  //allows access to location services
  _locationAccess(isChecked) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    if(!isChecked){
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    }
    else{
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.granted) {
      AppSettings.openAppSettings(type: AppSettingsType.location);
    }
    }
  }

  _bluetoothAccess(isChecked) {
    print("Bluetooth Accessed");
    
    return;
  }

  _pushNotifications(isChecked) {
    print("Notifications Pushed");
    
    return;
  }

  _logoutUser() {
    print("User logging out");
    
    return;
    }
}
