import '../../models/cart_item.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;

  CartLoaded({required this.items, required this.subtotal});

  double get total => subtotal + deliveryFee;
  double get deliveryFee => 50.0; // Fixed delivery fee
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});
}
