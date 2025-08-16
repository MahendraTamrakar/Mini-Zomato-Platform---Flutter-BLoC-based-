import '../../models/order.dart';

abstract class OrderHistoryState {}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<Order> orders;

  OrderHistoryLoaded({required this.orders});
}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  OrderHistoryError({required this.message});
}
