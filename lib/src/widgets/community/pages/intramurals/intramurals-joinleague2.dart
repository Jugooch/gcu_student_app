import 'package:flutter/material.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/services.dart';
import 'package:gcu_student_app/src/widgets/community/pages/intramurals/intramurals-quiz.dart';
import 'package:gcu_student_app/src/widgets/community/widgets/intramurals/team_card.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class IntramuralsJoinLeague2 extends StatefulWidget {
  final League league;

  const IntramuralsJoinLeague2({required this.league, Key? key})
      : super(key: key);

  @override
  _IntramuralsJoinLeague2State createState() => _IntramuralsJoinLeague2State();
}

class _IntramuralsJoinLeague2State extends State<IntramuralsJoinLeague2> {
  ///////////////////////
  //Properties
  ///////////////////////
  late Future<User> userFuture;
  User user = User(name: "", id: "", image: "assets/images/Me.png");
  late Future<List<Team>> futureTeams;
  List<Team> teams = [];
  List<Team> filteredTeams = [];

  int selectedTabIndex = 0;
  String searchQuery = ''; // To hold the search query

  Team newTeam = Team(
      league: "",
      teamName: "",
      members: [],
      captain: "",
      sportsmanship: 3,
      games: [],
      image: "assets/images/Lopes.jpg",
      autoAcceptMembers: false,
      inviteOnly: false);

  // This is the file that will be used to store the image
  File? _image;

  // This is the image picker
  final _picker = ImagePicker();

  ///////////////////////
  //Initialize State and Data
  ///////////////////////
  @override
  void initState() {
    super.initState();
    futureTeams = IntramuralService().getLeagueTeams(widget.league);
    fetchData();
  }

  fetchData() async {
    userFuture = UserService().getUser("20692303");
    user = await userFuture;

    teams = await futureTeams;

    setState(() {});
  }

  ////////////////////////////////
  ///Format the date in a readable way
  ////////////////////////////////
  String _formatDate(DateTime dateTime) {
    // Formats a DateTime like "Wednesday - January 01, 2023"
    return DateFormat('MMMM dd').format(dateTime);
  }

  void updateSearchQuery(String query) {
    List<Team> tempTeams = teams;

    setState(() {
      searchQuery = query;

      if (searchQuery.isNotEmpty) {
        tempTeams = tempTeams
            .where((team) =>
                team.teamName.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        filteredTeams = tempTeams;
      }
    });
  }

  void updateTeamName(String input) {
    newTeam.teamName = input;
  }

  void updateTeamImage() {}

  //Implementing image picker
  void _openImagePicker(
      {required BuildContext context, required ThemeNotifier themeNotifier}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery, themeNotifier);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera, themeNotifier);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource source, ThemeNotifier themeNotifier) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      // Crop the selected image
      final croppedFile = await ImageCropper()
          .cropImage(sourcePath: pickedFile.path, aspectRatioPresets: [
        CropAspectRatioPreset.square, // Forces a square crop aspect ratio
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppStyles.getPrimary(themeNotifier.currentMode),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true, // Locks the aspect ratio to the preset
            hideBottomControls: true),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        ),
      ]);

      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
        });
      } else {
        // Handle the case when cropping is canceled or fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image cropping cancelled')),
        );
      }
    } else {
      // Handle the case when image picking is canceled
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image picking cancelled')),
      );
    }
  }

  void updateAutoAccept(bool? newValue) {
    setState(() {
      newTeam.autoAcceptMembers = newValue ?? false;
    });
  }

  void updateInviteOnly(bool? newValue) {
    setState(() {
      newTeam.inviteOnly = newValue ?? false;
    });
  }

  void updateRemindMe(bool? newValue) {
    setState(() {});
  }

///////////////////////
  //Main Widget
///////////////////////
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return GestureDetector(
        onTap: () {
          // Call this method to hide the keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(11),
              child: Container(
                color: const Color(0xFF522498),
              ),
            ),
            backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
            body: FutureBuilder<List<Team>>(
                future: futureTeams,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Data is still loading
                    return Loading();
                  } else if (snapshot.hasError) {
                    // Handle error state
                    return Center(child: Text("Error loading data"));
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomBackButton(),
                            Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Text(widget.league.league,
                                        style: TextStyle(
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier.currentMode),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 16),
                                    Text(
                                        "${_formatDate(widget.league.seasonStart)} - ${_formatDate(widget.league.seasonEnd)}",
                                        style: TextStyle(
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier.currentMode),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300))
                                  ],
                                )),
                            SizedBox(height: 32),
                            Container(
                              decoration: BoxDecoration(
                                color: AppStyles.getCardBackground(
                                    themeNotifier.currentMode),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Set the selected tab index to 0 (Current Leagues)
                                        setState(() {
                                          selectedTabIndex = 0;
                                        });
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 24),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: selectedTabIndex == 0
                                                  ? AppStyles.getPrimaryLight(
                                                      themeNotifier.currentMode)
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Join Team",
                                            style: TextStyle(
                                              color: selectedTabIndex == 0
                                                  ? AppStyles.getPrimaryLight(
                                                      themeNotifier.currentMode)
                                                  : AppStyles.getTextPrimary(
                                                      themeNotifier
                                                          .currentMode),
                                              fontSize: 16,
                                              fontWeight: selectedTabIndex == 0
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // Set the selected tab index to 1 (Scheduled Leagues)
                                        setState(() {
                                          selectedTabIndex = 1;
                                        });
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 24),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: selectedTabIndex == 1
                                                  ? AppStyles.getPrimaryLight(
                                                      themeNotifier.currentMode)
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Create Team",
                                            style: TextStyle(
                                              color: selectedTabIndex == 1
                                                  ? AppStyles.getPrimaryLight(
                                                      themeNotifier.currentMode)
                                                  : AppStyles.getTextPrimary(
                                                      themeNotifier
                                                          .currentMode),
                                              fontSize: 16,
                                              fontWeight: selectedTabIndex == 1
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 32, right: 32, bottom: 16),
                                child: Column(
                                  children: [
                                    SizedBox(height: 32),

                                    ////////////////////////////////
                                    //Join a team
                                    ////////////////////////////////
                                    Visibility(
                                        visible: selectedTabIndex == 0,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextField(
                                                style: TextStyle(
                                                  color: AppStyles.getTextPrimary(
                                                      themeNotifier
                                                          .currentMode), // Set text color
                                                ),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Search for a team...',
                                                  hintStyle: TextStyle(
                                                    color: AppStyles
                                                        .getInactiveIcon(
                                                            themeNotifier
                                                                .currentMode), // Set hint text color
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: AppStyles.getTextPrimary(
                                                        themeNotifier
                                                            .currentMode), // Set icon color
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode), // Set border color
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode), // Set border color when the TextField is focused
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                onChanged: updateSearchQuery,
                                              ),
                                              SizedBox(height: 32),
                                              Text("Teams",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode))),
                                              SizedBox(height: 16),
                                              ...(searchQuery.isEmpty
                                                      ? teams
                                                      : filteredTeams)
                                                  .expand((e) => [
                                                        TeamCard(
                                                            team: e,
                                                            isJoin: true),
                                                        SizedBox(height: 16),
                                                      ])
                                                  .toList(),
                                            ])),

                                    ////////////////////////////////
                                    //Create a team
                                    ////////////////////////////////
                                    Visibility(
                                      visible: selectedTabIndex == 1,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 32),
                                            Text("Team Name",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppStyles
                                                        .getTextPrimary(
                                                            themeNotifier
                                                                .currentMode))),
                                            SizedBox(height: 16),
                                            TextField(
                                              maxLength: 25,
                                              style: TextStyle(
                                                color: AppStyles.getTextPrimary(
                                                    themeNotifier
                                                        .currentMode), // Set text color
                                              ),
                                              decoration: InputDecoration(
                                                hintText: 'Team name here...',
                                                hintStyle: TextStyle(
                                                  color: AppStyles.getInactiveIcon(
                                                      themeNotifier
                                                          .currentMode), // Set hint text color
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppStyles.getTextPrimary(
                                                        themeNotifier
                                                            .currentMode), // Set border color
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppStyles.getTextPrimary(
                                                        themeNotifier
                                                            .currentMode), // Set border color when the TextField is focused
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                              ),
                                              onChanged: updateTeamName,
                                            ),
                                            SizedBox(height: 32),
                                            Text("Team Image",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppStyles
                                                        .getTextPrimary(
                                                            themeNotifier
                                                                .currentMode))),
                                            SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      _openImagePicker(
                                                          context: context,
                                                          themeNotifier:
                                                              themeNotifier);
                                                    },
                                                    child: CircleAvatar(
                                                        radius: 64,
                                                        backgroundColor: AppStyles
                                                            .getCardBackground(
                                                                themeNotifier
                                                                    .currentMode),
                                                        child: ClipOval(
                                                            child: _image !=
                                                                    null
                                                                ? Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                    decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                            colorFilter:
                                                                                ColorFilter.mode(AppStyles.getPrimaryDark(themeNotifier.currentMode).withOpacity(0.3), BlendMode.srcATop),
                                                                            image: FileImage(_image!))),
                                                                    child: Icon(Icons.edit, color: AppStyles.getPrimaryLight(themeNotifier.currentMode)))
                                                                : Icon(
                                                                    Icons.add,
                                                                    color: AppStyles.getTextPrimary(
                                                                        themeNotifier
                                                                            .currentMode),
                                                                  )))),
                                                Text("Image set successfully",
                                                    style: TextStyle(
                                                        color: _image != null
                                                            ? Colors.green
                                                            : Colors
                                                                .transparent,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600))
                                              ],
                                            ),
                                            SizedBox(height: 32),
                                            Text("Preferences",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppStyles
                                                        .getTextPrimary(
                                                            themeNotifier
                                                                .currentMode))),
                                            SizedBox(height: 16),
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppStyles.getCardBackground(
                                                  themeNotifier.currentMode,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppStyles.darkBlack
                                                        .withOpacity(.12),
                                                    spreadRadius: 0,
                                                    blurRadius: 4,
                                                    offset: const Offset(0,
                                                        4), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Automatically Accept Members",
                                                    style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                        themeNotifier
                                                            .currentMode,
                                                      ),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    side: BorderSide(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode),
                                                      width: 2.0,
                                                    ),
                                                    checkColor: Colors.white,
                                                    activeColor: AppStyles
                                                        .getPrimaryLight(
                                                            themeNotifier
                                                                .currentMode),
                                                    value: newTeam
                                                        .autoAcceptMembers,
                                                    onChanged:
                                                        (bool? newValue) {
                                                      updateAutoAccept(
                                                          newValue);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppStyles.getCardBackground(
                                                  themeNotifier.currentMode,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppStyles.darkBlack
                                                        .withOpacity(.12),
                                                    spreadRadius: 0,
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Invite Only?",
                                                    style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                        themeNotifier
                                                            .currentMode,
                                                      ),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    side: BorderSide(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode),
                                                      width: 2.0,
                                                    ),
                                                    checkColor: Colors.white,
                                                    activeColor: AppStyles
                                                        .getPrimaryLight(
                                                            themeNotifier
                                                                .currentMode),
                                                    value: newTeam.inviteOnly,
                                                    onChanged:
                                                        (bool? newValue) {
                                                      updateInviteOnly(
                                                          newValue);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color:
                                                    AppStyles.getCardBackground(
                                                  themeNotifier.currentMode,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppStyles.darkBlack
                                                        .withOpacity(.12),
                                                    spreadRadius: 0,
                                                    blurRadius: 4,
                                                    offset: const Offset(0,
                                                        4), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Send Game Reminders?",
                                                    style: TextStyle(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                        themeNotifier
                                                            .currentMode,
                                                      ),
                                                      fontSize: 16,
                                                    ),
                                                  ),

                                                  ///////////////////////////////////////
                                                  ///Update to Use the configuration file
                                                  ///////////////////////////////////////
                                                  Checkbox(
                                                    side: BorderSide(
                                                      color: AppStyles
                                                          .getTextPrimary(
                                                              themeNotifier
                                                                  .currentMode),
                                                      width: 2.0,
                                                    ),
                                                    checkColor: Colors.white,
                                                    activeColor: AppStyles
                                                        .getPrimaryLight(
                                                            themeNotifier
                                                                .currentMode),
                                                    value: false,
                                                    onChanged:
                                                        (bool? newValue) {
                                                      updateRemindMe(newValue);
                                                    },
                                                  )
                                                  //////////////////////////////////////////
                                                  //////////////////////////////////////////
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 32),
                                            Container(
                                              height: 80.0,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  //logic to open subpage for the card clicked
                                                  newTeam.teamName != "" ||
                                                          newTeam.image == ""
                                                      ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      QuizPage(
                                                                        league:
                                                                            widget.league,
                                                                        team:
                                                                            newTeam,
                                                                        createTeam:
                                                                            true,
                                                                      )),
                                                        )
                                                      : null;
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(newTeam
                                                                  .teamName !=
                                                              ""
                                                          ? AppStyles
                                                              .getPrimaryDark(
                                                                  themeNotifier
                                                                      .currentMode)
                                                          : AppStyles.getPrimaryDark(
                                                                  themeNotifier
                                                                      .currentMode)
                                                              .withOpacity(.3)),
                                                  minimumSize:
                                                      MaterialStateProperty.all(
                                                    const Size(
                                                        0.5, 0), // 50% width
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Create Team',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                    )
                                  ],
                                ))
                          ]),
                    );
                  }
                })));
  }
}
