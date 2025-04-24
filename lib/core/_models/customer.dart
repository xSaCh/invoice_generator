// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:invoice_bloc/core/_models/bank_info.dart';

part 'customer.g.dart';

@HiveType(typeId: 1)
class Customer extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String address;
  @HiveField(2)
  String phone;
  @HiveField(3)
  String email;
  @HiveField(4)
  String gstin;
  @HiveField(5)
  BankInfo? bankInfo;

  Customer(this.name, this.address, this.phone, this.email, this.gstin, {this.bankInfo});

  Customer.empty() : this("", "", "", "", "");

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'gstin': gstin,
      'bankInfo': bankInfo?.toMap(),
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      map['name'] as String,
      map['address'] as String,
      map['phone'] as String,
      map['email'] as String,
      map['gstin'] as String,
      bankInfo: map['bankInfo'] != null
          ? BankInfo.fromMap(map['bankInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source) as Map<String, dynamic>);
}

List<Customer> testCustomers = [
  Customer(
    "Rajesh Patel",
    "123, Green Avenue, Ahmedabad, Gujarat",
    "+91-9876543210",
    "rajesh.patel@example.com",
    "24AABCU9603R1ZV",
    bankInfo: BankInfo(
        "State Bank of India", "1234567890", "SBIN0001234", "Rajesh Patel"),
  ),
  Customer(
    "Meena Shah",
    "456, Blue Street, Surat, Gujarat",
    "+91-8765432109",
    "meena.shah@example.com",
    "24AACCM1234F1ZV",
    bankInfo: BankInfo("HDFC Bank", "9876543210", "HDFC0005678", "Meena Shah"),
  ),
  Customer(
    "Kiran Desai",
    "789, Yellow Lane, Vadodara, Gujarat",
    "+91-7654321098",
    "kiran.desai@example.com",
    "24AAACD4567G1ZV",
    bankInfo:
        BankInfo("ICICI Bank", "8765432109", "ICIC0003456", "Kiran Desai"),
  ),
  Customer(
    "Anil Joshi",
    "101, Red Road, Rajkot, Gujarat",
    "+91-6543210987",
    "anil.joshi@example.com",
    "24AABCD7890H1ZV",
    bankInfo: BankInfo("Axis Bank", "7654321098", "UTIB0002345", "Anil Joshi"),
  ),
  Customer(
    "Bhavna Trivedi",
    "202, White Colony, Bhavnagar, Gujarat",
    "+91-5432109876",
    "bhavna.trivedi@example.com",
    "24AAACT1234J1ZV",
    bankInfo: BankInfo(
        "Bank of Baroda", "6543210987", "BARB0BHAVNA", "Bhavna Trivedi"),
  ),
];
