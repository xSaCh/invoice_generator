/*
  getInvoices
  getInvoice
  addInvoice
  removeInvoice
  updateInvoice
 */

import 'package:hive/hive.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/item.dart';
import 'package:invoice_bloc/data/firebase_service.dart';
import 'package:invoice_bloc/global.dart';

class InvoiceRepository {
  late Box<Invoice> box;

  InvoiceRepository() {
    box = Hive.box<Invoice>('invoices');
  }
  Future<List<Invoice>> getInvoices() async {
    try {
      if (Global.ins().isGuest) return box.values.toList().cast<Invoice>();
      return FireBaseService.ins().getAllInvoices();
    } catch (e) {}
    return box.values.toList().cast<Invoice>();
  }

  Invoice? getInvoice(int key) {
    return box.get(key);
  }

  void addInvoice(Invoice inv) {
    box.add(inv);
    inv.save();
    FireBaseService.ins().addInvoice(inv);
  }

  void removeInvoice(dynamic key) {
    box.delete(key);
  }

  Future addItemToInvoice(int key, Item item) async {
    var inv = box.get(key);
    if (inv != null) {
      inv.addItem(item);
      inv.save();
    }
    await FireBaseService.ins().addItemToInvoice(key, item);
  }

  void removeItemToInvoice(int key, int index) {
    var inv = box.get(key);
    if (inv != null) {
      inv.items.removeAt(index);
      inv.save();
    }
    FireBaseService.ins().removeItemToInvoice(key, index);
  }

  void updateItemToInvoice(int key, int index, Item item) {
    var inv = box.get(key);
    if (inv != null) {
      inv.items[index] = item;
      inv.save();
    }
    FireBaseService.ins().updateItemToInvoice(key, index, item);
  }

  void updateInvoice(Invoice newInvoice) {
    newInvoice.save();
    FireBaseService.ins().updateInvoice(newInvoice);
  }

  Invoice putInvoice(String id, Map<String, dynamic> data) {
    var inv = Invoice.fromMap(data);
    box.put(id, inv);
    return inv;
  }
}
