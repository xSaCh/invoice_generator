import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/item.dart';

class FireBaseService {
  static FireBaseService? _global;
  static FireBaseService ins() {
    _global ??= FireBaseService();

    return _global!;
  }

  final FirebaseFirestore firestore;
  final box = Hive.box<Invoice>('invoices');
  FireBaseService() : firestore = FirebaseFirestore.instance;

String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';
  void addInvoice(Invoice inv) {
    
    firestore.collection('invoices').doc("${inv.key}").set({
      ...inv.toMap(),
      'userId': uid,
    });
    // firestore.collection('invoices').
  }

  Future<List<Invoice>> getAllInvoices() async {
    try {
      var snapshot = await firestore
          .collection('invoices')
          .where('userId', isEqualTo: uid)
          .get();
      return snapshot.docs.map((doc) {
        var inv = Invoice.fromMap(doc.data());
        box.put(doc.id, inv);
        print("K: ${inv.key}");
        return inv;
      }).toList();
    } catch (e) {
      print("ERROR: ${e}");
    }
    return [];
  }

  Future<void> addItemToInvoice(int key, Item item) async {
    var invRef = firestore.collection('invoices').doc("$key");
    var invMap = (await invRef.get()).data();
    if (invMap != null) {
      var inv = Invoice.fromMap(invMap)..addItem(item);
      invRef.set({
        ...inv.toMap(),
        'userId': uid,
      });
    }
  }

  void updateInvoice(Invoice newInvoice) async {
    var invRef = firestore.collection('invoices').doc("${newInvoice.key}");

    invRef.set({
      ...newInvoice.toMap(),
      'userId': uid,
    });
  }

  void updateItemToInvoice(int key, int index, Item item) async {
    var invRef = firestore.collection('invoices').doc("$key");
    var invMap = (await invRef.get()).data();
    if (invMap != null) {
      var inv = Invoice.fromMap(invMap)..items[index] = item;
      invRef.set({
        ...inv.toMap(),
        'userId': uid,
      });
    }
  }

  void removeItemToInvoice(int key, int index) async {
    var invRef = firestore.collection('invoices').doc("$key");
    var invMap = (await invRef.get()).data();
    if (invMap != null) {
      var inv = Invoice.fromMap(invMap)..items.removeAt(index);
      invRef.set({
        ...inv.toMap(),
        'userId': uid,
      });
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
