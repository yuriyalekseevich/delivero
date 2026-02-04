import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/location_service.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';
import '../widgets/enhanced_delivery_map_widget.dart';

class DeliveryMapsPage extends StatefulWidget {
  final List<Delivery> deliveries;
  final String? title;

  const DeliveryMapsPage({
    super.key,
    required this.deliveries,
    this.title,
  });

  @override
  State<DeliveryMapsPage> createState() => _DeliveryMapsPageState();
}

class _DeliveryMapsPageState extends State<DeliveryMapsPage> {
  LocationData? _userLocation;
  bool _isLoadingLocation = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeUserLocation();
  }

  Future<void> _initializeUserLocation() async {
    try {
      setState(() {
        _isLoadingLocation = true;
        _errorMessage = null;
      });

      final locationService = getIt<LocationService>();
      final location = await locationService.getCurrentLocation();

      if (mounted) {
        setState(() {
          _userLocation = location;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to get current location: ${e.toString()}';
          _isLoadingLocation = false;
        });
      }
    }
  }

  List<Delivery> get _filteredDeliveries {
    return widget.deliveries.where((delivery) => delivery.destinationLocation != null).toList();
  }

  Map<DeliveryStatus, List<Delivery>> get _deliveriesByStatus {
    final Map<DeliveryStatus, List<Delivery>> grouped = {};

    for (final delivery in _filteredDeliveries) {
      grouped.putIfAbsent(delivery.status, () => []).add(delivery);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? S.of(context).email),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _isLoadingLocation ? null : _initializeUserLocation,
            tooltip: S.of(context).retry,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showMapInfo,
            tooltip: S.of(context).inProgress,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (_isLoadingLocation) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading your location...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_filteredDeliveries.isEmpty) {
      return _buildEmptyState();
    }

    return EnhancedDeliveryMapWidget(
      deliveries: _filteredDeliveries,
      userLocation: _userLocation,
      deliveriesByStatus: _deliveriesByStatus,
      onDeliverySelected: _onDeliverySelected,
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Location Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializeUserLocation,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Delivery Locations',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'No deliveries with location data found.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_filteredDeliveries.isEmpty) return null;

    return FloatingActionButton.extended(
      onPressed: () {
      },
      icon: const Icon(Icons.fit_screen),
      label: Text(S.of(context).deliveries),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }

  void _onDeliverySelected(Delivery delivery) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDeliveryBottomSheet(delivery),
    );
  }

  Widget _buildDeliveryBottomSheet(Delivery delivery) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            delivery.customerName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  delivery.address,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          if (delivery.notes != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.note,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    delivery.notes!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.info),
                  label: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _openInExternalMaps(delivery);
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Directions'),
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _openInExternalMaps(Delivery delivery) {
    if (delivery.destinationLocation != null) {


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening directions to ${delivery.customerName}'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  void _showMapInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).inProgress),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ${S.of(context).active}'),
            const SizedBox(height: 8),
            Text('• ${S.of(context).active}'),
            const SizedBox(height: 8),
            Text('• ${S.of(context).active}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).close),
          ),
        ],
      ),
    );
  }
}
