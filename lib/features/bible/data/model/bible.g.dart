// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BibleAdapter extends TypeAdapter<Bible> {
  @override
  final int typeId = 23;

  @override
  Bible read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bible(
      id: fields[0] as String,
      name: fields[1] as String,
      shortName: fields[2] as String,
      language: fields[3] as String,
      moduleVersion: fields[4] as String,
      verses: (fields[5] as List).cast<Verse>(),
      adapterHint: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Bible obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.shortName)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.moduleVersion)
      ..writeByte(5)
      ..write(obj.verses)
      ..writeByte(6)
      ..write(obj.adapterHint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
