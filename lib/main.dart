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

  LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Demo'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("my_marker"),
                position: _center,
              ),
            },
          ),
          Positioned(
            bottom: 20,
            right: 40,
            child: ElevatedButton(
              onPressed: () async {
                // Get the user's current location
                Position position = await Geolocator.getCurrentPosition();
                LatLng userLocation =
                    LatLng(position.latitude, position.longitude);
                // Center the map on the user's location
                mapController.moveCamera(CameraUpdate.newLatLng(userLocation));
                // Update the marker's position and center the map on it when the user taps the button
                setState(() {
                  _center = userLocation;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 155, 46, 239),
                ),
              ),
              child: const Text("Bring me back home"),
            ),
          ),
        ],
      ),
      // floatingActionButton: ElevatedButton(
      //   onPressed: () async {
      //     // Get the user's current location
      //     Position position = await Geolocator.getCurrentPosition();
      //     LatLng userLocation = LatLng(position.latitude, position.longitude);
      //     // Center the map on the user's location
      //     mapController.moveCamera(CameraUpdate.newLatLng(userLocation));
      //     // Update the marker's position and center the map on it when the user taps the button
      //     setState(() {
      //       _center = userLocation;
      //     });
      //   },
      //   style: ButtonStyle(
      //     backgroundColor: MaterialStateProperty.all<Color>(
      //       const Color.fromARGB(255, 155, 46, 239),
      //     ),
      //   ),
      //   child: const Text("Bring me back home"),
      // ),
    );
  }
}
