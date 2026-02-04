import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:delivero/features/delivery/domain/entities/delivery.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_event.dart';
import 'package:delivero/features/delivery/domain/entities/paginated_deliveries.dart';
import 'package:delivero/core/services/location_service.dart';

@singleton
class MockDeliveryApiService {
  final LocationService _locationService;

  MockDeliveryApiService(this._locationService);

  static List<Delivery> _newDeliveries = [];
  static List<Delivery> _activeDeliveries = [];
  static List<Delivery> _completedDeliveries = [];
  static bool _initialized = false;

  Future<void> _initializeMockData() async {
    if (_initialized) return;

    try {
      LocationData userLocation;
      try {
        final location = await _locationService.getCurrentLocation().timeout(const Duration(seconds: 10));

        if (location == null) {
          debugPrint('User location unavailable, using mock location');
          userLocation = await _locationService.getMockLocation();
        } else {
          debugPrint('Using user location: ${location.address}');
          userLocation = location;
        }
      } catch (locationError) {
        debugPrint('Location service failed: $locationError');
        debugPrint('Using mock location for testing');
        userLocation = await _locationService.getMockLocation();
      }

      await _generateMockDataWithLocation(userLocation);
      _initialized = true;
    } catch (e) {
      debugPrint('Error initializing mock data: $e');
      final mockLocation = await _locationService.getMockLocation();
      await _generateMockDataWithLocation(mockLocation);
      _initialized = true;
    }
  }

  Future<void> _generateMockDataWithLocation(LocationData userLocation) async {
    final startLocation = await _locationService.getMockStartLocation(userLocation: userLocation);

    final deliveryLocations = await _locationService.generateMockDeliveryLocations(
      userLocation: userLocation,
      count: 55,
    );

    _newDeliveries = _generateDeliveriesWithLocations(
      DeliveryStatus.newDelivery,
      27,
      userLocation,
      startLocation,
      deliveryLocations.sublist(0, 27),
    );

    _activeDeliveries = _generateDeliveriesWithLocations(
      DeliveryStatus.inProgress,
      5,
      userLocation,
      startLocation,
      deliveryLocations.sublist(27, 32),
    );

    _completedDeliveries = _generateDeliveriesWithLocations(
      DeliveryStatus.completed,
      23,
      userLocation,
      startLocation,
      deliveryLocations.sublist(32, 55),
    );
  }

  List<Delivery> _generateDeliveriesWithLocations(
    DeliveryStatus status,
    int count,
    LocationData userLocation,
    LocationData startLocation,
    List<LocationData> deliveryLocations,
  ) {
    final deliveries = <Delivery>[];
    final now = DateTime.now();

    final customerNames = [
      'Alice Smith',
      'John Doe',
      'Jane Wilson',
      'Bob Johnson',
      'Sarah Brown',
      'Charlie Davis',
      'Diana Prince',
      'Eve Adams',
      'Frank Miller',
      'Grace Lee',
      'Henry Wilson',
      'Ivy Chen',
      'Jack Wilson',
      'Kate Brown',
      'Liam O\'Connor',
      'Maya Patel',
      'Noah Garcia',
      'Olivia Martinez',
      'Paul Thompson',
      'Quinn Anderson',
      'Rachel White',
      'Samuel Taylor',
      'Tina Rodriguez',
      'Uma Patel',
      'Victor Kim',
      'Wendy Johnson',
      'Xavier Lee',
      'Yara Ahmed',
      'Zoe Thompson',
      'Adam Wilson'
    ];

    final specialInfoOptions = [
      'Near you',
      'Best salary',
      'Double pay',
      'High priority',
      'Express bonus',
      'Premium rate',
      'Urgent delivery',
      'Bonus available',
      'Top priority',
      'Special rate'
    ];

    for (int i = 0; i < count; i++) {
      final customerName = customerNames[i % customerNames.length];
      final destinationLocation = deliveryLocations[i];
      final createdAt = now.subtract(Duration(days: i % 30, hours: i % 24));

      final events = _generateEventsForStatus(status, createdAt, i, startLocation, destinationLocation);

      deliveries.add(Delivery(
        id: '${status.name.toLowerCase()}_${i + 1}',
        customerName: customerName,
        address: destinationLocation.address,
        notes: i % 3 == 0 ? 'Special instructions: Ring doorbell twice' : null,
        status: status,
        events: events,
        createdAt: createdAt,
        specialInfo:
            status == DeliveryStatus.newDelivery && i < specialInfoOptions.length ? specialInfoOptions[i] : null,
        updatedAt: status == DeliveryStatus.completed ? createdAt.add(const Duration(hours: 2)) : null,
        lastSyncedAt: now.subtract(Duration(minutes: i % 60)),
        destinationLocation: destinationLocation,
        startLocation: startLocation,
      ));
    }

    return deliveries;
  }

  Future<PaginatedDeliveries> getNewDeliveries({
    int page = 1,
    int limit = 10,
    String? searchQuery,
  }) async {
    await _initializeMockData();

    await Future.delayed(const Duration(milliseconds: 500));

    return _paginateDeliveries(_newDeliveries, page, limit, searchQuery);
  }

  Future<PaginatedDeliveries> getActiveDeliveries({
    int page = 1,
    int limit = 10,
    String? searchQuery,
  }) async {
    await _initializeMockData();

    await Future.delayed(const Duration(milliseconds: 500));

    return _paginateDeliveries(_activeDeliveries, page, limit, searchQuery);
  }

  Future<PaginatedDeliveries> getCompletedDeliveries({
    int page = 1,
    int limit = 10,
    String? searchQuery,
  }) async {
    await _initializeMockData();

    await Future.delayed(const Duration(milliseconds: 500));

    return _paginateDeliveries(_completedDeliveries, page, limit, searchQuery);
  }

  Future<List<Delivery>> getAllDeliveries() async {
    await _initializeMockData();

    await Future.delayed(const Duration(milliseconds: 800));

    return [
      ..._newDeliveries,
      ..._activeDeliveries,
      ..._completedDeliveries,
    ];
  }

  Future<Delivery> startDelivery(String deliveryId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allDeliveries = [..._newDeliveries, ..._activeDeliveries, ..._completedDeliveries];
    final deliveryIndex = allDeliveries.indexWhere((d) => d.id == deliveryId);

    if (deliveryIndex != -1) {
      final delivery = allDeliveries[deliveryIndex];
      final now = DateTime.now();

      final startEvent = DeliveryEvent(
        id: '${deliveryId}_started',
        status: DeliveryStatus.inProgress,
        timestamp: now,
        latitude: 40.7128,
        longitude: -74.0060,
        notes: 'Delivery started - driver en route',
      );

      final updatedEvents = [...delivery.events, startEvent];

      final updatedDelivery = delivery.copyWith(
        status: DeliveryStatus.inProgress,
        updatedAt: now,
        events: updatedEvents,
      );

      if (delivery.status == DeliveryStatus.newDelivery) {
        _newDeliveries.removeWhere((d) => d.id == deliveryId);
        _activeDeliveries.add(updatedDelivery);
      }

      return updatedDelivery;
    }

    throw Exception('Delivery not found');
  }

  Future<Delivery> completeDelivery(String deliveryId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allDeliveries = [..._newDeliveries, ..._activeDeliveries, ..._completedDeliveries];
    final deliveryIndex = allDeliveries.indexWhere((d) => d.id == deliveryId);

    if (deliveryIndex != -1) {
      final delivery = allDeliveries[deliveryIndex];
      final now = DateTime.now();

      final completionEvent = DeliveryEvent(
        id: '${deliveryId}_completed',
        status: DeliveryStatus.completed,
        timestamp: now,
        latitude: 40.7128 + 0.01,
        longitude: -74.0060 + 0.01,
        notes: 'Delivery completed successfully',
      );

      final updatedEvents = [...delivery.events, completionEvent];

      final updatedDelivery = delivery.copyWith(
        status: DeliveryStatus.completed,
        updatedAt: now,
        events: updatedEvents,
      );

      if (delivery.status == DeliveryStatus.inProgress) {
        _activeDeliveries.removeWhere((d) => d.id == deliveryId);
        _completedDeliveries.add(updatedDelivery);
      }

      return updatedDelivery;
    }

    throw Exception('Delivery not found');
  }

  List<DeliveryEvent> _generateEventsForStatus(
    DeliveryStatus status,
    DateTime createdAt,
    int index,
    LocationData startLocation,
    LocationData destinationLocation,
  ) {
    final events = <DeliveryEvent>[];

    events.add(DeliveryEvent(
      id: '${status.name.toLowerCase()}_${index + 1}_created',
      status: DeliveryStatus.newDelivery,
      timestamp: createdAt,
      latitude: startLocation.latitude,
      longitude: startLocation.longitude,
      notes: 'Delivery created and assigned at warehouse',
    ));

    switch (status) {
      case DeliveryStatus.newDelivery:
        break;

      case DeliveryStatus.inProgress:
        final startTime = createdAt.add(Duration(minutes: 30 + (index * 5)));
        events.add(DeliveryEvent(
          id: '${status.name.toLowerCase()}_${index + 1}_started',
          status: DeliveryStatus.inProgress,
          timestamp: startTime,
          latitude: startLocation.latitude,
          longitude: startLocation.longitude,
          notes: 'Delivery started - driver en route from warehouse',
        ));
        break;

      case DeliveryStatus.completed:
        final startTime = createdAt.add(Duration(minutes: 30 + (index * 5)));
        final completionTime = startTime.add(Duration(hours: 1, minutes: 15 + (index * 10)));

        events.add(DeliveryEvent(
          id: '${status.name.toLowerCase()}_${index + 1}_started',
          status: DeliveryStatus.inProgress,
          timestamp: startTime,
          latitude: startLocation.latitude,
          longitude: startLocation.longitude,
          notes: 'Delivery started - driver en route from warehouse',
        ));

        events.add(DeliveryEvent(
          id: '${status.name.toLowerCase()}_${index + 1}_completed',
          status: DeliveryStatus.completed,
          timestamp: completionTime,
          latitude: destinationLocation.latitude,
          longitude: destinationLocation.longitude,
          notes: 'Delivery completed successfully at destination',
        ));
        break;
    }

    return events;
  }

  PaginatedDeliveries _paginateDeliveries(
    List<Delivery> deliveries,
    int page,
    int limit,
    String? searchQuery,
  ) {
    List<Delivery> filteredDeliveries = deliveries;
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filteredDeliveries = deliveries.where((delivery) {
        return delivery.customerName.toLowerCase().contains(query) || delivery.address.toLowerCase().contains(query);
      }).toList();
    }

    final totalItems = filteredDeliveries.length;
    final totalPages = (totalItems / limit).ceil();
    final startIndex = (page - 1) * limit;
    final endIndex = (startIndex + limit).clamp(0, totalItems);

    final pageItems = filteredDeliveries.sublist(
      startIndex,
      endIndex,
    );

    return PaginatedDeliveries(
      deliveries: pageItems,
      currentPage: page,
      totalPages: totalPages,
      totalItems: totalItems,
      hasNextPage: page < totalPages,
      hasPreviousPage: page > 1,
    );
  }
}
