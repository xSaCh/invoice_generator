part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceState {}

final class InvoiceInitial extends InvoiceState {}

final class InvoiceUpdating extends InvoiceState {}

final class InvoiceUpdated extends InvoiceState {
  final List<Item> items;
  InvoiceUpdated(this.items);
}

final class InvoiceError extends InvoiceState {}
