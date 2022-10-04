// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_feed.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewFeedAdapter extends TypeAdapter<NewFeed> {
  @override
  final int typeId = 0;

  @override
  NewFeed read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewFeed(
      id: fields[0] as String?,
      images: (fields[1] as List?)?.cast<PhotoModel>(),
      content: fields[2] as String?,
      tags: (fields[6] as List?)?.cast<User>(),
      hashtags: (fields[7] as List?)?.cast<String>(),
      createdAt: fields[5] as int?,
      isFavorite: fields[8] as bool,
      isFollow: fields[9] as bool?,
      numberOfFavorite: fields[10] as int,
      numberOfComment: fields[11] as int,
      user: fields[12] as User?,
      feeling: fields[3] as String?,
      parentFeeling: fields[4] as String?,
      topics: (fields[13] as List?)?.cast<TopictItem>(),
      isBear: fields[14] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, NewFeed obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.images)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.feeling)
      ..writeByte(4)
      ..write(obj.parentFeeling)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.hashtags)
      ..writeByte(8)
      ..write(obj.isFavorite)
      ..writeByte(9)
      ..write(obj.isFollow)
      ..writeByte(10)
      ..write(obj.numberOfFavorite)
      ..writeByte(11)
      ..write(obj.numberOfComment)
      ..writeByte(12)
      ..write(obj.user)
      ..writeByte(13)
      ..write(obj.topics)
      ..writeByte(14)
      ..write(obj.isBear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewFeedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
