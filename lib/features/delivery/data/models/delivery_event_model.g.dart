// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryEventModelAdapter extends TypeAdapter<DeliveryEventModel> {
  @override
  final int typeId = 1;

  @override
  DeliveryEventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryEventModel(
      id: fields[0] as String,
      status: fields[1] as String,
      timestamp: fields[2] as String,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryEventModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryEventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryEventModel _$DeliveryEventModelFromJson(Map<String, dynamic> json) =>
    DeliveryEventModel(
      id: json['id'] as String,
      status: json['status'] as String,
      timestamp: json['timestamp'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$DeliveryEventModelToJson(DeliveryEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
    };
