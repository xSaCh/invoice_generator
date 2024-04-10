import 'package:bloc/bloc.dart';
import 'package:invoice_bloc/core/_models/customer.dart';
import 'package:invoice_bloc/core/_models/invoice.dart';
import 'package:invoice_bloc/core/_models/item.dart';
import 'package:invoice_bloc/data/repositories/invoice_repository.dart';
import 'package:invoice_bloc/global.dart';
import 'package:meta/meta.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final Invoice invoice;
  final InvoiceRepository repo;
  InvoiceBloc({required this.invoice})
      : repo = Global.ins().invoiceRepository,
        super(InvoiceInitial()) {
    on<InvoiceEvent>((event, emit) {
      if (!invoice.isInBox) repo.addInvoice(invoice);

      if (event is InvoiceAddItem) {
        emit(InvoiceUpdating());
        // invoice.items.add(event.item);
        // invoice.save();
        repo.addItemToInvoice(invoice.key, event.item);
        emit(InvoiceUpdated());
      } else if (event is InvoiceRemoveItem) {
        emit(InvoiceUpdating());
        // invoice.items.removeAt(event.index);
        // invoice.save();
        repo.removeItemToInvoice(invoice.key, event.index);
        emit(InvoiceUpdated());
      } else if (event is InvoiceUpdateItem) {
        emit(InvoiceUpdating());
        // invoice.items[event.index] = event.item;
        // invoice.save();
        repo.updateItemToInvoice(invoice.key, event.index, event.item);
        emit(InvoiceUpdated());
      } else if (event is InvoiceUpdateInvoiceValue) {
        emit(InvoiceUpdating());

        invoice.invoiceNo = event.invoiceNo ?? invoice.invoiceNo;
        invoice.date = event.date ?? invoice.date;
        invoice.customer = event.customer ?? invoice.customer;
        invoice.receivedAmt = event.receivedAmt ?? invoice.receivedAmt;

        repo.updateInvoice(invoice);
        // invoice.save();
        emit(InvoiceUpdated());
      }
    });
  }
}
