// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/core/_models/item.dart';
import 'package:invoice_bloc/core/_models/types.dart';

part 'invoice.g.dart';

@HiveType(typeId: 2)
class Invoice extends HiveObject {
  @HiveField(0)
  String invoiceNo;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  double receivedAmt = 0;

  @HiveField(3)
  Customer customer;
  @HiveField(4)
  List<Item> items = [];
  Invoice(
    this.invoiceNo,
    this.date,
    this.receivedAmt,
    this.customer,
    this.items,
  );

  void addItem(Item item) async {
    items.add(item);
    // await save();
  }

  double getReceivedAmount() => receivedAmt;

  double getTotal() {
    double tlt = 0;

    for (var i in items) {
      tlt += i.getAmount();
    }
    return tlt;
  }

  double getSubTotal() {
    double tlt = 0;

    for (var i in items) {
      tlt += i.getSubAmount();
    }
    return tlt;
  }

  double getGstTotal() {
    double tlt = 0;
    for (var i in items) {
      tlt += i.getGstAmount();
    }
    return tlt;
  }

  Map<GSTType, double> getGstTotals() {
    Map<GSTType, double> tls = {};
    for (var x in items) {
      tls[x.product.gstType] = (tls[x.product.gstType] ?? 0) + x.getGstAmount();
    }
    return tls;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'invoiceNo': invoiceNo,
      'date': date.millisecondsSinceEpoch,
      'receivedAmt': receivedAmt,
      'customer': customer.toMap(),
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      map['invoiceNo'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      map['receivedAmt'] as double,
      Customer.fromMap(map['customer'] as Map<String, dynamic>),
      List<Item>.from(
        (map['items'] as List).map<Item>(
          (x) => Item.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Invoice.fromJson(String source) =>
      Invoice.fromMap(json.decode(source) as Map<String, dynamic>);
}
