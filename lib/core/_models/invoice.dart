// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    await save();
  }

  double getReceivedAmount() => receivedAmt;

  double getTotal() {
    double tlt = 0;

    for (var i in items) tlt += i.getAmount();
    return tlt;
  }

  double getSubTotal() {
    double tlt = 0;

    for (var i in items) tlt += i.getSubAmount();
    return tlt;
  }

  double getGstTotal() {
    double tlt = 0;
    for (var i in items) tlt += i.getGstAmount();
    return tlt;
  }

  Map<GSTType, double> getGstTotals() {
    Map<GSTType, double> tls = {};
    for (var x in items) {
      tls[x.product.gstType] = (tls[x.product.gstType] ?? 0) + x.getGstAmount();
    }
    return tls;
  }
}
