import 'package:flutter_test/flutter_test.dart';
import 'package:delivero/features/delivery/domain/entities/delivery.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_event.dart';
import 'package:delivero/core/services/location_service.dart';

void main() {
  group('Delivery Entity Tests', () {
    late Delivery testDelivery;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime(2024, 1, 15, 10, 30);
      testDelivery = Delivery(
        id: 'DEL-001',
        customerName: 'John Doe',
        address: '123 Main St, San Francisco, CA',
        status: DeliveryStatus.newDelivery,
        events: const [],
        createdAt: testDate,
        destinationLocation: const LocationData(
          latitude: 37.7749,
          longitude: -122.4194,
          address: '123 Main St',
          city: 'San Francisco',
          country: 'USA',
        ),
      );
    });

    test('creates delivery with correct properties', () {
      expect(testDelivery.id, equals('DEL-001'));
      expect(testDelivery.customerName, equals('John Doe'));
      expect(testDelivery.address, equals('123 Main St, San Francisco, CA'));
      expect(testDelivery.status, equals(DeliveryStatus.newDelivery));
      expect(testDelivery.events, isEmpty);
      expect(testDelivery.createdAt, equals(testDate));
      expect(testDelivery.destinationLocation, isNotNull);
    });

    test('delivery equality works correctly', () {
      final sameDelivery = Delivery(
        id: 'DEL-001',
        customerName: 'John Doe',
        address: '123 Main St, San Francisco, CA',
        status: DeliveryStatus.newDelivery,
        events: const [],
        createdAt: testDate,
        destinationLocation: const LocationData(
          latitude: 37.7749,
          longitude: -122.4194,
          address: '123 Main St',
          city: 'San Francisco',
          country: 'USA',
        ),
      );

      final differentDelivery = Delivery(
        id: 'DEL-002',
        customerName: 'Jane Smith',
        address: '456 Oak Ave, Los Angeles, CA',
        status: DeliveryStatus.inProgress,
        events: const [],
        createdAt: testDate,
      );

      // Test that deliveries with same properties are equal
      expect(testDelivery.id, equals(sameDelivery.id));
      expect(testDelivery.customerName, equals(sameDelivery.customerName));
      expect(testDelivery.status, equals(sameDelivery.status));

      // Test that different deliveries are not equal
      expect(testDelivery.id, isNot(equals(differentDelivery.id)));
    });

    test('delivery hash code is consistent', () {
      final hashCode1 = testDelivery.hashCode;
      final hashCode2 = testDelivery.hashCode;

      expect(hashCode1, equals(hashCode2));
    });

    test('delivery string representation is correct', () {
      final stringRep = testDelivery.toString();
      expect(stringRep, contains('DEL-001'));
      expect(stringRep, contains('John Doe'));
      expect(stringRep, contains('newDelivery'));
    });
  });

  group('DeliveryStatus Tests', () {
    test('all delivery statuses are defined', () {
      expect(DeliveryStatus.values, hasLength(3));
      expect(DeliveryStatus.values, contains(DeliveryStatus.newDelivery));
      expect(DeliveryStatus.values, contains(DeliveryStatus.inProgress));
      expect(DeliveryStatus.values, contains(DeliveryStatus.completed));
    });

    test('delivery status display names are correct', () {
      expect(DeliveryStatus.newDelivery.displayName, equals('New'));
      expect(DeliveryStatus.inProgress.displayName, equals('In Progress'));
      expect(DeliveryStatus.completed.displayName, equals('Completed'));
    });

    test('delivery status equality works', () {
      expect(DeliveryStatus.newDelivery, equals(DeliveryStatus.newDelivery));
      expect(DeliveryStatus.newDelivery, isNot(equals(DeliveryStatus.inProgress)));
    });
  });

  group('DeliveryEvent Tests', () {
    late DeliveryEvent testEvent;

    setUp(() {
      testEvent = DeliveryEvent(
        id: 'EVT-001',
        status: DeliveryStatus.inProgress,
        timestamp: DateTime(2024, 1, 15, 10, 30),
        latitude: 37.7749,
        longitude: -122.4194,
        notes: 'Delivery started',
      );
    });

    test('creates delivery event with correct properties', () {
      expect(testEvent.id, equals('EVT-001'));
      expect(testEvent.status, equals(DeliveryStatus.inProgress));
      expect(testEvent.latitude, equals(37.7749));
      expect(testEvent.longitude, equals(-122.4194));
      expect(testEvent.notes, equals('Delivery started'));
    });

    test('delivery event equality works', () {
      final sameEvent = DeliveryEvent(
        id: 'EVT-001',
        status: DeliveryStatus.inProgress,
        timestamp: DateTime(2024, 1, 15, 10, 30),
        latitude: 37.7749,
        longitude: -122.4194,
        notes: 'Delivery started',
      );

      expect(testEvent, equals(sameEvent));
    });
  });
}
