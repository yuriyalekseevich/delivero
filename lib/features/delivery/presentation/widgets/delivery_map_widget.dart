import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivero/core/services/location_service.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';

class DeliveryMapWidget extends StatefulWidget {
  final List<Delivery> deliveries;
  final LocationData? userLocation;
  final Function(Delivery)? onDeliverySelected;

  const DeliveryMapWidget({
    super.key,
    required this.deliveries,
    this.userLocation,
    this.onDeliverySelected,
  });

  @override
  State<DeliveryMapWidget> createState() => _DeliveryMapWidgetState();
}

class _DeliveryMapWidgetState extends State<DeliveryMapWidget> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  LatLng? _center;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void didUpdateWidget(DeliveryMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deliveries != widget.deliveries) {
      _updateMarkers();
    }
  }

  void _initializeMap() {
    try {
      if (widget.userLocation != null) {
        _center = LatLng(
          widget.userLocation!.latitude,
          widget.userLocation!.longitude,
        );
      } else if (widget.deliveries.isNotEmpty) {
        final firstDelivery = widget.deliveries.first;
        if (firstDelivery.destinationLocation != null) {
          _center = LatLng(
            firstDelivery.destinationLocation!.latitude,
            firstDelivery.destinationLocation!.longitude,
          );
        } else {
          _center = const LatLng(40.7128, -74.0060);
        }
      } else {
        _center = const LatLng(40.7128, -74.0060);
      }

      _updateMarkers();
    } catch (e) {
      _center = const LatLng(40.7128, -74.0060);
      _updateMarkers();
    }
  }

  void _updateMarkers() {
    _markers.clear();

    if (widget.userLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: LatLng(
            widget.userLocation!.latitude,
            widget.userLocation!.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current position',
          ),
        ),
      );
    }

    for (int i = 0; i < widget.deliveries.length; i++) {
      final delivery = widget.deliveries[i];

      if (delivery.destinationLocation != null) {
        final markerId = MarkerId('delivery_${delivery.id}');
        final position = LatLng(
          delivery.destinationLocation!.latitude,
          delivery.destinationLocation!.longitude,
        );

        BitmapDescriptor markerIcon;
        switch (delivery.status) {
          case DeliveryStatus.newDelivery:
            markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
            break;
          case DeliveryStatus.inProgress:
            markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
            break;
          case DeliveryStatus.completed:
            markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
            break;
        }

        _markers.add(
          Marker(
            markerId: markerId,
            position: position,
            icon: markerIcon,
            infoWindow: InfoWindow(
              title: delivery.customerName,
              snippet: delivery.address,
              onTap: () {
                if (widget.onDeliverySelected != null) {
                  widget.onDeliverySelected!(delivery);
                }
              },
            ),
          ),
        );
      }

      if (delivery.startLocation != null) {
        _markers.add(
          Marker(
            markerId: MarkerId('start_${delivery.id}'),
            position: LatLng(
              delivery.startLocation!.latitude,
              delivery.startLocation!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
            infoWindow: InfoWindow(
              title: 'Warehouse',
              snippet: 'Start location for ${delivery.customerName}',
            ),
          ),
        );
      }
    }

    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _fitBounds() {
    if (_mapController == null || _markers.isEmpty) return;

    double minLat = _markers.first.position.latitude;
    double maxLat = _markers.first.position.latitude;
    double minLng = _markers.first.position.longitude;
    double maxLng = _markers.first.position.longitude;

    for (final marker in _markers) {
      minLat = minLat < marker.position.latitude ? minLat : marker.position.latitude;
      maxLat = maxLat > marker.position.latitude ? maxLat : marker.position.latitude;
      minLng = minLng < marker.position.longitude ? minLng : marker.position.longitude;
      maxLng = maxLng > marker.position.longitude ? maxLng : marker.position.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0, 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_center == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center!,
            zoom: 12.0,
          ),
          markers: _markers,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: true,
        ),
        Positioned(
          top: 16,
          right: 16,
          child: FloatingActionButton(
            mini: true,
            onPressed: _fitBounds,
            tooltip: 'Fit all markers',
            child: const Icon(Icons.fit_screen),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(
                  'New Deliveries',
                  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                ),
                _buildLegendItem(
                  'Active Deliveries',
                  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
                ),
                _buildLegendItem(
                  'Completed Deliveries',
                  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ),
                _buildLegendItem(
                  'Warehouse',
                  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
                ),
                if (widget.userLocation != null)
                  _buildLegendItem(
                    'Your Location',
                    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, BitmapDescriptor icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getColorFromIcon(icon),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorFromIcon(BitmapDescriptor icon) {
    if (icon == BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)) {
      return Colors.green;
    } else if (icon == BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)) {
      return Colors.orange;
    } else if (icon == BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)) {
      return Colors.red;
    } else if (icon == BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)) {
      return Colors.purple;
    } else if (icon == BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)) {
      return Colors.blue;
    }
    return Colors.grey;
  }
}
