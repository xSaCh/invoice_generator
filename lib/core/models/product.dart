import 'package:invoice_bloc/core/models/types.dart';

//TODO: Add support for Discount

class Product {
  int pid;
  String name;
  int? hsc;
  double unitPrice;
  Unit unit;
  GSTType gstType;

  Product({
    required this.pid,
    required this.name,
    required this.unitPrice,
    this.gstType = GSTType.none,
    this.unit = Unit.Pcs,
    this.hsc,
  });

  Product.empty(int pid) : this(pid: pid, name: "", unitPrice: 0);

  Product.copy(Product p)
      : this(
            pid: p.pid,
            name: p.name,
            unitPrice: p.unitPrice,
            gstType: p.gstType,
            unit: p.unit,
            hsc: p.hsc);

  Product.fromJson(Map<String, dynamic> json)
      : this(
            pid: json['pid'],
            name: json['name'],
            unitPrice: json['unitPrice'],
            gstType: GSTType.values.firstWhere((e) => e.name == json['gstType']),
            unit: Unit.values.firstWhere((e) => e.name == json['unit']),
            hsc: json['hsc']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pid'] = pid;
    data['name'] = name;
    data['unitPrice'] = unitPrice;
    data['gstType'] = gstType.name;
    data['unit'] = unit.name;
    data['hsc'] = hsc;
    return data;
  }
}

class Item {
  Product product;
  int quantities;
  // GSTType gstType = GSTType.none;

  Item({required this.product, this.quantities = 0}) {
    // gstType = product.gstType;
  }

  Item.fromJson(Map<String, dynamic> json)
      : this(product: Product.fromJson(json['product']), quantities: json['quantities']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product.toJson();
    data['quantities'] = quantities;
    return data;
  }

  double getSubAmount() => quantities * product.unitPrice;

  double getGstAmount() => gstValue(product.gstType) * 0.01 * getSubAmount();

  double getAmount() => getSubAmount() + getGstAmount();

  static List<Item> ex = [
    Item(
        product: Product(
            pid: 1,
            name: "MICRO SPORTS 2 WAY (polo with front back print)",
            hsc: 69041,
            unitPrice: 123.81,
            unit: Unit.Kg,
            gstType: GSTType.gst_5),
        quantities: 240),
    Item(
        product: Product(
            pid: 2,
            name: "Stiching",
            unitPrice: 35,
            unit: Unit.Pcs,
            gstType: GSTType.gst_12),
        quantities: 798),
    Item(
        product: Product(
            pid: 2,
            name: "Printing",
            unitPrice: 70,
            unit: Unit.Pcs,
            gstType: GSTType.gst_18),
        quantities: 798)
  ];
}
