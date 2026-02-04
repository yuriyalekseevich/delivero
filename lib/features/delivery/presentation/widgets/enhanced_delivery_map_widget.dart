import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';

class EnhancedDeliveryMapWidget extends StatefulWidget {
  final List<Delivery> deliveries;

  final LocationData? userLocation;

  final Map<DeliveryStatus, List<Delivery>> deliveriesByStatus;

  final Function(Delivery)? onDeliverySelected;

  const EnhancedDeliveryMapWidget({
    super.key,
    required this.deliveries,
    this.userLocation,
    required this.deliveriesByStatus,
    this.onDeliverySelected,
  });

  @override
  State<EnhancedDeliveryMapWidget> createState() => _EnhancedDeliveryMapWidgetState();
}

class _EnhancedDeliveryMapWidgetState extends State<EnhancedDeliveryMapWidget> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  LatLng? _center;
  final bool _showUserLocation = true;
  MapType _mapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void didUpdateWidget(EnhancedDeliveryMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deliveries != widget.deliveries || oldWidget.userLocation != widget.userLocation) {
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

    if (_showUserLocation && widget.userLocation != null) {
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

    for (final delivery in widget.deliveries) {
      if (delivery.destinationLocation != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(delivery.id),
            position: LatLng(
              delivery.destinationLocation!.latitude,
              delivery.destinationLocation!.longitude,
            ),
            icon: _getMarkerIconForStatus(delivery.status),
            infoWindow: InfoWindow(
              title: delivery.customerName,
              snippet: delivery.address,
            ),
            onTap: () => widget.onDeliverySelected?.call(delivery),
          ),
        );
      }
    }
  }

  BitmapDescriptor _getMarkerIconForStatus(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.newDelivery:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case DeliveryStatus.inProgress:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case DeliveryStatus.completed:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }

  Future<void> _fitBounds() async {
    if (_mapController == null || _markers.isEmpty) return;

    try {
      final bounds = _calculateBounds();
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    } catch (e) {
      debugPrint('Error fitting bounds: $e');
    }
  }

  LatLngBounds _calculateBounds() {
    final latitudes = _markers.map((m) => m.position.latitude).toList();
    final longitudes = _markers.map((m) => m.position.longitude).toList();

    final double minLat = latitudes.reduce((a, b) => a < b ? a : b);
    final double maxLat = latitudes.reduce((a, b) => a > b ? a : b);
    final double minLng = longitudes.reduce((a, b) => a < b ? a : b);
    final double maxLng = longitudes.reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  Future<void> _centerOnUserLocation() async {
    if (_mapController == null || widget.userLocation == null) return;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            widget.userLocation!.latitude,
            widget.userLocation!.longitude,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error centering on user location: $e');
    }
  }

  void _toggleMapType() {
    setState(() {
      switch (_mapType) {
        case MapType.normal:
          _mapType = MapType.satellite;
          break;
        case MapType.satellite:
          _mapType = MapType.hybrid;
          break;
        case MapType.hybrid:
          _mapType = MapType.terrain;
          break;
        case MapType.terrain:
          _mapType = MapType.normal;
          break;
        case MapType.none:
          _mapType = MapType.normal;
          break;
      }
    });
  }

  void _showStatusFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildStatusFilterSheet(),
    );
  }

  Widget _buildStatusFilterSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Status',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...DeliveryStatus.values.map((status) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getStatusColor(status),
                  child: Icon(
                    _getStatusIcon(status),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                title: Text(status.displayName),
                subtitle: Text('${widget.deliveriesByStatus[status]?.length ?? 0} deliveries'),
                onTap: () {
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }

  Color _getStatusColor(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.newDelivery:
        return Colors.green;
      case DeliveryStatus.inProgress:
        return Colors.orange;
      case DeliveryStatus.completed:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.newDelivery:
        return Icons.add_circle;
      case DeliveryStatus.inProgress:
        return Icons.local_shipping;
      case DeliveryStatus.completed:
        return Icons.check_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_center == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading map...'),
          ],
        ),
      );
    }

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: _center!,
            zoom: 12.0,
          ),
          markers: _markers,
          mapType: _mapType,
          myLocationEnabled: _showUserLocation,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: true,
          onTap: (LatLng position) {
          },
        ),

        _buildMapControls(),

        _buildStatusLegend(),
      ],
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      top: 16,
      right: 16,
      child: Column(
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: 'fit_bounds_button',
            onPressed: _fitBounds,
            tooltip: 'Fit all markers',
            child: const Icon(Icons.fit_screen),
          ),
          const SizedBox(height: 8),

          FloatingActionButton(
            mini: true,
            heroTag: 'user_location_button',
            onPressed: _centerOnUserLocation,
            tooltip: 'Center on user location',
            child: Icon(_showUserLocation ? Icons.my_location : Icons.location_off),
          ),
          const SizedBox(height: 8),

          FloatingActionButton(
            mini: true,
            heroTag: 'map_type_button',
            onPressed: _toggleMapType,
            tooltip: 'Change map type',
            child: const Icon(Icons.layers),
          ),
          const SizedBox(height: 8),

          FloatingActionButton(
            mini: true,
            heroTag: 'filter_button',
            onPressed: _showStatusFilter,
            tooltip: 'Filter by status',
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusLegend() {
    return Positioned(
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
            Text(
              'Status Legend',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...DeliveryStatus.values.map((status) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        status.displayName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
