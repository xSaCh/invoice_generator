/*
  getInvoices
  getInvoice
  addInvoice
  removeInvoice
  updateInvoice
 */

import 'package:hive/hive.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';

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
  }

  void removeInvoice(int key) {
    box.delete(key);
  }
}
