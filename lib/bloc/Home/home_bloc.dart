import 'package:bloc/bloc.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/data/firebase_service.dart';
import 'package:invoice_bloc/data/repositories/customer_repository.dart';
import 'package:invoice_bloc/data/repositories/invoice_repository.dart';
import 'package:invoice_bloc/global.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // InvoiceRepository invoiceRepo;
  // CustomerRepository customerRepo;
  HomeBloc()
      : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      //TODO: Add New Invoice (currently it is added by invoiceBloc)
      if (event is HomeGetInvoices || event is HomeUpdateInvoices) {
        try {
          emit(HomeLoading());
          var invoices = await Global.ins().invoiceRepository.getInvoices();
          print("GET INVOICES: ${invoices.length}");
          emit(HomeLoaded(invoices));
        } catch (e) {
          print("ERROR: ${e}");
          emit(HomeError());
        }
      } else if (event is HomeRemoveInvoice) {
        var invoice = event.invoice;
        try {
          print("REM ${invoice.key}");

          Global.ins().invoiceRepository.removeInvoice(invoice.key);
          add(HomeGetInvoices());
        } catch (e) {
          print("ERROR: ${e}");

          emit(HomeError());
        }
      } else if (event is HomeAddCustomer) {
        var customer = event.customer;
        try {
          Global.ins().customerRepository.addCustomer(customer);
          customer.save();
        } catch (e) {
          emit(HomeError());
        }
      }
    });
  }
}
