import 'package:equatable/equatable.dart';
import 'delivery_event.dart';
import 'delivery_status.dart';
import '../../../../core/services/location_service.dart';

class Delivery extends Equatable {
  final String id;
  final String customerName;
  final String address;
  final String? notes;
  final String? specialInfo;
  final DeliveryStatus status;
  final List<DeliveryEvent> events;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? lastSyncedAt;
  final LocationData? destinationLocation;
  final LocationData? startLocation;

  const Delivery({
    required this.id,
    required this.customerName,
    required this.address,
    this.notes,
    this.specialInfo,
    required this.status,
    required this.events,
    required this.createdAt,
    this.updatedAt,
    this.lastSyncedAt,
    this.destinationLocation,
    this.startLocation,
  });

  Delivery copyWith({
    String? id,
    String? customerName,
    String? address,
    String? notes,
    String? specialInfo,
    DeliveryStatus? status,
    List<DeliveryEvent>? events,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    LocationData? destinationLocation,
    LocationData? startLocation,
  }) {
    return Delivery(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      specialInfo: specialInfo ?? this.specialInfo,
      status: status ?? this.status,
      events: events ?? this.events,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      startLocation: startLocation ?? this.startLocation,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerName,
        address,
        notes,
        specialInfo,
        status,
        events,
        createdAt,
        updatedAt,
        lastSyncedAt,
        destinationLocation,
        startLocation,
      ];
}
