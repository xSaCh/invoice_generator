import 'package:bloc/bloc.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/item.dart';
import 'package:meta/meta.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc({required Invoice invoice}) : super(InvoiceInitial()) {
    on<InvoiceEvent>((event, emit) {
      if (event is InvoiceAddItem) {
        emit(InvoiceUpdating());
        //TODO: Add Invoice item
        invoice.items.add(event.item);
        invoice.save();
        emit(InvoiceUpdated());
      } else if (event is InvoiceRemoveItem) {
        emit(InvoiceUpdating());
        //TODO: Remove Invoice item
        invoice.items.removeAt(event.index);
        invoice.save();
        emit(InvoiceUpdated());
      }
      if (event is InvoiceUpdateItem) {
        emit(InvoiceUpdating());
        //TODO: Update Invoice item
        invoice.items[event.index] = event.item;
        invoice.save();
        emit(InvoiceUpdated());
      }
    });
  }
}
