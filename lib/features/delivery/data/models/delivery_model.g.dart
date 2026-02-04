// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryModelAdapter extends TypeAdapter<DeliveryModel> {
  @override
  final int typeId = 0;

  @override
  DeliveryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryModel(
      id: fields[0] as String,
      customerName: fields[1] as String,
      address: fields[2] as String,
      notes: fields[3] as String?,
      specialInfo: fields[4] as String?,
      status: fields[5] as String,
      events: (fields[6] as List).cast<DeliveryEventModel>(),
      createdAt: fields[7] as String,
      updatedAt: fields[8] as String?,
      lastSyncedAt: fields[9] as String?,
      destinationLocation: (fields[10] as Map?)?.cast<String, dynamic>(),
      startLocation: (fields[11] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.specialInfo)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.events)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.lastSyncedAt)
      ..writeByte(10)
      ..write(obj.destinationLocation)
      ..writeByte(11)
      ..write(obj.startLocation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryModel _$DeliveryModelFromJson(Map<String, dynamic> json) =>
    DeliveryModel(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      address: json['address'] as String,
      notes: json['notes'] as String?,
      specialInfo: json['specialInfo'] as String?,
      status: json['status'] as String,
      events: (json['events'] as List<dynamic>)
          .map((e) => DeliveryEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      lastSyncedAt: json['lastSyncedAt'] as String?,
      destinationLocation: json['destinationLocation'] as Map<String, dynamic>?,
      startLocation: json['startLocation'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DeliveryModelToJson(DeliveryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerName': instance.customerName,
      'address': instance.address,
      'notes': instance.notes,
      'specialInfo': instance.specialInfo,
      'status': instance.status,
      'events': instance.events,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'lastSyncedAt': instance.lastSyncedAt,
      'destinationLocation': instance.destinationLocation,
      'startLocation': instance.startLocation,
    };
