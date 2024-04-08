enum GSTType {
  none,
  gst_0,
  gst_0_25,
  gst_3,
  gst_5,
  gst_12,
  gst_18,
  gst_28,
  igst_0,
  igst_0_25,
  igst_3,
  igst_5,
  igst_12,
  igst_18,
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

// ignore: constant_identifier_names
enum Unit { Pcs, Kg, Gm }
