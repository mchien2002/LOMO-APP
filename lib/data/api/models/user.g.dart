// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 3;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      isFirstLogin: fields[0] as bool?,
      token: fields[1] as String?,
      name: fields[4] as String?,
      id: fields[5] as String?,
      email: fields[6] as String?,
      phone: fields[7] as String?,
      netAloId: fields[8] as int?,
      netAloAvatar: fields[10] as String?,
      netAloToken: fields[9] as String?,
      avatar: fields[11] as String?,
      cover: fields[12] as String?,
      isFollow: fields[13] as bool,
      isFavorite: fields[14] as bool,
      gender: fields[15] as Gender?,
      followGenders: (fields[16] as List?)?.cast<Gender>(),
      birthday: fields[17] as DateTime?,
      height: fields[18] as int?,
      weight: fields[19] as int?,
      story: fields[20] as String?,
      province: fields[21] as City?,
      numberOfBlocker: fields[25] as int?,
      numberOfFollower: fields[26] as int?,
      numberOfFavoritor: fields[27] as int?,
      numberOfCandy: fields[28] as int?,
      numberOfBear: fields[29] as int?,
      numberOfFollowing: fields[30] as int?,
      distance: fields[2] as dynamic,
      feeling: fields[3] as String?,
      city: fields[22] as String?,
      zodiac: fields[31] as Zodiac?,
      sogiescs: (fields[32] as List?)?.cast<Sogiesc>(),
      relationship: fields[33] as Relationship?,
      careers: (fields[34] as List?)?.cast<KeyValue>(),
      hobbies: (fields[37] as List?)?.cast<Hobby>(),
      literacy: fields[35] as Literacy?,
      backgroundImage: fields[36] as String?,
      lomoId: fields[38] as String?,
      isKol: fields[40] as bool?,
      fieldDisabled: (fields[39] as List?)?.cast<String>(),
      datingImages: (fields[41] as List?)?.cast<DatingImage>(),
      quote: fields[42] as String?,
      filter: fields[43] as DatingFilter?,
      role: fields[44] as Role?,
      isVerify: fields[45] as bool?,
      verifyImages: (fields[46] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(47)
      ..writeByte(0)
      ..write(obj.isFirstLogin)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.distance)
      ..writeByte(3)
      ..write(obj.feeling)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.netAloId)
      ..writeByte(9)
      ..write(obj.netAloToken)
      ..writeByte(10)
      ..write(obj.netAloAvatar)
      ..writeByte(11)
      ..write(obj.avatar)
      ..writeByte(12)
      ..write(obj.cover)
      ..writeByte(13)
      ..write(obj.isFollow)
      ..writeByte(14)
      ..write(obj.isFavorite)
      ..writeByte(15)
      ..write(obj.gender)
      ..writeByte(16)
      ..write(obj.followGenders)
      ..writeByte(17)
      ..write(obj.birthday)
      ..writeByte(18)
      ..write(obj.height)
      ..writeByte(19)
      ..write(obj.weight)
      ..writeByte(20)
      ..write(obj.story)
      ..writeByte(21)
      ..write(obj.province)
      ..writeByte(22)
      ..write(obj.city)
      ..writeByte(25)
      ..write(obj.numberOfBlocker)
      ..writeByte(26)
      ..write(obj.numberOfFollower)
      ..writeByte(27)
      ..write(obj.numberOfFavoritor)
      ..writeByte(28)
      ..write(obj.numberOfCandy)
      ..writeByte(29)
      ..write(obj.numberOfBear)
      ..writeByte(30)
      ..write(obj.numberOfFollowing)
      ..writeByte(31)
      ..write(obj.zodiac)
      ..writeByte(32)
      ..write(obj.sogiescs)
      ..writeByte(33)
      ..write(obj.relationship)
      ..writeByte(34)
      ..write(obj.careers)
      ..writeByte(35)
      ..write(obj.literacy)
      ..writeByte(36)
      ..write(obj.backgroundImage)
      ..writeByte(37)
      ..write(obj.hobbies)
      ..writeByte(38)
      ..write(obj.lomoId)
      ..writeByte(39)
      ..write(obj.fieldDisabled)
      ..writeByte(40)
      ..write(obj.isKol)
      ..writeByte(41)
      ..write(obj.datingImages)
      ..writeByte(42)
      ..write(obj.quote)
      ..writeByte(43)
      ..write(obj.filter)
      ..writeByte(44)
      ..write(obj.role)
      ..writeByte(45)
      ..write(obj.isVerify)
      ..writeByte(46)
      ..write(obj.verifyImages)
      ..writeByte(23)
      ..write(obj.isEnoughBasicInfo)
      ..writeByte(24)
      ..write(obj.isEnoughNetAloBasicInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
