import 'package:equatable/equatable.dart';
import 'delivery_status.dart';

class DeliveryEvent extends Equatable {
  final String id;
  final DeliveryStatus status;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String? notes;

  const DeliveryEvent({
    required this.id,
    required this.status,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        timestamp,
        latitude,
        longitude,
        notes,
      ];
}
