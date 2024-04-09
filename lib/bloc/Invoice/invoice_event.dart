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
