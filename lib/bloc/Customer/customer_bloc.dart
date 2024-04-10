import 'package:bloc/bloc.dart';
import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/global.dart';
import 'package:meta/meta.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  Customer customer;
  CustomerBloc({required this.customer}) : super(CustomerInitial()) {
    on<CustomerEvent>((event, emit) {
      if (event is CustomerUpdateValue) {
        emit(CustomerUpdating());

        customer.name = event.name ?? customer.name;
        customer.address = event.address ?? customer.address;
        customer.phone = event.phone ?? customer.phone;
        customer.email = event.email ?? customer.email;
        customer.gstin = event.gstin ?? customer.gstin;

        if (!customer.isInBox) Global.ins().customerRepository.addCustomer(customer);
        customer.save();
        emit(CustomerUpdated());
      } else if (event is CustomerChangeCustomer) {
        emit(CustomerUpdating());
        customer = event.newCustomer;
        emit(CustomerUpdated());
      }
    });
  }
}
