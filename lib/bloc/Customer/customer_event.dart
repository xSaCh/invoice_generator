part of 'customer_bloc.dart';

@immutable
sealed class CustomerEvent {}

class CustomerChangeCustomer extends CustomerEvent {
  final Customer newCustomer;
  CustomerChangeCustomer(this.newCustomer);
}

class CustomerUpdateValue extends CustomerEvent {
  final String? name;
  final String? address;
  final String? phone;
  final String? email;
  final String? gstin;
  // final BankInfo? bankInfo;

  CustomerUpdateValue({this.name, this.address, this.phone, this.email, this.gstin});
}
