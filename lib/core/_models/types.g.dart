// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GSTTypeAdapter extends TypeAdapter<GSTType> {
  @override
  final int typeId = 5;

  @override
  GSTType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GSTType.none;
      case 1:
        return GSTType.gst_0;
      case 2:
        return GSTType.gst_0_25;
      case 3:
        return GSTType.gst_3;
      case 4:
        return GSTType.gst_5;
      case 5:
        return GSTType.gst_12;
      case 6:
        return GSTType.gst_18;
      case 7:
        return GSTType.gst_28;
      case 8:
        return GSTType.igst_0;
      case 9:
        return GSTType.igst_0_25;
      case 10:
        return GSTType.igst_3;
      case 11:
        return GSTType.igst_5;
      case 12:
        return GSTType.igst_12;
      case 13:
        return GSTType.igst_18;
      case 14:
        return GSTType.igst_28;
      default:
        return GSTType.none;
    }
  }

  @override
  void write(BinaryWriter writer, GSTType obj) {
    switch (obj) {
      case GSTType.none:
        writer.writeByte(0);
        break;
      case GSTType.gst_0:
        writer.writeByte(1);
        break;
      case GSTType.gst_0_25:
        writer.writeByte(2);
        break;
      case GSTType.gst_3:
        writer.writeByte(3);
        break;
      case GSTType.gst_5:
        writer.writeByte(4);
        break;
      case GSTType.gst_12:
        writer.writeByte(5);
        break;
      case GSTType.gst_18:
        writer.writeByte(6);
        break;
      case GSTType.gst_28:
        writer.writeByte(7);
        break;
      case GSTType.igst_0:
        writer.writeByte(8);
        break;
      case GSTType.igst_0_25:
        writer.writeByte(9);
        break;
      case GSTType.igst_3:
        writer.writeByte(10);
        break;
      case GSTType.igst_5:
        writer.writeByte(11);
        break;
      case GSTType.igst_12:
        writer.writeByte(12);
        break;
      case GSTType.igst_18:
        writer.writeByte(13);
        break;
      case GSTType.igst_28:
        writer.writeByte(14);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GSTTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UnitAdapter extends TypeAdapter<Unit> {
  @override
  final int typeId = 6;

  @override
  Unit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Unit.pcs;
      case 1:
        return Unit.kg;
      case 2:
        return Unit.gm;
      default:
        return Unit.pcs;
    }
  }

  @override
  void write(BinaryWriter writer, Unit obj) {
    switch (obj) {
      case Unit.pcs:
        writer.writeByte(0);
        break;
      case Unit.kg:
        writer.writeByte(1);
        break;
      case Unit.gm:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
