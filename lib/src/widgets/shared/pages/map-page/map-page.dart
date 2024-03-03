import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gcu_student_app/src/app_styling.dart';
import 'package:gcu_student_app/src/current_theme.dart';
import 'package:gcu_student_app/src/services/shared-services/map-service.dart';
import 'package:gcu_student_app/src/widgets/shared/back-button/back-button.dart';
import 'package:gcu_student_app/src/widgets/shared/expandable-text/expandable_text.dart';
import 'package:gcu_student_app/src/widgets/shared/loading/loading.dart';
import 'package:gcu_student_app/src/widgets/shared/side_scrolling/side_scrolling.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/pulsing-user-marker.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = MapController();
  late Future<List<MapBuilding>> futureBuildings;
  List<MapBuilding> buildings = [];
  List<Marker> mapMarkers = []; // Markers for buildings and user's location
  late Location location;
  late StreamSubscription<LocationData> locationSubscription;
  Marker? userLocationMarker;
  bool isExpanded = false;
  bool filtersExpanded = false;
  String searchQuery = '';
  var types = [
    "All",
    "ACE Centers",
    "Athletics",
    "Classrooms",
    "Food Service",
    "Parking",
    "Public Safety",
    "Student Housing",
    "Student Services",
    "Other"
  ];
  String selectedType = "All";

  @override
  void initState() {
    super.initState();
    initializeLocationService();
    futureBuildings = MapService().getBuildings();
    fetchData();
  }

  void initializeLocationService() async {
    location = Location();
    // Check and request location permissions...
    // After permissions are granted:
    locationSubscription =
        location.onLocationChanged.listen(updateUserLocationMarker);
  }

  fetchData() async {
    buildings = await futureBuildings;
    updateBuildingMarkers();

    return futureBuildings;
  }

  void updateBuildingMarkers() {
    var themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    List<Marker> tempMarkers = [];

    for (var building in buildings) {
      bool matchesSearchQuery = searchQuery.isEmpty ||
          building.id.toString().toLowerCase().contains(searchQuery) ||
          building.name.toLowerCase().contains(searchQuery);

      if ((selectedType == "All" ||
              building.type.contains(selectedType.toLowerCase())) &&
          matchesSearchQuery) {
        var marker = Marker(
          point: LatLng(building.latitude, building.longitude),
          child: InkWell(
              onTap: () => _showBuildingInfo(building),
              child: CustomMarkerWidget(
                label: building.id.toString(),
                color: AppStyles.getPrimaryLight(themeNotifier.currentMode),
              )),
          width: 32,
          height: 32,
        );
        tempMarkers.add(marker);
      }
    }

    setState(() {
      mapMarkers = tempMarkers;
    });
  }

//Builds out the filter buttons widget for the page
  Widget buildFilterButtons(ThemeNotifier themeNotifier) {
    List<Widget> categoryButtons = types.map((type) {
      return ElevatedButton(
        onPressed: () => setState(() {
          selectedType = type;
          updateBuildingMarkers();
        }),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: selectedType == type
                  ? Colors.transparent
                  : AppStyles.getTextTertiary(themeNotifier.currentMode),
              width: 1.0, // Specify the border width
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          backgroundColor: selectedType == type
              ? AppStyles.getPrimaryLight(themeNotifier.currentMode)
              : AppStyles.getBackground(themeNotifier.currentMode),
          foregroundColor: selectedType == type
              ? Colors.white
              : AppStyles.getTextTertiary(themeNotifier.currentMode),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Text(type),
        ),
      );
    }).toList();

    // Use SideScrollingWidget to display category buttons
    return SideScrollingWidget(
      children: categoryButtons,
    );
  }

  void updateUserLocationMarker(LocationData currentLocation) {
    LatLng newPosition =
        LatLng(currentLocation.latitude!, currentLocation.longitude!);
    var newUserLocationMarker =
        Marker(point: newPosition, child: PulsingMarker(color: Colors.blue));

    setState(() {
      // Remove the old user location marker if it exists
      if (userLocationMarker != null) {
        mapMarkers.remove(userLocationMarker);
      }
      // Update the reference and add the new marker
      userLocationMarker = newUserLocationMarker;
      mapMarkers.add(userLocationMarker!);
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
        appBar: CupertinoNavigationBar(
                  border: null,
                  backgroundColor:
                      AppStyles.getPrimary(themeNotifier.currentMode),
                  middle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/GCU_Logo.png',
                        height: 32.0,
                      ),
                    ],
                  ),
                ),
        body: FutureBuilder<List<MapBuilding>>(
            future: futureBuildings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Loading();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                // Data is loaded
                return Stack(children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                        initialCenter:
                            LatLng(33.5127901870539, -112.12739983255989),
                        initialZoom: 17,
                        cameraConstraint: CameraConstraint.containCenter(
                            bounds: LatLngBounds(
                                LatLng(33.51753154279918, -112.13456797800325),
                                LatLng(
                                    33.50968308297375, -112.11300907234751)))),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.gcu.gcu_student_app',
                      ),
                      MarkerLayer(markers: mapMarkers),
                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution(
                            'OpenStreetMap contributors',
                            onTap: () => launchUrl(Uri.parse(
                                'https://openstreetmap.org/copyright')),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Wrap(children: [
                    Container(
                        decoration: BoxDecoration(
                            color: AppStyles.getBackground(
                                themeNotifier.currentMode)),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomBackButton(),
                                  Image.asset('assets/images/ErrorImage.png',
                                      width: 64),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          isExpanded = !isExpanded;
                                          filtersExpanded = false;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(
                                            isExpanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                            size: 32,
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier.currentMode)),
                                      ))
                                ]),
                            isExpanded
                                ? Column(children: [
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: TextField(
                                          style: TextStyle(
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier
                                                    .currentMode), // Set text color
                                          ),
                                          decoration: InputDecoration(
                                            hintText:
                                                'Search for a building...',
                                            hintStyle: TextStyle(
                                              color: AppStyles.getInactiveIcon(
                                                  themeNotifier
                                                      .currentMode), // Set hint text color
                                            ),
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color: AppStyles.getTextPrimary(
                                                  themeNotifier
                                                      .currentMode), // Set icon color
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppStyles.getTextPrimary(
                                                    themeNotifier
                                                        .currentMode), // Set border color
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppStyles.getTextPrimary(
                                                    themeNotifier
                                                        .currentMode), // Set border color when the TextField is focused
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              searchQuery = value.toLowerCase();
                                              updateBuildingMarkers();
                                            });
                                          },
                                        )),
                                        SizedBox(width: 16),
                                        InkWell(
                                            onTap: () {
                                              setState(() {
                                                filtersExpanded =
                                                    !filtersExpanded;
                                              });
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: filtersExpanded
                                                        ? AppStyles.getPrimaryLight(
                                                            themeNotifier
                                                                .currentMode)
                                                        : AppStyles.getBackground(
                                                            themeNotifier
                                                                .currentMode),
                                                    border: Border(
                                                        left: BorderSide(
                                                            width: 2,
                                                            color: filtersExpanded
                                                                ? Colors
                                                                    .transparent
                                                                : AppStyles.getPrimaryLight(
                                                                    themeNotifier
                                                                        .currentMode)),
                                                        right: BorderSide(width: 2, color: filtersExpanded ? Colors.transparent : AppStyles.getPrimaryLight(themeNotifier.currentMode)),
                                                        bottom: BorderSide(width: 2, color: filtersExpanded ? Colors.transparent : AppStyles.getPrimaryLight(themeNotifier.currentMode)),
                                                        top: BorderSide(width: 2, color: filtersExpanded ? Colors.transparent : AppStyles.getPrimaryLight(themeNotifier.currentMode)))),
                                                padding: EdgeInsets.all(12),
                                                child: Icon(
                                                  Icons.filter_alt,
                                                  color: filtersExpanded
                                                      ? Colors.white
                                                      : AppStyles
                                                          .getPrimaryLight(
                                                              themeNotifier
                                                                  .currentMode),
                                                  size: 32,
                                                ))),
                                      ],
                                    ),
                                  ])
                                : Container(),
                            filtersExpanded
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: AppStyles.getBackground(
                                            themeNotifier.currentMode)),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 16),
                                        Container(
                                          child:
                                              buildFilterButtons(themeNotifier),
                                        ),
                                      ],
                                    ))
                                : Container()
                          ],
                        )),
                  ]),
                ]
              );
            }
          }
        )
      );
  }

  void _showBuildingInfo(MapBuilding building) {
    var themeNotifier =
        Provider.of<ThemeNotifier>(context, listen: false); // If needed

    showModalBottomSheet<void>(
      context: context, // Use context available in State class
      backgroundColor: AppStyles.getBackground(themeNotifier.currentMode),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: SizedBox(
                height: 55.0, // Set the desired height
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppStyles.getInactiveIcon(themeNotifier.currentMode),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                    ),
                  ),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
            ),
            // Add content for the building info here
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Building Picture should go here
                Container(),

                SizedBox(height: 32),

                //Title Row
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 16, bottom: 16, left: 32, right: 32),
                    decoration: BoxDecoration(
                        color: AppStyles.getCardBackground(
                            themeNotifier.currentMode),
                        boxShadow: [
                          BoxShadow(
                            color: AppStyles.darkBlack.withOpacity(.12),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(building.name,
                            style: TextStyle(
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
                                fontWeight: FontWeight.bold,
                                fontSize: 24)),
                        SizedBox(height: 16),
                        Text("Building ${building.id}",
                            style: TextStyle(
                                color: AppStyles.getPrimaryLight(
                                    themeNotifier.currentMode),
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ],
                    )),

                Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Building Information
                        Text("Building Information",
                            style: TextStyle(
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        SizedBox(height: 16),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: AppStyles.getCardBackground(
                                    themeNotifier.currentMode),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppStyles.darkBlack.withOpacity(.12),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ]),
                            child: building.description != ""
                                ? ExpandableText(text: building.description)
                                : Text("No description available...",
                                    style: TextStyle(
                                        color: AppStyles.getTextPrimary(
                                            themeNotifier.currentMode),
                                        fontSize: 16))),
                        SizedBox(height: 32),
                        Text("Includes",
                            style: TextStyle(
                                color: AppStyles.getTextPrimary(
                                    themeNotifier.currentMode),
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        SizedBox(height: 16),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: AppStyles.getCardBackground(
                                    themeNotifier.currentMode),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppStyles.darkBlack.withOpacity(.12),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: building.includes.isNotEmpty
                                  ? building.includes.map((e) {
                                      return Column(
                                        children: [
                                          Text(
                                            e,
                                            style: TextStyle(
                                              color: AppStyles.getTextPrimary(
                                                  themeNotifier.currentMode),
                                              fontSize: 16,
                                            ),
                                          ),
                                          if (e != building.includes.last)
                                            SizedBox(height: 16),
                                        ],
                                      );
                                    }).toList()
                                  : [
                                      Text("No includes to show...",
                                          style: TextStyle(
                                            color: AppStyles.getTextPrimary(
                                                themeNotifier.currentMode),
                                            fontSize: 16,
                                          ))
                                    ],
                            ))
                      ],
                    ))
              ],
            )))
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }
}

class CustomMarkerWidget extends StatelessWidget {
  final String label;
  final Color color;

  CustomMarkerWidget({Key? key, required this.label, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color, // Use the passed color
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
