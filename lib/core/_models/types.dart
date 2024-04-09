import 'package:hive/hive.dart';
part 'types.g.dart';

@HiveType(typeId: 5)
enum GSTType {
  @HiveField(0)
  none,
  @HiveField(1)
  gst_0,
  @HiveField(2)
  gst_0_25,
  @HiveField(3)
  gst_3,
  @HiveField(4)
  gst_5,
  @HiveField(5)
  gst_12,
  @HiveField(6)
  gst_18,
  @HiveField(7)
  gst_28,
  @HiveField(8)
  igst_0,
  @HiveField(9)
  igst_0_25,
  @HiveField(10)
  igst_3,
  @HiveField(11)
  igst_5,
  @HiveField(12)
  igst_12,
  @HiveField(13)
  igst_18,
  @HiveField(14)
  igst_28,
}

double gstValue(GSTType type) {
  switch (type) {
    case GSTType.gst_0:
    case GSTType.igst_0:
      return 0.0;
    case GSTType.gst_0_25:
    case GSTType.igst_0_25:
      return 0.25;
    case GSTType.gst_3:
    case GSTType.igst_3:
      return 3.0;
    case GSTType.gst_5:
    case GSTType.igst_5:
      return 5.0;
    case GSTType.gst_12:
    case GSTType.igst_12:
      return 12.0;
    case GSTType.gst_18:
    case GSTType.igst_18:
      return 18.0;
    case GSTType.gst_28:
    case GSTType.igst_28:
      return 28.0;
    default:
      return 0.0;
  }
}

@HiveType(typeId: 6)
enum Unit {
  @HiveField(0)
  pcs,
  @HiveField(1)
  kg,
  @HiveField(2)
  gm
}
