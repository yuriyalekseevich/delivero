import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/delivery.dart';
import '../../domain/entities/delivery_status.dart';
import '../../../../core/services/location_service.dart';
import 'delivery_event_model.dart';

part 'delivery_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class DeliveryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String customerName;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final String? notes;

  @HiveField(4)
  final String? specialInfo;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final List<DeliveryEventModel> events;

  @HiveField(7)
  final String createdAt;

  @HiveField(8)
  final String? updatedAt;

  @HiveField(9)
  final String? lastSyncedAt;

  @HiveField(10)
  final Map<String, dynamic>? destinationLocation;

  @HiveField(11)
  final Map<String, dynamic>? startLocation;

  DeliveryModel({
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

  factory DeliveryModel.fromJson(Map<String, dynamic> json) => _$DeliveryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryModelToJson(this);

  factory DeliveryModel.fromEntity(Delivery delivery) {
    return DeliveryModel(
      id: delivery.id,
      customerName: delivery.customerName,
      address: delivery.address,
      notes: delivery.notes,
      specialInfo: delivery.specialInfo,
      status: delivery.status.name,
      events: delivery.events.map((e) => DeliveryEventModel.fromEntity(e)).toList(),
      createdAt: delivery.createdAt.toIso8601String(),
      updatedAt: delivery.updatedAt?.toIso8601String(),
      lastSyncedAt: delivery.lastSyncedAt?.toIso8601String(),
      destinationLocation: delivery.destinationLocation?.toJson(),
      startLocation: delivery.startLocation?.toJson(),
    );
  }

  Delivery toEntity() {
    return Delivery(
      id: id,
      customerName: customerName,
      address: address,
      notes: notes,
      specialInfo: specialInfo,
      status: DeliveryStatus.values.firstWhere((s) => s.name == status),
      events: events.map((e) => e.toEntity()).toList(),
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
      lastSyncedAt: lastSyncedAt != null ? DateTime.parse(lastSyncedAt!) : null,
      destinationLocation: destinationLocation != null ? LocationData.fromJson(destinationLocation!) : null,
      startLocation: startLocation != null ? LocationData.fromJson(startLocation!) : null,
    );
  }
}
