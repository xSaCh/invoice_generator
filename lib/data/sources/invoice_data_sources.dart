import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/item.dart';
import 'package:invoice_bloc/core/_models/types.dart';

List<Customer> getCustomers() {
  return [
    Customer(
      "Harshaditya Singh Jadeja",
      "8, Adarsh Society, Hospital Road, Bhuj, Kutch - 370001",
      "9601117957",
      "",
      "",
    ),
    Customer(
      "Fortify Consults",
      "B 100, Adarsh Society, Hospital Road, Bhuj, Kutch - 370001",
      "9601117957",
      "idk@gmail.com",
      "24AGRPA82678A1ZJ",
    ),
  ];
}

List<Invoice> getInvoices() {
  Invoice inv = Invoice(
      "SR/23-24/0001", DateTime(2023, 11, 7), 0, getCustomers()[0], [].cast<Item>());

  inv.items.add(Item(Product("Stiching", 28, gstType: GSTType.gst_12), quantities: 198));

  inv.items.add(
      Item(Product("Printing", 70, hsc: 0, gstType: GSTType.gst_18), quantities: 988));

  return [inv];
}
