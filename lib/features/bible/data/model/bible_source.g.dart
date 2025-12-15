// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_source.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BibleSourceAdapter extends TypeAdapter<BibleSource> {
  @override
  final int typeId = 20;

  @override
  BibleSource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BibleSource(
      id: fields[0] as String,
      name: fields[1] as String,
      shortName: fields[2] as String,
      language: fields[3] as String,
      sourceUrl: fields[4] as String,
      isDownloaded: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BibleSource obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.shortName)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.sourceUrl)
      ..writeByte(5)
      ..write(obj.isDownloaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
