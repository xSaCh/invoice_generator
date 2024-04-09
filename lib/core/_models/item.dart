import 'package:hive/hive.dart';
import 'package:invoice_bloc/core/_models/types.dart';

part 'item.g.dart';

@HiveType(typeId: 3)
class Product extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  int? hsc;
  @HiveField(2)
  double unitPrice;
  @HiveField(3)
  Unit unit;
  @HiveField(4)
  GSTType gstType;

  Product(
    this.name,
    this.unitPrice, {
    this.gstType = GSTType.none,
    this.unit = Unit.pcs,
    this.hsc,
  });
}

@HiveType(typeId: 4)
class Item extends HiveObject {
  @HiveField(0)
  Product product;
  @HiveField(1)
  int quantities;

  Item(this.product, {this.quantities = 0});

  double getSubAmount() => quantities * product.unitPrice;

  double getGstAmount() => gstValue(product.gstType) * 0.01 * getSubAmount();

  double getAmount() => getSubAmount() + getGstAmount();
}
