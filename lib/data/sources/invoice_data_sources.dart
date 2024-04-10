import 'dart:convert';

import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';

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
