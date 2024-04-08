class BankInfo {
  final String bankName;
  final String accountNo;
  final String ifscCode;
  final String holderName;
  String? upiId;

  BankInfo({
    required this.bankName,
    required this.accountNo,
    required this.ifscCode,
    required this.holderName,
    this.upiId,
  });

  BankInfo.fromJson(Map<String, dynamic> json)
      : this(
            bankName: json['bankName'],
            accountNo: json['accountNo'],
            ifscCode: json['ifscCode'],
            holderName: json['holderName'],
            upiId: json['upiId']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bankName'] = bankName;
    data['accountNo'] = accountNo;
    data['ifscCode'] = ifscCode;
    data['holderName'] = holderName;
    data['upiId'] = upiId;
    return data;
  }

  static BankInfo ex = BankInfo(
      bankName: "ICICI BANK LIMITED,DHANDHUKA BRANCH",
      accountNo: "401601500963",
      ifscCode: "ICIC0004016",
      holderName: "Jaypal Kanzariya");
}
