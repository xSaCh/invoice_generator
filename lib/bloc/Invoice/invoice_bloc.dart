import 'package:bloc/bloc.dart';
import 'package:invoice_bloc/core/models/invoice.dart';
import 'package:invoice_bloc/core/models/product.dart';
import 'package:meta/meta.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceInitial()) {
    on<InvoiceEvent>((event, emit) {
      if (event is InvoiceAddItem) {
        emit(InvoiceUpdating());
        //TODO: Add Invoice item
        emit(InvoiceUpdated([event.item]));
      } else if (event is InvoiceRemoveItem) {
        emit(InvoiceUpdating());
        //TODO: Remove Invoice item
        emit(InvoiceUpdated([event.item]));
      }
      if (event is InvoiceUpdateItem) {
        emit(InvoiceUpdating());
        //TODO: Update Invoice item
        emit(InvoiceUpdated([event.item]));
      }
    });
  }
}
