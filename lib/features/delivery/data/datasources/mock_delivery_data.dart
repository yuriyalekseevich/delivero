import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';
import '../../domain/entities/delivery_event.dart';

class MockDeliveryData {
  static List<Delivery> getMockDeliveries() {
    final now = DateTime.now();
    final deliveries = <Delivery>[];

    for (int i = 1; i <= 120; i++) {
      final status = _getRandomStatus();
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
        'Olivia Taylor',
        'Paul Anderson',
        'Quinn Martinez',
        'Rachel Green',
        'Sam Wilson',
        'Tina Chen',
        'Uma Patel',
        'Victor Garcia',
        'Wendy Lee',
        'Xavier Brown',
        'Yara Smith',
        'Zoe Johnson',
        'Adam Wilson'
      ];

      final addresses = [
        '221B Baker Street, London',
        '123 Main Street, New York',
        '456 Oak Avenue, Paris',
        '789 Pine Road, Berlin',
        '321 Elm Street, Tokyo',
        '654 Maple Drive, Sydney',
        '987 Cedar Lane, Toronto',
        '147 Birch Street, Vancouver',
        '258 Spruce Avenue, Montreal',
        '369 Willow Way, Calgary',
        '741 Poplar Place, Ottawa',
        '852 Ash Street, Edmonton',
        '963 Hickory Road, Winnipeg',
        '159 Cherry Lane, Quebec City',
        '357 Walnut Street, Hamilton',
        '468 Chestnut Avenue, London',
        '579 Sycamore Drive, Kitchener',
        '680 Dogwood Way, Windsor',
        '791 Magnolia Street, Halifax',
        '802 Redwood Road, Victoria'
      ];

      final notes = [
        'Ring the doorbell twice',
        'Leave at front door if no answer',
        'Call before delivery',
        'Gate code: 1234',
        'Use side entrance',
        'Deliver to back door',
        'Call customer upon arrival',
        'Leave with neighbor if not home',
        'Fragile - handle with care',
        'Requires signature',
        'No signature required',
        'Leave in mailbox',
        'Deliver to office',
        'Call customer 30 min before',
        'Special instructions provided',
        'High priority delivery',
        'Standard delivery',
        'Express delivery',
        'Same day delivery',
        'Next day delivery'
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

      final customerName = customerNames[i % customerNames.length];
      final address = addresses[i % addresses.length];
      final note = notes[i % notes.length];

      final events = <DeliveryEvent>[];

      events.add(DeliveryEvent(
        id: 'event-$i-1',
        status: DeliveryStatus.newDelivery,
        timestamp: now.subtract(Duration(hours: i)),
        latitude: 40.7128 + (i * 0.01),
        longitude: -74.0060 + (i * 0.01),
      ));

      if (status == DeliveryStatus.inProgress || status == DeliveryStatus.completed) {
        events.add(DeliveryEvent(
          id: 'event-$i-2',
          status: DeliveryStatus.inProgress,
          timestamp: now.subtract(Duration(minutes: i * 10)),
          latitude: 40.7128 + (i * 0.01),
          longitude: -74.0060 + (i * 0.01),
        ));
      }

      if (status == DeliveryStatus.completed) {
        events.add(DeliveryEvent(
          id: 'event-$i-3',
          status: DeliveryStatus.completed,
          timestamp: now.subtract(Duration(minutes: i * 5)),
          latitude: 40.7128 + (i * 0.01),
          longitude: -74.0060 + (i * 0.01),
        ));
      }

      deliveries.add(Delivery(
        id: 'DEL-${i.toString().padLeft(4, '0')}',
        customerName: customerName,
        address: address,
        notes: note,
        specialInfo: status == DeliveryStatus.newDelivery ? specialInfoOptions[1] : null,
        status: status,
        events: events,
        createdAt: now.subtract(Duration(hours: i)),
        updatedAt: status == DeliveryStatus.completed
            ? now.subtract(Duration(minutes: i * 5))
            : now.subtract(Duration(hours: i)),
      ));
    }

    return deliveries;
  }

  static DeliveryStatus _getRandomStatus() {
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    switch (random) {
      case 0:
        return DeliveryStatus.newDelivery;
      case 1:
        return DeliveryStatus.inProgress;
      case 2:
        return DeliveryStatus.completed;
      default:
        return DeliveryStatus.newDelivery;
    }
  }
}
