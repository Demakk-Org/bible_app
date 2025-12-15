// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_verse.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyVerseAdapter extends TypeAdapter<DailyVerse> {
  @override
  final int typeId = 0;

  @override
  DailyVerse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyVerse(
      id: fields[0] as String,
      text: fields[1] as String,
      book: fields[2] as int,
      chapter: fields[3] as int,
      createdAt: fields[4] as DateTime,
      displayDate: fields[5] as DateTime,
      reference: fields[6] as String,
      tag: fields[8] as String,
      verse: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyVerse obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.book)
      ..writeByte(3)
      ..write(obj.chapter)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.displayDate)
      ..writeByte(6)
      ..write(obj.reference)
      ..writeByte(8)
      ..write(obj.tag)
      ..writeByte(9)
      ..write(obj.verse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyVerseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
