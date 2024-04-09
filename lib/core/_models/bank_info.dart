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
}
