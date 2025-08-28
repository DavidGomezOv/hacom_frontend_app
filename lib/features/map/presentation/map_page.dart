import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hacom_frontend_app/core/services/location_service.dart';
import 'package:hacom_frontend_app/features/map/domain/entities/map_marker_entity.dart';
import 'package:hacom_frontend_app/shared/widgets/base_page.dart';

class MapPage extends StatefulWidget {
  final List<MapMarkerEntity> markerEntities;

  const MapPage({super.key, required this.markerEntities});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;

  final ClusterManager _myCluster = ClusterManager(
    clusterManagerId: ClusterManagerId('id'),
  );

  @override
  Widget build(BuildContext context) {
    final bool isSingleMarker = widget.markerEntities.length == 1;

    return BasePage(
      pageTitle: 'Map View',
      pageDescription: 'View the vehicle in the Map',
      showBackButton: true,
      content: FutureBuilder(
        future: LocationService.getCurrentLocation(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.done) {
            final markers = _getMarkers();
            final initialPosition = CameraPosition(
              target: LatLng(
                widget.markerEntities.first.latitude,
                widget.markerEntities.first.longitude,
              ),
              zoom: 15,
            );
            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Stack(
                children: [
                  GoogleMap(
                    clusterManagers: {_myCluster},
                    initialCameraPosition: initialPosition,
                    markers: markers,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                  if (Platform.isIOS)
                    Positioned(
                      right: 15,
                      bottom: 70,
                      child: Column(
                        children: [
                          FloatingActionButton(
                            mini: true,
                            heroTag: '_zoomIn',
                            onPressed: () {
                              _mapController?.animateCamera(
                                CameraUpdate.zoomIn(),
                              );
                            },
                            child: const Icon(Icons.add),
                          ),
                          const SizedBox(height: 8),
                          FloatingActionButton(
                            mini: true,
                            heroTag: '_zoomOut',
                            onPressed: () {
                              _mapController?.animateCamera(
                                CameraUpdate.zoomOut(),
                              );
                            },
                            child: const Icon(Icons.remove),
                          ),
                          const SizedBox(height: 8),
                          if (isSingleMarker)
                            FloatingActionButton(
                              mini: true,
                              onPressed: () {
                                _mapController?.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(
                                        widget.markerEntities.first.latitude,
                                        widget.markerEntities.first.longitude,
                                      ),
                                      zoom: 15,
                                    ),
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
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Set<Marker> _getMarkers() => widget.markerEntities
      .map(
        (entity) => Marker(
          markerId: MarkerId(entity.markerId.toString()),
          position: LatLng(entity.latitude, entity.longitude),
          infoWindow: InfoWindow(
            title: entity.markerTitle,
            snippet: entity.markerLabel,
          ),
          clusterManagerId: _myCluster.clusterManagerId,
        ),
      )
      .toSet();
}
