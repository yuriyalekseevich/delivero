import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/delivery_event.dart';
import '../../domain/entities/delivery_status.dart';

part 'delivery_event_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class DeliveryEventModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String status;

  @HiveField(2)
  final String timestamp;

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final String? notes;

  DeliveryEventModel({
    required this.id,
    required this.status,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.notes,
  });

  factory DeliveryEventModel.fromJson(Map<String, dynamic> json) => _$DeliveryEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryEventModelToJson(this);

  factory DeliveryEventModel.fromEntity(DeliveryEvent event) {
    return DeliveryEventModel(
      id: event.id,
      status: event.status.name,
      timestamp: event.timestamp.toIso8601String(),
      latitude: event.latitude,
      longitude: event.longitude,
      notes: event.notes,
    );
  }

  DeliveryEvent toEntity() {
    return DeliveryEvent(
      id: id,
      status: DeliveryStatus.values.firstWhere((s) => s.name == status),
      timestamp: DateTime.parse(timestamp),
      latitude: latitude,
      longitude: longitude,
      notes: notes,
    );
  }
}
