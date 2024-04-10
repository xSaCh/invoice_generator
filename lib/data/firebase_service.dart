import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/item.dart';

class FireBaseService {
  static FireBaseService? _global;
  static FireBaseService ins() {
    _global ??= FireBaseService();

    return _global!;
  }

  final FirebaseFirestore firestore;
  FireBaseService() : firestore = FirebaseFirestore.instance;

  void addInvoice(Invoice inv) {
    firestore.collection('invoices').doc("${inv.key}").set(inv.toMap());
    // firestore.collection('invoices').
  }

  void addItemToInvoice(int key, Item item) async {
    var invRef = firestore.collection('invoices').doc("$key");
    var invMap = (await invRef.get()).data();
    if (invMap != null) {
      var inv = Invoice.fromMap(invMap)..addItem(item);
      invRef.set(inv.toMap());
    }
  }

  void updateInvoice(Invoice newInvoice) async {
    var invRef = firestore.collection('invoices').doc("${newInvoice.key}");

    invRef.set(newInvoice.toMap());
  }

  void updateItemToInvoice(int key, int index, Item item) async {
    var invRef = firestore.collection('invoices').doc("$key");
    var invMap = (await invRef.get()).data();
    if (invMap != null) {
      var inv = Invoice.fromMap(invMap)..items[index] = item;
      invRef.set(inv.toMap());
    }
  }

  void removeItemToInvoice(int key, int index) async {
    var invRef = firestore.collection('invoices').doc("$key");
    var invMap = (await invRef.get()).data();
    if (invMap != null) {
      var inv = Invoice.fromMap(invMap)..items.removeAt(index);
      invRef.set(inv.toMap());
    }
  }

  // Future<Invoice?> _updateInvoice(int key) async {
  //   var invRef = firestore.collection('invoices').doc("$key");
  //   var invMap = (await invRef.get()).data();
  //   if (invMap != null) {
  //     var inv = Invoice.fromMap(invMap);
  //     return inv;
  //   }
  //   return null;
  // }
}
