import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:delivero/features/delivery/domain/entities/delivery.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';

void main() {
  group('Basic Tests', () {
    test('Delivery entity creation works', () {
      final delivery = Delivery(
        id: 'DEL-001',
        customerName: 'John Doe',
        address: '123 Main St',
        status: DeliveryStatus.newDelivery,
        events: const [],
        createdAt: DateTime.now(),
      );

      expect(delivery.id, equals('DEL-001'));
      expect(delivery.customerName, equals('John Doe'));
      expect(delivery.status, equals(DeliveryStatus.newDelivery));
    });

    test('DeliveryStatus enum values work', () {
      expect(DeliveryStatus.newDelivery.displayName, equals('New'));
      expect(DeliveryStatus.inProgress.displayName, equals('In Progress'));
      expect(DeliveryStatus.completed.displayName, equals('Completed'));
    });

    testWidgets('Basic widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Hello World'),
            ),
          ),
        ),
      );

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('Button interaction test', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => tapped = true,
                child: const Text('Tap Me'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    test('DateTime formatting works', () {
      final date = DateTime(2024, 1, 15, 10, 30);
      expect(date.year, equals(2024));
      expect(date.month, equals(1));
      expect(date.day, equals(15));
    });
  });
}
