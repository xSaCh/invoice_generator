// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:invoice_bloc/core/_models/bank_info.dart';

part 'customer.g.dart';

@HiveType(typeId: 1)
class Customer extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  final String address;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String gstin;
  @HiveField(5)
  BankInfo? bankInfo;

  Customer(this.name, this.address, this.phone, this.email, this.gstin, {this.bankInfo});
}
