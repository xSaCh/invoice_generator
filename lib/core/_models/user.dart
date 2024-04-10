import 'package:invoice_bloc/core/models/bank_info.dart';

class User {
  final String name;
  final String address;
  final String phone;
  final String email;
  final String gstin;
  final BankInfo bankInfo;

  User({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.gstin,
    required this.bankInfo,
  });

  User.fromJson(Map<String, dynamic> json)
      : this(
            name: json['name'],
            address: json['address'],
            phone: json['phone'],
            email: json['email'],
            gstin: json['gstin'],
            bankInfo: BankInfo.fromJson(json['bankInfo']));
  // name = json['name'];
  // address = json['address'];
  // phone = json['phone'];
  // email = json['email'];
  // gstin = json['gstin'];
  // bankInfo = json['bankInfo'] != null ? new BankInfo.fromJson(json['bankInfo']) : null;
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['phone'] = phone;
    data['email'] = email;
    data['gstin'] = gstin;
    data['bankInfo'] = bankInfo.toJson();
    return data;
  }

  static User ex = User(
      name: "Om Enterprise",
      address: "77, Adhard Estate, Nr. Palican Estate Kathwada GIDC, Ahmedabad, 382430",
      phone: "8200848500",
      email: "oment996@gmail.com",
      gstin: "24EVYPK2977R1Z7",
      bankInfo: BankInfo.ex);

  static User ex2 = User(
      name: "Shiv Enterprise",
      address: "77, Adhard Estate, Nr. Palican Estate Kathwada GIDC, Ahmedabad, 382430",
      phone: "9328623148",
      email: "kanzariyajaypal22@gmail..com",
      gstin: "24JYTPK7181N1ZB",
      bankInfo: BankInfo.ex);
}
