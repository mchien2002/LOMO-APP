// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TopictItemAdapter extends TypeAdapter<TopictItem> {
  @override
  final int typeId = 5;

  @override
  TopictItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopictItem(
      id: fields[0] as String?,
      name: fields[1] as String?,
      image: fields[2] as String?,
      numberOfPost: fields[3] as int?,
      description: fields[4] as String?,
      imageLocal: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TopictItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.numberOfPost)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.imageLocal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopictItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
