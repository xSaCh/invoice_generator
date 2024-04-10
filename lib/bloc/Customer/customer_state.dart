part of 'customer_bloc.dart';

@immutable
sealed class CustomerState {}

final class CustomerInitial extends CustomerState {}

final class CustomerUpdating extends CustomerState {}

final class CustomerUpdated extends CustomerState {}

final class CustomerError extends CustomerState {}
