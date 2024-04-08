import 'package:bloc/bloc.dart';
import 'package:invoice_bloc/core/models/invoice.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      //TODO: GetInvoices
      if (event is HomeGetInvoices) {
        try {
          emit(HomeLoading());
          List<Invoice> invoices = [];
          emit(HomeLoaded(invoices));
        } catch (e) {
          emit(HomeError());
        }
      } else if (event is HomeRemoveInvoice) {
        var invoice = (event as HomeRemoveInvoice).invoice;
        //TODO: Remove Invoices

        try {
          emit(HomeLoading());
          List<Invoice> invoices = [];
          emit(HomeLoaded(invoices));
        } catch (e) {
          emit(HomeError());
        }
      }
    });
  }
}
