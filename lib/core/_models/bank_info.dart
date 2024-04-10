// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

part 'bank_info.g.dart';

@HiveType(typeId: 0)
class BankInfo extends HiveObject {
  @HiveField(0)
  final String bankName;
  @HiveField(1)
  final String accountNo;
  @HiveField(2)
  final String ifscCode;
  @HiveField(3)
  final String holderName;
  @HiveField(4)
  String? upiId;

  BankInfo(this.bankName, this.accountNo, this.ifscCode, this.holderName, {this.upiId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bankName': bankName,
      'accountNo': accountNo,
      'ifscCode': ifscCode,
      'holderName': holderName,
      'upiId': upiId,
    };
  }

  factory BankInfo.fromMap(Map<String, dynamic> map) {
    return BankInfo(
      map['bankName'] as String,
      map['accountNo'] as String,
      map['ifscCode'] as String,
      map['holderName'] as String,
      upiId: map['upiId'] != null ? map['upiId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BankInfo.fromJson(String source) =>
      BankInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
