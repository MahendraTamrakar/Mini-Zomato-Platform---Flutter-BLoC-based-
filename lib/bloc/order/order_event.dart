import '../../models/cart_item.dart';

abstract class OrderEvent {}

class PlaceOrder extends OrderEvent {
  final List<CartItem> items;
  final String deliveryAddress;

  PlaceOrder({required this.items, required this.deliveryAddress});
}
