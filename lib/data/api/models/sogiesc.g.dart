// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sogiesc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SogiescAdapter extends TypeAdapter<Sogiesc> {
  @override
  final int typeId = 1;

  @override
  Sogiesc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sogiesc(
      id: fields[0] as String?,
      name: fields[1] as String?,
      priority: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Sogiesc obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SogiescAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
