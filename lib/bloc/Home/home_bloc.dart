import 'package:bloc/bloc.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/data/repositories/invoice_repository.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  InvoiceRepository repository;
  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      //TODO: GetInvoices
      if (event is HomeGetInvoices) {
        try {
          emit(HomeLoading());
          var invoices = await repository.getInvoices();
          emit(HomeLoaded(invoices));
        } catch (e) {
          emit(HomeError());
        }
      } else if (event is HomeRemoveInvoice) {
        var invoice = event.invoice;
        //TODO: Remove Invoices
        try {
          repository.removeInvoice(invoice.key);
          add(HomeGetInvoices());
        } catch (e) {
          emit(HomeError());
        }
      }
    });
  }
}
