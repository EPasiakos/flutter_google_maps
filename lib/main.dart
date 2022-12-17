import 'dart:math';
//import 'package:location/location.dart' hide LocationAccuracy;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Google Maps Demo',
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
// ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  LatLng _center = const LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Stylise the buttons
  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 17),
    backgroundColor: const Color.fromARGB(255, 155, 46, 239),
    fixedSize: const Size(250, 70),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    shadowColor: Colors.black,
    elevation: 20,
  );

  // Create an array to store the previous coordinates visited.
  List<Map<String, double>> previousCoordinatesArray = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 14.0,
          ),
          markers: {
            Marker(
              markerId: const MarkerId("my_marker"),
              position: _center,
            ),
          },
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          //myLocationEnabled: true,
        ),

        // We use the layout builder to get the size of the screen and then we use that to determine the position of the buttons
        LayoutBuilder(
          // padding: const EdgeInsets.all(15.0),
          builder: (context, constraints) {
            // If the screen is wider than 600, use a row layout
            if (constraints.maxWidth > 600) {
              return Padding(
                padding: const EdgeInsets.all(50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        textStyle: style.textStyle,
                        alignment: style.alignment,
                        fixedSize: style.fixedSize,
                        shape: style.shape,
                        shadowColor: style.shadowColor,
                        elevation: style.elevation,
                        //Give the button a custom background color
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      onPressed: () {
                        // Generete random coordinates for the users location.
                        LatLng userLocation = LatLng(generateRandomLatitude(),
                            generateRandomLongitude());
                        // Center the map on the new user's location.
                        mapController
                            .moveCamera(CameraUpdate.newLatLng(userLocation));
                        // Update the marker's position and center the map on it when the user taps the button
                        setState(() {
                          _center = userLocation;
                        });
                        // add the new coordinates to the previousCoordinates map
                        previousCoordinatesArray.add({
                          'latitude': userLocation.latitude,
                          'longitude': userLocation.longitude
                        });
                      },
                      child: const Text('Teleport me to somewhere random'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: style,
                      onPressed: () async {
                        // Request the user's permission to access their location
                        await Geolocator.requestPermission();
                        // Check if the user granted permission to access their location
                        bool isLocationServiceEnabled =
                            await Geolocator.isLocationServiceEnabled();

                        if (isLocationServiceEnabled) {
                          // Get the user's current location
                          Position position =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high);
                          LatLng userLocation =
                              LatLng(position.latitude, position.longitude);
                          // Center the map on the user's location
                          mapController
                              .moveCamera(CameraUpdate.newLatLng(userLocation));
                          // Update the marker's position and center the map on it when the user taps the button
                          setState(() {
                            _center = userLocation;
                          });

                          // Generate the modal dialog that will show the user's current and previous coordinates
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor:
                                  const Color.fromARGB(125, 33, 33, 33),
                              titleTextStyle: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                              contentTextStyle: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                              title: const Text(
                                "Current location",
                                textAlign: TextAlign.center,
                              ),
                              content: Text(
                                  "Latitude: ${position.latitude.toInt()}\n Longitude: ${position.longitude.toInt()}\n\n Previous\n\n ${generatePreviousCoordinatesString()}",
                                  textAlign: TextAlign.center),
                            ),
                          );
                        } else {
                          // Handle the case where the user did not grant permission to access their location
                        }
                      },
                      child: const Text('Bring me back home'),
                    ),
                  ],
                ),
              );
            } else {
              // If the screen is narrower than 600, use a column layout
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          textStyle: style.textStyle,
                          fixedSize: style.fixedSize,
                          shape: style.shape,
                          shadowColor: style.shadowColor,
                          elevation: style.elevation,
                          //Give the button a custom background color
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () {
                          // Generete random coordinates for the users location.
                          LatLng userLocation = LatLng(generateRandomLatitude(),
                              generateRandomLongitude());
                          // Center the map on the new user's location.
                          mapController
                              .moveCamera(CameraUpdate.newLatLng(userLocation));
                          // Update the marker's position and center the map on it when the user taps the button
                          setState(() {
                            _center = userLocation;
                          });
                          // add the new coordinates to the previousCoordinates map
                          previousCoordinatesArray.add({
                            'latitude': userLocation.latitude,
                            'longitude': userLocation.longitude
                          });
                        },
                        child: const Text(
                          'Teleport me to somewhere random',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: style,
                        onPressed: () async {
                          // Request the user's permission to access their location
                          await Geolocator.requestPermission();
                          // Check if the user granted permission to access their location
                          bool isLocationServiceEnabled =
                              await Geolocator.isLocationServiceEnabled();

                          if (isLocationServiceEnabled) {
                            // Get the user's current location
                            Position position =
                                await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.high);
                            LatLng userLocation =
                                LatLng(position.latitude, position.longitude);
                            // Center the map on the user's location
                            mapController.moveCamera(
                                CameraUpdate.newLatLng(userLocation));
                            // Update the marker's position and center the map on it when the user taps the button
                            setState(() {
                              _center = userLocation;
                            });

                            // Generate the modal dialog that will show the user's current and previous coordinates
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor:
                                    const Color.fromARGB(125, 33, 33, 33),
                                titleTextStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                contentTextStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                title: const Text(
                                  "Current location",
                                  textAlign: TextAlign.center,
                                ),
                                content: Text(
                                    "Latitude: ${position.latitude.toInt()}\n Longitude: ${position.longitude.toInt()}\n\n Previous\n\n ${generatePreviousCoordinatesString()}",
                                    textAlign: TextAlign.center),
                              ),
                            );
                          } else {
                            // Handle the case where the user did not grant permission to access their location
                          }
                        },
                        child: const Text(
                          'Bring me back home',
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    ));
  }

  // Function that loops through the previousCoordinatesArray and generates a string with the coordinates to be used in the modal dialog
  String generatePreviousCoordinatesString() {
    String previousCoordinatesString = "";
    // Loop through the previousCoordinatesArray and generate a string with the coordinates formatted as Integers
    for (int i = 0; i < previousCoordinatesArray.length; i++) {
      previousCoordinatesString +=
          "Lat: ${previousCoordinatesArray[i]['latitude']!.toInt()}, Long: ${previousCoordinatesArray[i]['longitude']!.toInt()}\n\n";
    }
    return previousCoordinatesString;
  }
}

// Generate a random latitude between -90 and 90
double generateRandomLatitude() {
  Random random = Random();
  return random.nextDouble() * 180 - 90;
}

// Generate a random longitude between -180 and 180
double generateRandomLongitude() {
  Random random = Random();
  return random.nextDouble() * 360 - 180;
}
