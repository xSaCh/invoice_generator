// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankInfoAdapter extends TypeAdapter<BankInfo> {
  @override
  final int typeId = 0;

  @override
  BankInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankInfo(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      upiId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BankInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.bankName)
      ..writeByte(1)
      ..write(obj.accountNo)
      ..writeByte(2)
      ..write(obj.ifscCode)
      ..writeByte(3)
      ..write(obj.holderName)
      ..writeByte(4)
      ..write(obj.upiId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
