// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 0;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Word(
      english: fields[0] as String,
      japanese: fields[1] as String,
      example: fields[2] as String?,
      isMemorized: fields[3] as bool,
      reviewCount: fields[4] as int,
      createdAt: fields[5] as DateTime,
      lastReviewedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.english)
      ..writeByte(1)
      ..write(obj.japanese)
      ..writeByte(2)
      ..write(obj.example)
      ..writeByte(3)
      ..write(obj.isMemorized)
      ..writeByte(4)
      ..write(obj.reviewCount)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.lastReviewedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
