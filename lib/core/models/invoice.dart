import 'package:invoice_bloc/core/models/customer.dart';
import 'package:invoice_bloc/core/models/product.dart';
import 'package:invoice_bloc/core/models/types.dart';

class Invoice {
  int invId;
  //TODO: Generate invoice number from invoice id
  String invoiceNo;
  late Customer customer;
  DateTime date;
  List<Item> items = [];
  double receivedAmt;

  Invoice(
      {required this.invId,
      required this.invoiceNo,
      required this.customer,
      this.receivedAmt = 0})
      : date = DateTime.now();
  // this.items = items;

  Invoice.fromJson(Map<String, dynamic> json)
      : invId = json['invId'],
        invoiceNo = json['invoiceNo'],
        customer = Customer.fromJson(json['customer']),
        date = DateTime.parse(json['date']),
        items = (json['items'] as List).map((e) => Item.fromJson(e)).toList(),
        receivedAmt = json['receivedAmt'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['invId'] = invId;
    data['invoiceNo'] = invoiceNo;
    data['customer'] = customer;
    data['date'] = date.toIso8601String();
    data['items'] = items.map((e) => e.toJson()).toList();
    data['receivedAmt'] = receivedAmt;
    return data;
  }

  void addItem(Item item) => items.add(item);

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

  static Invoice ex =
      Invoice(invId: 1, invoiceNo: "SR/23-24/0001", customer: Customer.ex);
}

Invoice getSampleInv() {
  Invoice inv = Invoice(
      invId: 1,
      invoiceNo: "SR/23-24/0001",
      customer: Customer(
          cId: 1,
          name: "DASHDRIP LLPAAADJIIODJeffnfn",
          address: "",
          phone: "9638443579",
          email: "",
          gstin: ""));
  inv.date = DateTime(2023, 11, 7);

  inv.items.add(Item(
      product: Product(
          pid: 1,
          name: "Stiching",
          hsc: 0,
          unitPrice: 28,
          unit: Unit.Pcs,
          gstType: GSTType.gst_12),
      quantities: 198));

  inv.addItem(Item(
      product: Product(
          pid: 2,
          name: "Printing",
          hsc: 0,
          unitPrice: 70,
          unit: Unit.Pcs,
          gstType: GSTType.gst_18),
      quantities: 988));

  return inv;
}
