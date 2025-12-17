// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TutorialAdapter extends TypeAdapter<Tutorial> {
  @override
  final int typeId = 45;

  @override
  Tutorial read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tutorial(
      isBibleTutorialCompleted: fields[1] as bool,
      isBookmarksTutorialCompleted: (fields[2] as bool?) ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, Tutorial obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.isBibleTutorialCompleted);
    writer
      ..writeByte(2)
      ..write(obj.isBookmarksTutorialCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TutorialAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
