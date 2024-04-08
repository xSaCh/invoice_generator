import 'package:invoice_bloc/core/models/bank_info.dart';

//TODO: make name final

class Customer {
  final int cId;
  String name;
  final String address;
  final String phone;
  final String email;
  final String gstin;
  BankInfo? bankInfo;

  Customer(
      {required this.cId,
      required this.name,
      required this.address,
      required this.phone,
      required this.email,
      required this.gstin,
      this.bankInfo});

  Customer.fromJson(Map<String, dynamic> json)
      : this(
            cId: json['cId'],
            name: json['name'],
            address: json['address'],
            phone: json['phone'],
            email: json['email'],
            gstin: json['gstin'],
            bankInfo:
                json['bankInfo'] != null ? BankInfo.fromJson(json['bankInfo']) : null);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cId'] = cId;
    data['name'] = name;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['gstin'] = gstin;
    data['bankInfo'] = bankInfo?.toJson();
    return data;
  }

  static Customer ex = Customer(
      cId: 1,
      name: "AEPIC AGROTECH",
      address: "5B SHAKTI COMPLEX HIGHWAY CHAR RASTA CHANSMA",
      phone: "9824058015",
      email: "",
      gstin: "24BXYPP6564Q1Z4");
}
