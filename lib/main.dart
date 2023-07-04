import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wire_app2/api.dart';
import 'package:wire_app2/views/dashboard.dart';
import 'package:wire_app2/views/user_profile_page.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wire_app2/views/register_view.dart';
import 'package:wire_app2/views/station_list_page.dart';
import 'package:async/async.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          SharedPreferences prefs = snapshot.data!;
          var token = prefs.getString('token');

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: token == null ? RegisterPage() : Home(),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('An error occured.'),
              ),
            ),
          );
        }
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    MapView(),
    StationListPage(),
    UserProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'WireMap',
          style: TextStyle(color: Color(0xFFFF9F1C)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_circle_outlined),
            label: 'Stations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.orange,
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Set<Polyline> _polylines = Set<Polyline>();
  String googleAPIKey = 'YOUR_API_KEY';

  LatLng? userLocation;
  CancelableOperation? positionOperation;

  @override
  void initState() {
    super.initState();
    determinePosition();
  }

  Future<void> determinePosition() async {
    positionOperation = CancelableOperation.fromFuture(
      Future<void>(() async {
        bool serviceEnabled;
        LocationPermission permission;

        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return Future.error('Location services are disabled.');
        }

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return Future.error('Location permissions are denied');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }

        Position position = await Geolocator.getCurrentPosition();
        if (mounted) {
          setState(() {
            userLocation = LatLng(39.8914, 32.8012);
          });
        }
      }),
      onCancel: () {
        // Optionally, clean up or log after cancelation.
      },
    );
    await positionOperation!.valueOrCancellation(null);
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height *
                0.7,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              markers: markers,
              polylines: _polylines,
              initialCameraPosition: CameraPosition(
                target: userLocation!,
                zoom: 15.0,
              ),
              onTap: (LatLng location) {
                setState(() {
                  _polylines = Set<Polyline>();
                });
              },
            ),
          ),
          Container(
            height: 50.0,
            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: TypeAheadField<PlacesSearchResult>(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                  hintText: 'Enter Address',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.length > 2) {
                  final places = GoogleMapsPlaces(apiKey: googleAPIKey);
                  PlacesSearchResponse response =
                      await places.searchByText(pattern);
                  return response.results;
                } else {
                  return [];
                }
              },
              itemBuilder: (context, PlacesSearchResult suggestion) {
                return ListTile(
                  leading: Icon(Icons.location_city),
                  title: Text(suggestion.name),
                  subtitle: Text(suggestion.formattedAddress ?? ""),
                );
              },
              onSuggestionSelected: (PlacesSearchResult suggestion) async {
                await displayPrediction(suggestion);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> displayPrediction(PlacesSearchResult p) async {
    final places = GoogleMapsPlaces(apiKey: googleAPIKey);
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId);
    double lat = detail.result.geometry!.location.lat;
    double lng = detail.result.geometry!.location.lng;
    List<geo.Location> locations = await geo.locationFromAddress(p.name);
    print(lat);
    print(lng);
    print(locations.first.latitude);
    print(locations.first.longitude);
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromIconData(IconData iconData,
      {Color color = Colors.indigo, double size = 160}) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
            fontSize: size, fontFamily: iconData.fontFamily, color: color));

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    final stations = await Api.getStations();
    final List<Future<Marker>> stationMarkers = stations!.map((station) async {
      BitmapDescriptor icon =
          await getBitmapDescriptorFromIconData(Icons.electric_bolt_rounded);

      return Marker(
        markerId: MarkerId(station.id.toString()),
        position: LatLng(
            double.parse(station.latitude!), double.parse(station.longitude!)),
        icon: icon,
        onTap: () {
          setState(() {});

          showModalBottomSheet(
            context: context,
            builder: (context) {
              // Get the screen height
              final height = MediaQuery.of(context).size.height;

              // Get the screen width
              final width = MediaQuery.of(context).size.width;

              return Container(
                height: height * 0.2,
                width: width,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Station ID: ${station.id}'),
                    Text('Charge Speed: ${station.chargeSpeed}'),
                    Text(
                        'Status: ${(station.isBlocked ?? false) || (station.isBeingUsed ?? false) ? 'Currently Not Available' : 'Available'}'),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        onPrimary: Colors.white, 
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StationDetailPage(station: station)),
                        );
                      },
                      child: Text('View Details'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }).toList();

    Set<Marker> stationMarkerSet = Set.from(await Future.wait(stationMarkers));

    Marker userLocationMarker = Marker(
      markerId: MarkerId('userLocation'),
      position: userLocation!,
      icon: await getBitmapDescriptorFromIconData(
        Icons.electric_car,
        color: Colors.black,
        size: 140,
      ),
      infoWindow: InfoWindow(
        title: 'Your Location',
      ),
    );
    if (mounted) {
      setState(() {
        markers = stationMarkerSet;
        markers.add(userLocationMarker);
      });
    }
  }
}
