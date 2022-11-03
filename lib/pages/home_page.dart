import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<LocationData?> _currentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Text(
            widget.user.nama!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          mapWidget(),
        ],
      ),
    );
  }

  Widget mapWidget() {
    return FutureBuilder<LocationData?>(
      future: _currentLocation(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
        if (snapchat.hasData) {
          final LocationData currentLocation = snapchat.data;
          return SfMaps(
            layers: [
              MapTileLayer(
                initialFocalLatLng: MapLatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
                initialZoomLevel: 5,
                initialMarkersCount: 1,
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                markerBuilder: (BuildContext context, int index) {
                  return MapMarker(
                    latitude: currentLocation.latitude!,
                    longitude: currentLocation.longitude!,
                    size: const Size(20, 20),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red[800],
                    ),
                  );
                },
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
