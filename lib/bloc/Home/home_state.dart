part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<Invoice> invoices;
  HomeLoaded(this.invoices);
}

final class HomeError extends HomeState {}
