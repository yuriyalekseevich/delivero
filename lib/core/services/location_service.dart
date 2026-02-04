import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String country;

  const LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.country,
  });

  @override
  String toString() {
    return '$address, $city, $country';
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'city': city,
        'country': country,
      };

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
        latitude: json['latitude']?.toDouble() ?? 0.0,
        longitude: json['longitude']?.toDouble() ?? 0.0,
        address: json['address'] ?? '',
        city: json['city'] ?? '',
        country: json['country'] ?? '',
      );
}

@singleton
class LocationService {
  static const double _maxDistanceKm = 5.0; 
  static const double _earthRadiusKm = 6371.0;

  Future<bool> requestLocationPermission() async {
    try {
      debugPrint('🔍 Checking location permission...');

      final permission = await Permission.locationWhenInUse.status;
      debugPrint('📱 Initial permission status: $permission');

      if (permission.isGranted) {
        debugPrint('✅ Permission already granted');
        return true;
      }

      if (permission.isDenied) {
        debugPrint('🔄 Requesting permission...');
        final result = await Permission.locationWhenInUse.request();
        debugPrint('📱 Permission request result: $result');
        return result.isGranted;
      }

      if (permission.isPermanentlyDenied) {
        debugPrint('🚫 Permission permanently denied');
        await openAppSettings();
        return false;
      }

      if (permission.isRestricted) {
        debugPrint('🔒 Permission restricted');
        return false;
      }

      return false;
    } catch (e) {
      debugPrint('❌ Error requesting permission: $e');
      return false;
    }
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      debugPrint('🔍 Starting location permission check...');

      final hasPermission = await requestLocationPermission();

      if (!hasPermission) {
        debugPrint('❌ No location permission, using fallback');
        return _getFallbackLocation();
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint('📍 Location services enabled: $serviceEnabled');

      if (!serviceEnabled) {
        debugPrint('📴 Location services disabled, using fallback location');
        return _getFallbackLocation();
      }

      debugPrint('🎯 Getting current position...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, 
        timeLimit: const Duration(seconds: 15), 
      );
      debugPrint('📍 Position obtained: ${position.latitude}, ${position.longitude}');

      debugPrint('🏠 Getting address from coordinates...');
      String address = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      String city = 'Current Location';
      String country = 'Unknown';

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(const Duration(seconds: 5)); 

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          address = _formatAddress(placemark);
          city = placemark.locality ?? 'Current Location';
          country = placemark.country ?? 'Unknown';
          debugPrint('✅ Address resolved: $address');
        } else {
          debugPrint('⚠️ No placemarks found, using coordinates');
        }
      } catch (geocodingError) {
        debugPrint('❌ Geocoding failed (common in iOS Simulator): $geocodingError');
        debugPrint(
            '📍 Using coordinates as address: ${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}');
      }

      final locationData = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        city: city,
        country: country,
      );

      debugPrint('✅ Location data created: ${locationData.toString()}');
      return locationData;
    } catch (e) {
      debugPrint('❌ Error getting current location: $e');
      return _getFallbackLocation();
    }
  }

  LocationData _getFallbackLocation() {
    debugPrint('🔄 Using fallback location: New York, NY, USA');
    return const LocationData(
      latitude: 40.7128,
      longitude: -74.0060,
      address: 'New York, NY, USA',
      city: 'New York',
      country: 'USA',
    );
  }

  Future<LocationData> getMockLocation() async {
    return const LocationData(
      latitude: 40.7128,
      longitude: -74.0060,
      address: 'New York, NY, USA',
      city: 'New York',
      country: 'USA',
    );
  }

  Future<List<LocationData>> generateMockDeliveryLocations({
    required LocationData userLocation,
    int count = 50,
  }) async {
    final locations = <LocationData>[];
    final random = Random();

    final mockAddresses = [
      '123 Main Street',
      '456 Oak Avenue',
      '789 Pine Road',
      '321 Elm Street',
      '654 Maple Drive',
      '987 Cedar Lane',
      '147 Birch Way',
      '258 Spruce Street',
      '369 Willow Avenue',
      '741 Poplar Road',
      '852 Ash Street',
      '963 Beech Drive',
      '159 Cherry Lane',
      '357 Dogwood Way',
      '468 Fir Street',
      '579 Hickory Avenue',
      '680 Juniper Road',
      '791 Magnolia Drive',
      '802 Oak Street',
      '913 Pine Avenue',
      '024 Spruce Road',
      '135 Willow Drive',
      '246 Poplar Street',
      '357 Ash Avenue',
      '468 Beech Road',
      '579 Cherry Drive',
      '680 Dogwood Street',
      '791 Hickory Avenue',
      '802 Juniper Road',
      '913 Magnolia Drive',
      '024 Oak Street',
      '135 Pine Avenue',
      '246 Spruce Road',
      '357 Willow Drive',
      '468 Poplar Street',
      '579 Ash Avenue',
      '680 Beech Road',
      '791 Cherry Drive',
      '802 Dogwood Street',
      '913 Hickory Avenue',
      '024 Juniper Road',
      '135 Magnolia Drive',
      '246 Oak Street',
      '357 Pine Avenue',
      '468 Spruce Road',
      '579 Willow Drive',
      '680 Poplar Street',
      '791 Ash Avenue',
      '802 Beech Road',
      '913 Cherry Drive'
    ];

    for (int i = 0; i < count; i++) {
      final distanceKm = random.nextDouble() * _maxDistanceKm;
      final bearingDegrees = random.nextDouble() * 360;

      final newLocation = _calculateDestination(
        userLocation.latitude,
        userLocation.longitude,
        distanceKm,
        bearingDegrees,
      );

      final address = await _getAddressFromCoordinates(
        newLocation.latitude,
        newLocation.longitude,
      );

      locations.add(LocationData(
        latitude: newLocation.latitude,
        longitude: newLocation.longitude,
        address: address['address'] ?? mockAddresses[i % mockAddresses.length],
        city: address['city'] ?? userLocation.city,
        country: address['country'] ?? userLocation.country,
      ));
    }

    return locations;
  }

  LocationData _calculateDestination(
    double startLat,
    double startLng,
    double distanceKm,
    double bearingDegrees,
  ) {
    final bearingRad = bearingDegrees * pi / 180;
    final latRad = startLat * pi / 180;
    final lngRad = startLng * pi / 180;

    final angularDistance = distanceKm / _earthRadiusKm;

    final newLatRad = asin(
      sin(latRad) * cos(angularDistance) + cos(latRad) * sin(angularDistance) * cos(bearingRad),
    );

    final newLngRad = lngRad +
        atan2(
          sin(bearingRad) * sin(angularDistance) * cos(latRad),
          cos(angularDistance) - sin(latRad) * sin(newLatRad),
        );

    return LocationData(
      latitude: newLatRad * 180 / pi,
      longitude: newLngRad * 180 / pi,
      address: '',
      city: '',
      country: '',
    );
  }

  Future<Map<String, String>> _getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude).timeout(const Duration(seconds: 3));

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return {
          'address': _formatAddress(placemark),
          'city': placemark.locality ?? 'Unknown City',
          'country': placemark.country ?? 'Unknown Country',
        };
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    }

    return {
      'address': '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
      'city': 'Unknown City',
      'country': 'Unknown Country',
    };
  }

  String _formatAddress(Placemark placemark) {
    final parts = <String>[];

    if (placemark.street?.isNotEmpty == true) {
      parts.add(placemark.street!);
    }
    if (placemark.subLocality?.isNotEmpty == true) {
      parts.add(placemark.subLocality!);
    }
    if (placemark.locality?.isNotEmpty == true) {
      parts.add(placemark.locality!);
    }
    if (placemark.administrativeArea?.isNotEmpty == true) {
      parts.add(placemark.administrativeArea!);
    }
    if (placemark.postalCode?.isNotEmpty == true) {
      parts.add(placemark.postalCode!);
    }

    return parts.isNotEmpty ? parts.join(', ') : 'Unknown Address';
  }

  double calculateDistance(
    LocationData location1,
    LocationData location2,
  ) {
    return Geolocator.distanceBetween(
          location1.latitude,
          location1.longitude,
          location2.latitude,
          location2.longitude,
        ) /
        1000; 
  }

  bool isWithinRadius(
    LocationData center,
    LocationData location,
  ) {
    final distance = calculateDistance(center, location);
    return distance <= _maxDistanceKm;
  }

  Future<LocationData> getMockStartLocation({
    required LocationData userLocation,
  }) async {
    final random = Random();
    final distanceKm = 1.0 + random.nextDouble(); 
    final bearingDegrees = random.nextDouble() * 360;

    final startLocation = _calculateDestination(
      userLocation.latitude,
      userLocation.longitude,
      distanceKm,
      bearingDegrees,
    );

    final address = await _getAddressFromCoordinates(
      startLocation.latitude,
      startLocation.longitude,
    );

    return LocationData(
      latitude: startLocation.latitude,
      longitude: startLocation.longitude,
      address: 'Warehouse - ${address['address']}',
      city: address['city'] ?? userLocation.city,
      country: address['country'] ?? userLocation.country,
    );
  }
}
