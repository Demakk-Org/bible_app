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
      isHomePageTutorialCompleted: fields[0] as bool,
      isBibleTutorialCompleted: fields[1] as bool,
      isAudiosTutorialCompleted: fields[2] as bool,
      isGroupsTutorialCompleted: fields[3] as bool,
      isNewsTutorialCompleted: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Tutorial obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isHomePageTutorialCompleted)
      ..writeByte(1)
      ..write(obj.isBibleTutorialCompleted)
      ..writeByte(2)
      ..write(obj.isAudiosTutorialCompleted)
      ..writeByte(3)
      ..write(obj.isGroupsTutorialCompleted)
      ..writeByte(4)
      ..write(obj.isNewsTutorialCompleted);
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
