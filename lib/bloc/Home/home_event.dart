part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeGetInvoices extends HomeEvent {}

class HomeRemoveInvoice extends HomeEvent {
  Invoice invoice;

  HomeRemoveInvoice(this.invoice);
}
