import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key, required this.currentLocation}) : super(key: key);
  final LocationData currentLocation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationData?>(
      // future: currentLocation,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
        if (snapchat.hasData) {
          final LocationData currentLocation = snapchat.data;
          return SfMaps(
            layers: [
              MapTileLayer(
                initialFocalLatLng: MapLatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
                initialZoomLevel: 9,
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
