// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surahhelper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurahAdapter extends TypeAdapter<Surah> {
  @override
  final int typeId = 0;

  @override
  Surah read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Surah(
      number: fields[0] as int?,
      name: fields[1] as String?,
      nameLatin: fields[2] as String?,
      numberOfAyah: fields[3] as int?,
      text: (fields[4] as List?)?.cast<SurahText>(),
      translation: fields[5] as SurahTranslation?,
    );
  }

  @override
  void write(BinaryWriter writer, Surah obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.nameLatin)
      ..writeByte(3)
      ..write(obj.numberOfAyah)
      ..writeByte(4)
      ..write(obj.text)
      ..writeByte(5)
      ..write(obj.translation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SurahTextAdapter extends TypeAdapter<SurahText> {
  @override
  final int typeId = 1;

  @override
  SurahText read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurahText(
      fields[0] as int?,
      fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SurahText obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.ayah);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahTextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SurahTranslationAdapter extends TypeAdapter<SurahTranslation> {
  @override
  final int typeId = 2;

  @override
  SurahTranslation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurahTranslation(
      fields[0] as String?,
      (fields[1] as List?)?.cast<SurahTranslationText>(),
    );
  }

  @override
  void write(BinaryWriter writer, SurahTranslation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahTranslationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SurahTranslationTextAdapter extends TypeAdapter<SurahTranslationText> {
  @override
  final int typeId = 3;

  @override
  SurahTranslationText read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurahTranslationText(
      fields[0] as int?,
      fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SurahTranslationText obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahTranslationTextAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SurahBookmarkAdapter extends TypeAdapter<SurahBookMark> {
  @override
  final int typeId = 4;

  @override
  SurahBookMark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurahBookMark(
      ayahNumber: fields[5] as int?,
      name: fields[0] as String?,
      nameLatin: fields[1] as String?,
      number: fields[4] as int?,
      text: fields[2] as String?,
      translate: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SurahBookMark obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.nameLatin)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.translate)
      ..writeByte(4)
      ..write(obj.number)
      ..writeByte(5)
      ..write(obj.ayahNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahBookmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
