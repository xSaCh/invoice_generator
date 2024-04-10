import 'package:bloc/bloc.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/data/repositories/customer_repository.dart';
import 'package:invoice_bloc/data/repositories/invoice_repository.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  InvoiceRepository invoiceRepo;
  CustomerRepository customerRepo;
  HomeBloc({required this.invoiceRepo, required this.customerRepo})
      : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      //TODO: Add New Invoice (currently it is added by invoiceBloc)
      if (event is HomeGetInvoices) {
        try {
          emit(HomeLoading());
          var invoices = invoiceRepo.getInvoices();
          emit(HomeLoaded(invoices));
        } catch (e) {
          emit(HomeError());
        }
      } else if (event is HomeRemoveInvoice) {
        var invoice = event.invoice;
        try {
          invoiceRepo.removeInvoice(invoice.key);
          add(HomeGetInvoices());
        } catch (e) {
          emit(HomeError());
        }
      } else if (event is HomeAddCustomer) {
        var customer = event.customer;
        try {
          customerRepo.addCustomer(customer);
          customer.save();
        } catch (e) {
          emit(HomeError());
        }
      }
    });
  }
}
