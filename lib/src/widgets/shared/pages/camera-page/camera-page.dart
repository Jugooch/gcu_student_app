import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage(
    {Key? key, required this.cameras}) : super(key:key);
@override
  State<CameraPage> createState() => _CameraPageState();
}
class _CameraPageState extends State<CameraPage> {
  bool _isRearCameraSelected = true;
  late CameraController _cameraController;

Future initCamera(CameraDescription cameraDescription) async {
// create a CameraController
  _cameraController = CameraController(
    cameraDescription, ResolutionPreset.high);
// Next, initialize the controller. This returns a Future.
  try {
    await _cameraController.initialize().then((_) {
    if (!mounted) return;
    setState(() {});
    });
  } on CameraException catch (e) {
    debugPrint("camera error $e");
  }
}

@override
void initState() {
  super.initState();
  // initialize the rear camera
  initCamera(widget.cameras![0]);
}

@override
void dispose() {
  // Dispose of the controller when the widget is disposed.
  _cameraController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        border: null,
        backgroundColor: AppStyles.getPrimary(themeNotifier.currentMode),
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 32),
            Image.asset(
              'assets/images/GCU_Logo.png',
              height: 32.0,
            ),
          ],
        ),
      ),
        body: SafeArea(
      child: Stack(children: [
        (_cameraController.value.isInitialized)
            ? CameraPreview(_cameraController)
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
        Align(
          alignment: Alignment.topLeft,  
          child: CustomBackButton(),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: AppStyles.getBackground(themeNotifier.currentMode)),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: Column(children: [
                      IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  icon: Icon(
                        Icons.switch_camera,
                        color: AppStyles.getTextPrimary(themeNotifier.currentMode)
                      ),
                  onPressed: () {
                    setState(
                        () => _isRearCameraSelected = !_isRearCameraSelected);
                    initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                  },
                ),
                Text("Swap Camera", style: TextStyle(color: AppStyles.getTextPrimary(themeNotifier.currentMode)),)
                ]
                )
                )
              ]),
            )),
      ]),
    ));
  }
}