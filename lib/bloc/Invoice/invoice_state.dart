part of 'invoice_bloc.dart';

@immutable
sealed class InvoiceState {}

final class InvoiceInitial extends InvoiceState {}

final class InvoiceUpdating extends InvoiceState {}

final class InvoiceUpdated extends InvoiceState {
  InvoiceUpdated();
}

final class InvoiceError extends InvoiceState {}
