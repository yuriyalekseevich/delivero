import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivero/features/delivery/domain/entities/delivery.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';
import 'package:delivero/features/delivery/presentation/widgets/enhanced_delivery_map_widget.dart';
import 'package:delivero/core/services/location_service.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('EnhancedDeliveryMapWidget Tests', () {
    late List<Delivery> testDeliveries;
    late LocationData testLocation;
    late Map<DeliveryStatus, List<Delivery>> deliveriesByStatus;

    setUp(() {
      testLocation = const LocationData(
        latitude: 37.7749,
        longitude: -122.4194,
        address: '123 Main St, San Francisco, CA',
        city: 'San Francisco',
        country: 'USA',
      );
      testDeliveries = [
        Delivery(
          id: 'DEL-001',
          customerName: 'John Doe',
          address: '123 Main St, San Francisco, CA',
          status: DeliveryStatus.newDelivery,
          events: const [],
          createdAt: DateTime.now(),
          destinationLocation: const LocationData(
            latitude: 37.7749,
            longitude: -122.4194,
            address: '123 Main St, San Francisco, CA',
            city: 'San Francisco',
            country: 'USA',
          ),
        ),
      ];
      deliveriesByStatus = {
        DeliveryStatus.newDelivery: [testDeliveries[0]],
        DeliveryStatus.inProgress: [],
        DeliveryStatus.completed: [],
      };
    });

    testWidgets('displays map with markers', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: TestHelpers.createScaffold(
            child: EnhancedDeliveryMapWidget(
              deliveries: testDeliveries,
              userLocation: testLocation,
              deliveriesByStatus: deliveriesByStatus,
              onDeliverySelected: (delivery) {},
            ),
          ),
        ),
      );

      // Wait for the map to load
      await tester.pumpAndSettle();

      // Verify the map widget is present
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets('handles empty deliveries list', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: TestHelpers.createScaffold(
            child: EnhancedDeliveryMapWidget(
              deliveries: const [],
              userLocation: testLocation,
              deliveriesByStatus: const {},
              onDeliverySelected: (delivery) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the map widget is present even with empty deliveries
      expect(find.byType(GoogleMap), findsOneWidget);
    });
  });
}
