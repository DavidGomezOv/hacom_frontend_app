import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hacom_frontend_app/features/supervisor/domain/entities/vehicle_entity.dart';
import 'package:hacom_frontend_app/shared/widgets/base_page.dart';

class MapPage extends StatefulWidget {
  final VehicleEntity vehicle;

  const MapPage({super.key, required this.vehicle});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final vehiclePosition = CameraPosition(
      target: LatLng(widget.vehicle.latitude ?? 0, widget.vehicle.longitude ?? 0),
      zoom: 15,
    );

    final marker = Marker(
      markerId: MarkerId(widget.vehicle.id.toString()),
      position: vehiclePosition.target,
      infoWindow: InfoWindow(title: widget.vehicle.plate, snippet: widget.vehicle.label),
    );

    return BasePage(
      pageTitle: 'Map View',
      pageDescription: 'View the vehicle in the Map',
      showBackButton: true,
      content: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: vehiclePosition,
              markers: {marker},
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
                _mapController?.showMarkerInfoWindow(marker.markerId);
              },
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Column(
                children: [
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      _mapController?.animateCamera(CameraUpdate.zoomIn());
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      _mapController?.animateCamera(CameraUpdate.zoomOut());
                    },
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      _mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(target: vehiclePosition.target, zoom: 15),
                        ),
                      );
                    },
                    child: const Icon(Icons.car_crash_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
