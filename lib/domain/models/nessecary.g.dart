// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nessecary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NessecaryAdapter extends TypeAdapter<Nessecary> {
  @override
  final int typeId = 0;

  @override
  Nessecary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Nessecary(
      complete: fields[0] as bool,
      id: fields[1] as int,
      note: fields[2] as String,
      task: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Nessecary obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.complete)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.note)
      ..writeByte(3)
      ..write(obj.task);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NessecaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
