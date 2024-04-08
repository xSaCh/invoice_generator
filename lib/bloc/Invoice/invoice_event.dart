part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceEvent {}

class InvoiceAddItem extends InvoiceEvent {
  final Item item;

  InvoiceAddItem(this.item);
}

class InvoiceUpdateItem extends InvoiceEvent {
  final Item item;

  InvoiceUpdateItem(this.item);
}

class InvoiceRemoveItem extends InvoiceEvent {
  final Item item;

  InvoiceRemoveItem(this.item);
}
