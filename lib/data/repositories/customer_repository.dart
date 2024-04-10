/*
  getCustomers
  getCustomer
  addCustomer
  removeCustomer
  updateCustomer
 */

import 'package:hive/hive.dart';
import 'package:invoice_bloc/core/_models/customer.dart';

class CustomerRepository {
  late Box<Customer> box;

  CustomerRepository() {
    box = Hive.box<Customer>('customers');
  }
  List<Customer> getCustomers() {
    return box.values.toList().cast<Customer>();
  }

  Customer? getCustomer(int key) {
    return box.get(key);
  }

  void addCustomer(Customer cst) {
    box.add(cst);
  }

  void removeCustomer(int key) {
    box.delete(key);
  }
}
