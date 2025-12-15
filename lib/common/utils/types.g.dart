// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BibleStatusAdapter extends TypeAdapter<BibleStatus> {
  @override
  final int typeId = 22;

  @override
  BibleStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BibleStatus.initial;
      case 1:
        return BibleStatus.success;
      case 2:
        return BibleStatus.error;
      case 3:
        return BibleStatus.saving;
      case 4:
        return BibleStatus.searching;
      default:
        return BibleStatus.initial;
    }
  }

  @override
  void write(BinaryWriter writer, BibleStatus obj) {
    switch (obj) {
      case BibleStatus.initial:
        writer.writeByte(0);
        break;
      case BibleStatus.success:
        writer.writeByte(1);
        break;
      case BibleStatus.error:
        writer.writeByte(2);
        break;
      case BibleStatus.saving:
        writer.writeByte(3);
        break;
      case BibleStatus.searching:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QueryStatusAdapter extends TypeAdapter<QueryStatus> {
  @override
  final int typeId = 39;

  @override
  QueryStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QueryStatus.initial;
      case 1:
        return QueryStatus.loading;
      case 2:
        return QueryStatus.success;
      case 3:
        return QueryStatus.error;
      default:
        return QueryStatus.initial;
    }
  }

  @override
  void write(BinaryWriter writer, QueryStatus obj) {
    switch (obj) {
      case QueryStatus.initial:
        writer.writeByte(0);
        break;
      case QueryStatus.loading:
        writer.writeByte(1);
        break;
      case QueryStatus.success:
        writer.writeByte(2);
        break;
      case QueryStatus.error:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MutationStatusAdapter extends TypeAdapter<MutationStatus> {
  @override
  final int typeId = 40;

  @override
  MutationStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MutationStatus.initial;
      case 1:
        return MutationStatus.saving;
      case 2:
        return MutationStatus.success;
      case 3:
        return MutationStatus.error;
      default:
        return MutationStatus.initial;
    }
  }

  @override
  void write(BinaryWriter writer, MutationStatus obj) {
    switch (obj) {
      case MutationStatus.initial:
        writer.writeByte(0);
        break;
      case MutationStatus.saving:
        writer.writeByte(1);
        break;
      case MutationStatus.success:
        writer.writeByte(2);
        break;
      case MutationStatus.error:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MutationStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppLanguageAdapter extends TypeAdapter<AppLanguage> {
  @override
  final int typeId = 60;

  @override
  AppLanguage read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppLanguage.english;
      case 1:
        return AppLanguage.amharic;
      case 2:
        return AppLanguage.afanOromo;
      default:
        return AppLanguage.english;
    }
  }

  @override
  void write(BinaryWriter writer, AppLanguage obj) {
    switch (obj) {
      case AppLanguage.english:
        writer.writeByte(0);
        break;
      case AppLanguage.amharic:
        writer.writeByte(1);
        break;
      case AppLanguage.afanOromo:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppThemeAdapter extends TypeAdapter<AppTheme> {
  @override
  final int typeId = 61;

  @override
  AppTheme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppTheme.light;
      case 1:
        return AppTheme.dark;
      case 2:
        return AppTheme.system;
      default:
        return AppTheme.light;
    }
  }

  @override
  void write(BinaryWriter writer, AppTheme obj) {
    switch (obj) {
      case AppTheme.light:
        writer.writeByte(0);
        break;
      case AppTheme.dark:
        writer.writeByte(1);
        break;
      case AppTheme.system:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
