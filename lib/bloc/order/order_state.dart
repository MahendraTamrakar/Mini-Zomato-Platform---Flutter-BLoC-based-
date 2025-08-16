import 'package:mini_zomato_platform/models/order.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {
  final Order order;

  OrderPlaced({required this.order});
}

class OrderError extends OrderState {
  final String message;

  OrderError({required this.message});
}
