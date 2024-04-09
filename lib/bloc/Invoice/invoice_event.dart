// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceEvent {}

class InvoiceAddItem extends InvoiceEvent {
  final Item item;

  InvoiceAddItem(this.item);
}

class InvoiceUpdateItem extends InvoiceEvent {
  final Item item;
  final int index;
  InvoiceUpdateItem(this.index, this.item);
}

class InvoiceRemoveItem extends InvoiceEvent {
  final int index;

  InvoiceRemoveItem(this.index);
}

class InvoiceUpdateInvoiceValue extends InvoiceEvent {
  final String? invoiceNo;
  final DateTime? date;
  final double? receivedAmt;

  final Customer? customer;
  InvoiceUpdateInvoiceValue({
    this.invoiceNo,
    this.date,
    this.receivedAmt,
    this.customer,
  });
}
