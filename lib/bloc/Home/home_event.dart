part of 'home_bloc.dart';

sealed class HomeEvent {}

class HomeGetInvoices extends HomeEvent {}

class HomeRemoveInvoice extends HomeEvent {
  Invoice invoice;

  HomeRemoveInvoice(this.invoice);
}

class HomeAddInvoice extends HomeEvent {
  Invoice invoice;

  HomeAddInvoice(this.invoice);
}

class HomeAddCustomer extends HomeEvent {
  Customer customer;

  HomeAddCustomer(this.customer);
}

class HomeUpdateInvoices extends HomeEvent {}
