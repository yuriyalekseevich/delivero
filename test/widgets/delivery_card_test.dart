import 'package:flutter_test/flutter_test.dart';
import 'package:delivero/features/delivery/domain/entities/delivery.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';
import 'package:delivero/features/delivery/presentation/widgets/delivery_card.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('DeliveryCard Widget Tests', () {
    late Delivery testDelivery;

    setUp(() {
      testDelivery = Delivery(
        id: 'DEL-001',
        customerName: 'John Doe',
        address: '123 Main St, New York, NY',
        status: DeliveryStatus.newDelivery,
        events: const [],
        createdAt: DateTime.now(),
      );
    });

    testWidgets('displays delivery information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: TestHelpers.createScaffold(
            child: DeliveryCard(
              delivery: testDelivery,
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify customer name is displayed
      expect(find.text('John Doe'), findsOneWidget);

      // Verify address is displayed
      expect(find.text('123 Main St, New York, NY'), findsOneWidget);
    });

    testWidgets('card is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: TestHelpers.createScaffold(
            child: DeliveryCard(
              delivery: testDelivery,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the card
      await tester.tap(find.byType(DeliveryCard));
      await tester.pump();

      // Just verify the card can be tapped without error
      expect(find.byType(DeliveryCard), findsOneWidget);
    });
  });
}
