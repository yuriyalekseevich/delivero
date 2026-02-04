import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:delivero/features/delivery/domain/entities/delivery.dart';
import 'package:delivero/features/delivery/domain/entities/delivery_status.dart';

enum DeliveryEventType {
  statusChanged,
  deliveryUpdated,
  deliveryRemoved,
}

class DeliveryEventData {
  final String deliveryId;
  final DeliveryStatus? oldStatus;
  final DeliveryStatus newStatus;
  final Delivery? delivery;
  final DeliveryEventType eventType;

  const DeliveryEventData({
    required this.deliveryId,
    this.oldStatus,
    required this.newStatus,
    this.delivery,
    required this.eventType,
  });
}

@singleton
class DeliveryEventBus {
  final StreamController<DeliveryEventData> _eventController = StreamController<DeliveryEventData>.broadcast();

  Stream<DeliveryEventData> get events => _eventController.stream;

  void emitStatusChange({
    required String deliveryId,
    DeliveryStatus? oldStatus,
    required DeliveryStatus newStatus,
    Delivery? delivery,
  }) {
    _eventController.add(DeliveryEventData(
      deliveryId: deliveryId,
      oldStatus: oldStatus,
      newStatus: newStatus,
      delivery: delivery,
      eventType: DeliveryEventType.statusChanged,
    ));
  }

  void emitDeliveryUpdate({
    required String deliveryId,
    required Delivery delivery,
  }) {
    _eventController.add(DeliveryEventData(
      deliveryId: deliveryId,
      newStatus: delivery.status,
      delivery: delivery,
      eventType: DeliveryEventType.deliveryUpdated,
    ));
  }

  void emitDeliveryRemoval({
    required String deliveryId,
    required DeliveryStatus oldStatus,
  }) {
    _eventController.add(DeliveryEventData(
      deliveryId: deliveryId,
      oldStatus: oldStatus,
      newStatus: oldStatus, 
      eventType: DeliveryEventType.deliveryRemoved,
    ));
  }

  void dispose() {
    _eventController.close();
  }
}
