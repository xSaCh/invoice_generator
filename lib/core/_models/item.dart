// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
  Product.empty() : this("", 0);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'hsc': hsc,
      'unitPrice': unitPrice,
      'unit': unit.name,
      'gstType': gstType.name,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      map['name'] as String,
      map['unitPrice'] as double,
      hsc: map['hsc'] != null ? map['hsc'] as int : null,
      unit: Unit.values.firstWhere((e) => e.name == map['unit']),
      gstType: GSTType.values.firstWhere((e) => e.name == map['gstType']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.toMap(),
      'quantities': quantities,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      Product.fromMap(map['product'] as Map<String, dynamic>),
      quantities: map['quantities'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);
}
