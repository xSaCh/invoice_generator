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
