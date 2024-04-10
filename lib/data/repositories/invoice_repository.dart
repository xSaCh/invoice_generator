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

class InvoiceRepository {
  late Box<Invoice> box;

  InvoiceRepository() {
    box = Hive.box<Invoice>('invoices');
  }
  List<Invoice> getInvoices() {
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

  void removeInvoice(int key) {
    box.delete(key);
  }

  void addItemToInvoice(int key, Item item) {
    var inv = box.get(key);
    if (inv != null) {
      inv.addItem(item);
      inv.save();
    }
    FireBaseService.ins().addItemToInvoice(key, item);
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
}
